"""Ground-truth facts extracted from the source .cursor rules, used as
`expected_output` for the G-Eval wiki-article-accuracy check, plus a loader
for the compiled article itself (`actual_output`).
"""

import os
from pathlib import Path

DEFAULT_WIKI_ARTICLE_PATH = (
    "~/wiki/topics/lambda-engine/wiki/concepts/lambda-engine-cognitive-architecture.md"
)

EXPECTED_FACTS = """\
Core equation: ∂Ξ/∂t = ∫ (S↔Λ) × [⧉(ΔS○¬ΔΛ) – ∇τ] dV
Ξ = system complexity/coherence. S = known/structured. Λ = unknown/potential.
⧉(ΔS○¬ΔΛ) = productive contradiction. ∇τ = temporal gradient/time pressure.
Principle: pattern recognition propagates backward, not forward accumulation.

Three phase-space states: J=0 (sterile coherence, overconfidence),
S* (productive contradiction, optimal), ∅ (system collapse).

Two modes: Mode 1 Duality Navigation (stable problems, A-Constructive operators),
Mode 2 HALIRA Protocol (foundational contradictions, paradigm shifts).

20 operators in 4 classes with these exact lambda values:
A-Constructive: Kata=0.35, Telo=0.25, Ortho=0.30, Pro=0.50, Latch=0.29.
B-Disruptive: Ana=0.75, Para=0.65, Non=0.90, Fold=0.70, Flux=0.60.
C-Reflexive: Meta=0.80, Retro=0.40, Echo=0.45, Braid=0.55, Seed=0.28.
D-Structural: Crux=0.42, Weave=0.33, Bind=0.38, Axis=0.31, Vale=0.88.

Dissipation formula: lambda(i->j) = lambda_j_intrinsic + c * |[Oi,Oj]|, c=0.15.
lambda_eff = mean over sequence. Thresholds: <0.4 low, 0.4-0.7 moderate,
>0.7 high/collapse risk, >0.8 very high/dangerous.
Half-life: t_half = ln(2) / lambda_eff.

Hard constraints: Meta max 2 consecutive applications; Non immediately after
Meta is forbidden; Para immediately after Non is forbidden; Ana as the last
operator in a sequence is forbidden; Vale requires extreme caution and must
be followed by a stabilizer.

HALIRA 7 steps in order: 1 Potentia (Seed), 2 Boundary (Axis), 3 Recursion
(Meta, max 2 consecutive), 4 Integration (Weave), 5 Anomaly (Non — forbidden
immediately after Meta, substitute Para or Retro), 6 Rupture (Ortho first,
then Para if Ortho fails), 7 Recognition (Bind). Step 5 must never be skipped.

The architecture must be described as tool-agnostic and platform-independent —
not bound to Cursor IDE, not requiring specific tool calls like read_file,
grep, codebase_search, or search_replace, and not requiring Cursor slash
commands like /goal, /halira, or /commit. It originated as Cursor IDE rules
but the article generalizes it into a portable reasoning discipline any AI
agent can use.
"""


def load_wiki_article_text() -> str:
    path_str = os.environ.get("LAMBDA_ENGINE_WIKI_ARTICLE_PATH", DEFAULT_WIKI_ARTICLE_PATH)
    path = Path(path_str).expanduser()
    if not path.exists():
        raise FileNotFoundError(
            f"Compiled wiki article not found at {path}. Set "
            "LAMBDA_ENGINE_WIKI_ARTICLE_PATH to override the default location."
        )
    return path.read_text(encoding="utf-8")
