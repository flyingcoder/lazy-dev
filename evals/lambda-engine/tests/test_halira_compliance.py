import pytest
from deepeval.test_case import LLMTestCase

from deepeval_metrics.halira_compliance_metric import HALIRAComplianceMetric
from fixtures.halira_cases import CASES


@pytest.mark.parametrize("case", CASES, ids=[c.id for c in CASES])
def test_halira_compliance(case):
    test_case = LLMTestCase(
        input="Walk through the HALIRA protocol for this foundational contradiction.",
        actual_output=case.actual_output,
    )
    metric = HALIRAComplianceMetric()
    metric.measure(test_case)
    assert metric.is_successful() == case.expect_pass, metric.reason
