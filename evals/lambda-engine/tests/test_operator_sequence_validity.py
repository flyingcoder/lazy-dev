import pytest
from deepeval.test_case import LLMTestCase

from deepeval_metrics.operator_sequence_metric import OperatorSequenceValidityMetric
from fixtures.operator_sequence_cases import CASES


@pytest.mark.parametrize("case", CASES, ids=[c.id for c in CASES])
def test_operator_sequence_validity(case):
    test_case = LLMTestCase(
        input="State the operator sequence you applied.",
        actual_output=case.actual_output,
    )
    metric = OperatorSequenceValidityMetric()
    metric.measure(test_case)
    assert metric.is_successful() == case.expect_pass, metric.reason
