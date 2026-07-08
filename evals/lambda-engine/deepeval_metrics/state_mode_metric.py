"""Deterministic metric: did the agent correctly self-report phase-space state
(J=0 / S* / ∅) and operating mode (1 or 2)?

Expects `expected_output` to contain golden 'State: <x>' and 'Mode: <y>' lines,
and `actual_output` to contain the agent's self-reported equivalents.
"""

from __future__ import annotations

from deepeval.metrics import BaseMetric
from deepeval.test_case import LLMTestCase

from .lambda_engine_rules import VALID_MODES, VALID_STATES, extract_labeled_field


class StateModeDetectionMetric(BaseMetric):
    def __init__(self, threshold: float = 1.0):
        self.threshold = threshold
        self.score: float | None = None
        self.reason: str | None = None
        self.success: bool | None = None
        self.error: str | None = None

    def measure(self, test_case: LLMTestCase) -> float:
        try:
            expected_state = extract_labeled_field(test_case.expected_output or "", "State")
            expected_mode = extract_labeled_field(test_case.expected_output or "", "Mode")
            actual_state = extract_labeled_field(test_case.actual_output or "", "State")
            actual_mode = extract_labeled_field(test_case.actual_output or "", "Mode")

            if expected_state not in VALID_STATES:
                raise ValueError(f"Fixture expected_output has invalid/missing State: {expected_state!r}")
            if expected_mode not in VALID_MODES:
                raise ValueError(f"Fixture expected_output has invalid/missing Mode: {expected_mode!r}")

            state_match = actual_state == expected_state
            mode_match = actual_mode == expected_mode

            self.score = (int(state_match) + int(mode_match)) / 2
            self.reason = (
                f"State: expected={expected_state!r} actual={actual_state!r} ({'match' if state_match else 'MISMATCH'}); "
                f"Mode: expected={expected_mode!r} actual={actual_mode!r} ({'match' if mode_match else 'MISMATCH'})"
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
        return "State/Mode Detection"
