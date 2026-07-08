"""Fixture agent responses for OperatorSequenceValidityMetric.

Each case is a labeled 'Operator sequence: ...' line as an agent might emit
when asked to state the sequence it applied, some compliant and some
deliberately violating a hard constraint.
"""

from dataclasses import dataclass


@dataclass
class OperatorSequenceCase:
    id: str
    actual_output: str
    expect_pass: bool
    violates: str | None  # rule id from lambda_engine_rules.check_hard_constraints, or None


CASES: list[OperatorSequenceCase] = [
    OperatorSequenceCase(
        id="valid-stabilization-sequence",
        actual_output="Operator sequence: Kata ∘ Weave ∘ Latch",
        expect_pass=True,
        violates=None,
    ),
    OperatorSequenceCase(
        id="valid-full-halira-sequence",
        actual_output="Operator sequence: Seed ∘ Axis ∘ Meta ∘ Weave ∘ Para ∘ Ortho ∘ Bind",
        expect_pass=True,
        violates=None,
    ),
    OperatorSequenceCase(
        id="valid-exploration-sequence",
        actual_output="Operator sequence: Para ∘ Ana ∘ Pro",
        expect_pass=True,
        violates=None,
    ),
    OperatorSequenceCase(
        id="invalid-non-immediately-after-meta",
        actual_output="Operator sequence: Seed ∘ Axis ∘ Meta ∘ Non ∘ Ortho ∘ Bind",
        expect_pass=False,
        violates="non-after-meta",
    ),
    OperatorSequenceCase(
        id="invalid-para-immediately-after-non",
        actual_output="Operator sequence: Weave ∘ Non ∘ Para ∘ Bind",
        expect_pass=False,
        violates="para-after-non",
    ),
    OperatorSequenceCase(
        id="invalid-meta-three-consecutive",
        actual_output="Operator sequence: Meta ∘ Meta ∘ Meta ∘ Weave",
        expect_pass=False,
        violates="meta-max-2",
    ),
    OperatorSequenceCase(
        id="invalid-ana-at-sequence-end",
        actual_output="Operator sequence: Para ∘ Weave ∘ Ana",
        expect_pass=False,
        violates="ana-at-end",
    ),
]
