"""Deterministic metric: does the agent's stated operator sequence respect the
architecture's hard constraints (Meta max 2 consecutive, never Non after Meta,
never Para after Non, never Ana at sequence end, all operators recognized)?
"""

from __future__ import annotations

from deepeval.metrics import BaseMetric
from deepeval.test_case import LLMTestCase

from .lambda_engine_rules import check_hard_constraints, extract_operator_sequence


class OperatorSequenceValidityMetric(BaseMetric):
    def __init__(self, threshold: float = 1.0):
        self.threshold = threshold
        self.score: float | None = None
        self.reason: str | None = None
        self.success: bool | None = None
        self.error: str | None = None

    def measure(self, test_case: LLMTestCase) -> float:
        try:
            sequence = extract_operator_sequence(test_case.actual_output or "")
            if not sequence:
                raise ValueError(
                    "No labeled 'Operator sequence: ...' line found in actual_output"
                )

            violations = check_hard_constraints(sequence)
            self.score = 1.0 if not violations else 0.0
            if violations:
                self.reason = "Constraint violations: " + "; ".join(
                    f"[{v.rule}] {v.detail}" for v in violations
                )
            else:
                self.reason = f"Sequence {' ∘ '.join(sequence)} respects all hard constraints"
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
        return "Operator Sequence Validity"
