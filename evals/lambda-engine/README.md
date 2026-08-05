# Lambda Engine DeepEval Suite

Evaluates whether agent transcripts comply with the Lambda Engine cognitive
architecture. Normative source: [`lambda-engine/CORE.md`](../../lambda-engine/CORE.md)
(output convention: `State:` / `Mode:` / `Operator sequence:` / `Dissipation:`).
Narrative write-up: `wiki/wiki/concepts/lambda-engine-cognitive-architecture.md`.
Four test categories, three of them fully offline:

| Test file | Metric | Live LLM call? |
|---|---|---|
| `test_state_mode_detection.py` | `StateModeDetectionMetric` | No — deterministic |
| `test_operator_sequence_validity.py` | `OperatorSequenceValidityMetric` | No — deterministic |
| `test_halira_compliance.py` | `HALIRAComplianceMetric` | No — deterministic |
| `test_wiki_article_accuracy.py` | `GEval` (Claude judge) | Yes — needs `ANTHROPIC_API_KEY` |

The three deterministic metrics encode the architecture's hard constraints
(Meta max 2 consecutive, never Non after Meta, never Para after Non, never Ana
at sequence end, HALIRA step order and the Meta→Non substitution rule) directly
in Python, ported from `deepeval_metrics/lambda_engine_rules.py`. They score
**fixture transcripts** (see `fixtures/`) — a mix of compliant and
deliberately rule-violating examples — so this suite is both a regression test
of the metrics themselves and reusable scoring logic for real agent
transcripts (swap fixture text for live model output without changing the
metric code).

The fourth test is a G-Eval metric that asks Claude to fact-check the compiled
wiki article against a ground-truth fact sheet extracted from the original
`.cursor` rules (`fixtures/wiki_article_facts.py`), and to flag any
reintroduced Cursor-specific tool bindings.

## Setup

```bash
cd evals/lambda-engine
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run the offline tests (no API key required)

```bash
pytest tests/test_state_mode_detection.py tests/test_operator_sequence_validity.py tests/test_halira_compliance.py -v
```

## Run the wiki-article G-Eval test (requires Anthropic API key)

```bash
export ANTHROPIC_API_KEY=<your-key>
pytest tests/test_wiki_article_accuracy.py -v
```

Without `ANTHROPIC_API_KEY` set, this test is automatically skipped.

Override the judge model with `LAMBDA_ENGINE_EVAL_JUDGE_MODEL` (default
`claude-3-7-sonnet-latest`), and override which article file is checked with
`LAMBDA_ENGINE_WIKI_ARTICLE_PATH`.

## Run everything

```bash
pytest -v
```

or, using DeepEval's own test runner (adds Confident AI reporting if logged in):

```bash
deepeval test run tests/
```

## Extending

To evaluate live agent output instead of fixtures, build an `LLMTestCase` with
`actual_output` set to a real model response (containing the same labeled
`State:`/`Mode:`/`Operator sequence:`/`Step N (...)` conventions the fixtures
use) and pass it through the existing metrics — no metric code changes needed.
