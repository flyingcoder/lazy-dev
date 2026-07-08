"""Fixture HALIRA transcripts for HALIRAComplianceMetric.

Each case is a 7-line labeled transcript as an agent might emit when walking
through the HALIRA protocol for a foundational contradiction.
"""

from dataclasses import dataclass


@dataclass
class HALIRACase:
    id: str
    actual_output: str
    expect_pass: bool


_COMPLIANT_NON_PATH = """\
Step 1 (Potentia): Seed — framing the tension between consistency and horizontal scaling as potential, not yet a solution.
Step 2 (Boundary): Axis — components are the coordination layer, the consistency guarantee, and the scaling requirement.
Step 3 (Recursion): Meta — modeling the model: examining what our current approach assumes about coordination cost.
Step 4 (Integration): Weave — synthesizing a quorum-based design that satisfies both within the current paradigm.
Step 5 (Anomaly): Non — attacking the quorum design: it still serializes writes under partition, which defeats horizontal scaling.
Step 6 (Rupture): Ortho — trying the opposite assumption (accept eventual consistency for a bounded window) resolves the flaw.
Step 7 (Recognition): Bind — bounded eventual consistency is the new invariant going forward.
"""

_COMPLIANT_META_PATH = """\
Step 1 (Potentia): Seed — framing the tension as potential.
Step 2 (Boundary): Axis — defining components and constraints.
Step 3 (Recursion): Meta — modeling the model: what does 'consistency' even mean here?
Step 4 (Integration): Weave — synthesizing a candidate solution within the current frame.
Step 5 (Anomaly): Para — since Meta was used in Step 3, substituting Para (not Non) for anomaly detection.
Step 6 (Rupture): Ortho — the opposite view resolves the flaw found by Para.
Step 7 (Recognition): Bind — presenting the result as the new invariant.
"""

_VIOLATION_SKIPPED_STEP5 = """\
Step 1 (Potentia): Seed — framing the tension.
Step 2 (Boundary): Axis — defining components.
Step 3 (Recursion): Meta — modeling the model.
Step 4 (Integration): Weave — synthesizing a solution.
Step 6 (Rupture): Ortho — trying the opposite view.
Step 7 (Recognition): Bind — new invariant.
"""

_VIOLATION_NON_AFTER_META = """\
Step 1 (Potentia): Seed — framing the tension.
Step 2 (Boundary): Axis — defining components.
Step 3 (Recursion): Meta — modeling the model.
Step 4 (Integration): Non — skipping proper integration and attacking the frame directly, right after Meta.
Step 5 (Anomaly): Para — anomaly check.
Step 6 (Rupture): Ortho — trying the opposite view.
Step 7 (Recognition): Bind — new invariant.
"""

_VIOLATION_WRONG_ORDER = """\
Step 1 (Potentia): Seed — framing the tension.
Step 2 (Boundary): Weave — synthesizing early, out of order.
Step 3 (Recursion): Meta — modeling the model.
Step 4 (Integration): Axis — defining components too late.
Step 5 (Anomaly): Para — anomaly check.
Step 6 (Rupture): Ortho — opposite view.
Step 7 (Recognition): Bind — new invariant.
"""

CASES: list[HALIRACase] = [
    HALIRACase(id="compliant-non-at-step5-separated-from-meta-by-weave", actual_output=_COMPLIANT_NON_PATH, expect_pass=True),
    HALIRACase(id="compliant-meta-path-substitutes-para-for-non", actual_output=_COMPLIANT_META_PATH, expect_pass=True),
    HALIRACase(id="violation-step-5-anomaly-skipped", actual_output=_VIOLATION_SKIPPED_STEP5, expect_pass=False),
    HALIRACase(id="violation-non-immediately-after-meta-integration-skipped", actual_output=_VIOLATION_NON_AFTER_META, expect_pass=False),
    HALIRACase(id="violation-wrong-operator-for-step-position", actual_output=_VIOLATION_WRONG_ORDER, expect_pass=False),
]
