"""G-Eval metric: does the compiled wiki article stay factually consistent with
the extracted source facts (operator lambda values, equation terms, HALIRA
steps) and does it avoid re-introducing Cursor-specific tool bindings that the
generalization was supposed to strip out?

Unlike the other three metrics, this one requires a live LLM judge call
(ANTHROPIC_API_KEY) since G-Eval's grading step is itself an LLM call.
"""

from __future__ import annotations

import os

from deepeval.metrics import GEval
from deepeval.test_case import SingleTurnParams


def build_wiki_accuracy_metric(threshold: float = 0.7) -> GEval:
    model_name = os.environ.get("LAMBDA_ENGINE_EVAL_JUDGE_MODEL", "claude-3-7-sonnet-latest")

    try:
        from deepeval.models import AnthropicModel

        judge_model = AnthropicModel(model=model_name, temperature=0)
    except ImportError as e:  # pragma: no cover
        raise RuntimeError(
            "deepeval.models.AnthropicModel unavailable — check deepeval version "
            "and that ANTHROPIC_API_KEY is set"
        ) from e

    return GEval(
        name="Wiki Article Factual Accuracy",
        criteria=(
            "Determine whether the 'actual output' (a compiled wiki article about the "
            "Lambda Engine cognitive architecture) is factually consistent with the "
            "'expected output' (extracted ground-truth facts from the original source "
            "rules), and whether it avoids describing the architecture in terms of any "
            "specific IDE, editor, or tool-call bindings (e.g. it must not say the "
            "reader must use Cursor, or name specific tool functions like read_file/"
            "grep/codebase_search as part of the architecture itself)."
        ),
        evaluation_steps=[
            "Check whether any numeric value (e.g. an operator's lambda) in the actual "
            "output contradicts the corresponding value in the expected output",
            "Check whether any named concept (equation term, phase-space state, HALIRA "
            "step, forbidden sequence) in the actual output contradicts or omits a "
            "concept present in the expected output",
            "Check whether the actual output frames the architecture as tool-agnostic, "
            "rather than bound to a specific IDE or tool-call surface",
            "Vague language or paraphrasing is fine; only penalize actual factual "
            "contradictions, omissions of concepts explicitly listed in expected "
            "output, or reintroduced tool-specific framing",
        ],
        evaluation_params=[
            SingleTurnParams.INPUT,
            SingleTurnParams.ACTUAL_OUTPUT,
            SingleTurnParams.EXPECTED_OUTPUT,
        ],
        model=judge_model,
        threshold=threshold,
    )
