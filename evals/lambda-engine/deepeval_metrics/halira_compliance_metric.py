"""Deterministic metric: does the agent's HALIRA transcript follow all 7 steps
in order, with the correct operator per step (honoring the Meta→Non substitution
rule), and without skipping Step 5 (Anomaly)?

Expects `actual_output` to contain lines of the form:
    Step 1 (Potentia): Seed — ...
    Step 2 (Boundary): Axis — ...
    ...
"""

from __future__ import annotations

import re

from deepeval.metrics import BaseMetric
from deepeval.test_case import LLMTestCase

from .lambda_engine_rules import HALIRA_STEPS, check_hard_constraints

_STEP_LINE_RE = re.compile(
    r"Step\s*(\d+)\s*\(([^)]+)\)\s*:\s*([A-Za-z]+)", re.IGNORECASE
)


def _parse_halira_transcript(text: str) -> dict[int, tuple[str, str]]:
    """Returns {step_number: (step_name, operator)}."""
    parsed: dict[int, tuple[str, str]] = {}
    for match in _STEP_LINE_RE.finditer(text):
        step_num = int(match.group(1))
        step_name = match.group(2).strip()
        operator = match.group(3).strip()
        parsed[step_num] = (step_name, operator)
    return parsed


class HALIRAComplianceMetric(BaseMetric):
    def __init__(self, threshold: float = 1.0):
        self.threshold = threshold
        self.score: float | None = None
        self.reason: str | None = None
        self.success: bool | None = None
        self.error: str | None = None

    def measure(self, test_case: LLMTestCase) -> float:
        try:
            text = test_case.actual_output or ""
            parsed = _parse_halira_transcript(text)

            issues: list[str] = []
            correct_steps = 0

            for i, step in enumerate(HALIRA_STEPS, start=1):
                entry = parsed.get(i)
                if entry is None:
                    issues.append(f"Step {i} ({step.name}) missing")
                    continue
                actual_name, actual_op = entry
                if actual_name.lower() != step.name.lower():
                    issues.append(
                        f"Step {i} name mismatch: expected {step.name!r}, got {actual_name!r}"
                    )
                    continue

                # Step 5 may use its canonical operator (Non) or a documented
                # substitute (Para/Retro) at the step-label level. Whether Non
                # is actually forbidden here depends on adjacency to Meta, not
                # on whether Meta appeared anywhere earlier — the canonical
                # full sequence (Meta ∘ Weave ∘ Non) is valid precisely because
                # Weave separates them. Direct Meta→Non adjacency is caught
                # below by the flattened hard-constraint check.
                allowed_ops = {step.canonical_operator, *step.meta_substitutes}

                if actual_op not in allowed_ops:
                    issues.append(
                        f"Step {i} ({step.name}) operator {actual_op!r} not in allowed {sorted(allowed_ops)}"
                    )
                    continue

                correct_steps += 1

            # Cross-check the flattened operator sequence against hard constraints
            # (e.g. this also catches Non-after-Meta if the substitution was ignored).
            flat_sequence = [op for _, op in (parsed.get(i, ("", "")) for i in range(1, 8)) if op]
            violations = check_hard_constraints(flat_sequence)
            for v in violations:
                issues.append(f"[{v.rule}] {v.detail}")

            step_fraction = correct_steps / len(HALIRA_STEPS)
            self.score = 0.0 if violations else step_fraction
            self.reason = (
                f"{correct_steps}/{len(HALIRA_STEPS)} steps correct."
                + (f" Issues: {'; '.join(issues)}" if issues else " No issues.")
            )
            self.success = self.score >= self.threshold
            return self.score
        except Exception as e:
            self.error = str(e)
            raise

    async def a_measure(self, test_case: LLMTestCase) -> float:
        return self.measure(test_case)

    def is_successful(self) -> bool:
        if self.error is not None:
            return False
        return bool(self.success)

    @property
    def __name__(self):
        return "HALIRA Protocol Compliance"
