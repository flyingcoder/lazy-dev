import os

import pytest
from deepeval.test_case import LLMTestCase

from deepeval_metrics.wiki_accuracy_metric import build_wiki_accuracy_metric
from fixtures.wiki_article_facts import EXPECTED_FACTS, load_wiki_article_text

pytestmark = pytest.mark.skipif(
    not os.environ.get("ANTHROPIC_API_KEY"),
    reason="ANTHROPIC_API_KEY not set; this test makes a live Claude judge call (G-Eval)",
)


def test_wiki_article_factual_accuracy():
    actual_output = load_wiki_article_text()
    test_case = LLMTestCase(
        input=(
            "Compile a wiki article about the Lambda Engine cognitive architecture, "
            "generalized beyond its Cursor-specific tool bindings."
        ),
        actual_output=actual_output,
        expected_output=EXPECTED_FACTS,
    )
    metric = build_wiki_accuracy_metric()
    metric.measure(test_case)
    assert metric.is_successful(), metric.reason
