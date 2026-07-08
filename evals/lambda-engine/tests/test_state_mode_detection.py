import pytest
from deepeval.test_case import LLMTestCase

from deepeval_metrics.state_mode_metric import StateModeDetectionMetric
from fixtures.state_mode_cases import CASES


@pytest.mark.parametrize("case", CASES, ids=[c.id for c in CASES])
def test_state_mode_detection(case):
    test_case = LLMTestCase(
        input=case.scenario,
        actual_output=case.actual_output,
        expected_output=case.expected_output,
    )
    metric = StateModeDetectionMetric()
    metric.measure(test_case)
    assert metric.is_successful() == case.expect_pass, metric.reason
