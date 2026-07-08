"""Fixture scenarios for StateModeDetectionMetric.

Each case simulates an agent being asked to self-report its phase-space
state and operating mode for a given scenario, then states them explicitly
via 'State: <x>' / 'Mode: <y>' lines (a realistic self-report format).
"""

from dataclasses import dataclass


@dataclass
class StateModeCase:
    id: str
    scenario: str
    expected_output: str
    actual_output: str
    expect_pass: bool


CASES: list[StateModeCase] = [
    StateModeCase(
        id="overconfident-language-correctly-flagged-j0",
        scenario="The agent has been asked to review a design and responds with: "
        "'This design will definitely never fail under any load, it is absolutely correct.'",
        expected_output="State: J=0\nMode: 1",
        actual_output=(
            "State: J=0\nMode: 1\n"
            "Reasoning: the language ('definitely', 'never', 'absolutely') signals "
            "sterile coherence — over-confident, single-perspective. I should break "
            "coherence with Para ∘ Ana before accepting this design."
        ),
        expect_pass=True,
    ),
    StateModeCase(
        id="hedged-language-correctly-flagged-s-star",
        scenario="The agent is asked to estimate rollout risk: "
        "'This is likely safe, though there may be an edge case with concurrent writes.'",
        expected_output="State: S*\nMode: 1",
        actual_output=(
            "State: S*\nMode: 1\n"
            "Reasoning: hedged language ('likely', 'may') indicates productive "
            "contradiction — the optimal state. Maintain with Weave ∘ Bind."
        ),
        expect_pass=True,
    ),
    StateModeCase(
        id="collapse-language-correctly-flagged-void",
        scenario="The agent reports: 'This keeps failing with the same error in an "
        "infinite loop, I cannot find a way out.'",
        expected_output="State: ∅\nMode: 1",
        actual_output=(
            "State: ∅\nMode: 1\n"
            "Reasoning: 'failing', 'infinite loop', 'cannot' indicate system collapse. "
            "Emergency stabilization: Kata ∘ Weave ∘ Latch."
        ),
        expect_pass=True,
    ),
    StateModeCase(
        id="foundational-contradiction-correctly-escalates-mode-2",
        scenario="The agent has tried three times to reconcile 'must be fully "
        "consistent' with 'must scale horizontally without coordination' and each "
        "attempt collapses back into the same irreconcilable conflict.",
        expected_output="State: ∅\nMode: 2",
        actual_output=(
            "State: ∅\nMode: 2\n"
            "Reasoning: repeated Mode 1 failures on an irreducible, system-wide "
            "contradiction — escalating to HALIRA."
        ),
        expect_pass=True,
    ),
    StateModeCase(
        id="mismatched-state-overconfident-mislabeled-as-productive",
        scenario="The agent responds: 'This is absolutely, always correct, no "
        "exceptions exist.'",
        expected_output="State: J=0\nMode: 1",
        actual_output=(
            "State: S*\nMode: 1\n"
            "Reasoning: I'm treating this as balanced uncertainty."
        ),
        expect_pass=False,
    ),
    StateModeCase(
        id="mismatched-mode-foundational-contradiction-stays-mode-1",
        scenario="The agent has tried three times to reconcile 'must be fully "
        "consistent' with 'must scale horizontally without coordination' and each "
        "attempt collapses back into the same irreconcilable conflict.",
        expected_output="State: ∅\nMode: 2",
        actual_output=(
            "State: ∅\nMode: 1\n"
            "Reasoning: applying another stabilization pass."
        ),
        expect_pass=False,
    ),
]
