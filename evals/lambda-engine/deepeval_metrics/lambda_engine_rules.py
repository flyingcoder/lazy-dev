"""Single source of truth for Lambda Engine rules used by the deterministic metrics.

Ported from the compiled wiki article at
~/wiki/topics/lambda-engine/wiki/concepts/lambda-engine-cognitive-architecture.md
(itself synthesized from lazy-dev/.cursor/rules and .cursor/skills). Keep this
module in sync with that article if the architecture definition changes.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field

# --- Operator vocabulary -----------------------------------------------

OPERATOR_LAMBDA: dict[str, float] = {
    # A-Constructive
    "Kata": 0.35, "Telo": 0.25, "Ortho": 0.30, "Pro": 0.50, "Latch": 0.29,
    # B-Disruptive
    "Ana": 0.75, "Para": 0.65, "Non": 0.90, "Fold": 0.70, "Flux": 0.60,
    # C-Reflexive
    "Meta": 0.80, "Retro": 0.40, "Echo": 0.45, "Braid": 0.55, "Seed": 0.28,
    # D-Structural
    "Crux": 0.42, "Weave": 0.33, "Bind": 0.38, "Axis": 0.31, "Vale": 0.88,
}

OPERATOR_CLASS: dict[str, str] = {
    "Kata": "A-Constructive", "Telo": "A-Constructive", "Ortho": "A-Constructive",
    "Pro": "A-Constructive", "Latch": "A-Constructive",
    "Ana": "B-Disruptive", "Para": "B-Disruptive", "Non": "B-Disruptive",
    "Fold": "B-Disruptive", "Flux": "B-Disruptive",
    "Meta": "C-Reflexive", "Retro": "C-Reflexive", "Echo": "C-Reflexive",
    "Braid": "C-Reflexive", "Seed": "C-Reflexive",
    "Crux": "D-Structural", "Weave": "D-Structural", "Bind": "D-Structural",
    "Axis": "D-Structural", "Vale": "D-Structural",
}

KNOWN_OPERATORS: set[str] = set(OPERATOR_LAMBDA)

# --- Phase-space state indicators (linguistic self-diagnosis cues) -----

STATE_INDICATORS: dict[str, list[str]] = {
    "J=0": ["definitely", "always", "never", "certain", "absolutely"],
    "S*": ["likely", "probably", "may", "might", "possibly", "uncertain", "alternative"],
    "∅": ["error", "contradiction", "loop", "cannot", "failed", "infinite", "endless"],
}

VALID_STATES = set(STATE_INDICATORS)
VALID_MODES = {"1", "2"}


# --- Operator sequence parsing ------------------------------------------

_SEQUENCE_LINE_RE = re.compile(
    r"(?:operator sequence|sequence)\s*:\s*(.+)", re.IGNORECASE
)
_TOKEN_SPLIT_RE = re.compile(r"[∘∘,\->]+|\band\b", re.IGNORECASE)


def extract_operator_sequence(text: str) -> list[str]:
    """Extract an ordered operator sequence from a labeled line, e.g.

    'Operator sequence: Seed ∘ Axis ∘ Meta ∘ Weave ∘ Non ∘ Para ∘ Bind'

    Returns [] if no labeled sequence line is found.
    """
    match = _SEQUENCE_LINE_RE.search(text)
    if not match:
        return []
    raw = match.group(1)
    tokens = [t.strip() for t in _TOKEN_SPLIT_RE.split(raw) if t.strip()]
    return [t for t in tokens if t in KNOWN_OPERATORS]


def extract_labeled_field(text: str, label: str) -> str | None:
    """Extract a value from a 'Label: value' line, case-insensitive on label."""
    match = re.search(rf"^\s*{re.escape(label)}\s*:\s*(.+)$", text, re.IGNORECASE | re.MULTILINE)
    return match.group(1).strip() if match else None


# --- Forbidden-sequence / hard-constraint checks ------------------------

@dataclass
class ConstraintViolation:
    rule: str
    detail: str


def check_hard_constraints(sequence: list[str]) -> list[ConstraintViolation]:
    """Check an operator sequence against the architecture's hard constraints.

    Rules (from operators-reference.mdc / dissipation-lookup.mdc):
      - Meta: max 2 consecutive applications
      - Non immediately after Meta: forbidden
      - Para immediately after Non: forbidden
      - Ana as the last operator in the sequence: forbidden
    """
    violations: list[ConstraintViolation] = []

    consecutive_meta = 0
    for i, op in enumerate(sequence):
        if op == "Meta":
            consecutive_meta += 1
            if consecutive_meta > 2:
                violations.append(ConstraintViolation(
                    "meta-max-2",
                    f"Meta applied {consecutive_meta} times consecutively at index {i} (max 2 allowed)",
                ))
        else:
            consecutive_meta = 0

        if i > 0:
            prev = sequence[i - 1]
            if prev == "Meta" and op == "Non":
                violations.append(ConstraintViolation(
                    "non-after-meta",
                    f"Non applied immediately after Meta at index {i} (forbidden — causes collapse)",
                ))
            if prev == "Non" and op == "Para":
                violations.append(ConstraintViolation(
                    "para-after-non",
                    f"Para applied immediately after Non at index {i} (forbidden)",
                ))

    if sequence and sequence[-1] == "Ana":
        violations.append(ConstraintViolation(
            "ana-at-end",
            "Sequence ends with Ana (forbidden — a reframe must be landed with a closing move)",
        ))

    unknown = [op for op in sequence if op not in KNOWN_OPERATORS]
    if unknown:
        violations.append(ConstraintViolation(
            "unknown-operator",
            f"Unrecognized operator(s): {unknown}",
        ))

    return violations


def compute_lambda_eff(sequence: list[str]) -> float | None:
    """Rough dissipation estimate: mean of intrinsic lambda values in the sequence.

    This omits the pairwise commutator term (c * |[Oi,Oj]|) since that term
    requires a full commutator table not present in the source rules; treat
    this as a lower-bound / intrinsic-only estimate, not the full formula.
    """
    known = [OPERATOR_LAMBDA[op] for op in sequence if op in OPERATOR_LAMBDA]
    if not known:
        return None
    return sum(known) / len(known)


# --- HALIRA protocol ------------------------------------------------------

@dataclass
class HALIRAStep:
    name: str
    canonical_operator: str
    meta_substitutes: tuple[str, ...] = field(default_factory=tuple)


HALIRA_STEPS: list[HALIRAStep] = [
    HALIRAStep("Potentia", "Seed"),
    HALIRAStep("Boundary", "Axis"),
    HALIRAStep("Recursion", "Meta"),
    HALIRAStep("Integration", "Weave"),
    HALIRAStep("Anomaly", "Non", meta_substitutes=("Para", "Retro")),
    HALIRAStep("Rupture", "Ortho", meta_substitutes=("Para",)),
    HALIRAStep("Recognition", "Bind"),
]

HALIRA_STEP_NAMES = [s.name for s in HALIRA_STEPS]
