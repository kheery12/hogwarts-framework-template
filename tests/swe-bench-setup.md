# SWE-Bench Framework Testing Setup

Test v3 vs v4 frameworks using real-world software engineering tasks.

## What is SWE-Bench?

Industry-standard benchmark that tests AI coding assistants on **real GitHub issues** from popular open-source projects. Models must generate patches that actually fix the bugs.

**Metrics:**
- **Resolve Rate**: % of issues successfully fixed
- **Token Efficiency**: Tokens used per task
- **Time to Resolution**: How long each fix took

**Expected Performance:**
- 0-5%: Poor
- 15-25%: Solid
- 30%+: Outstanding

## Prerequisites

```bash
# Check you have everything
python3 --version   # Need 3.8+
docker --version    # Need Docker running
claude --version    # Need Claude Code CLI

# Configure Docker (Mac/Windows)
# Docker Desktop → Settings → Resources → Memory: 8GB minimum
```

## Setup SWE-Bench

```bash
# 1. Clone the repo
cd ~/Desktop
git clone https://github.com/jimmc414/claudecode_gemini_and_codex_swebench
cd claudecode_gemini_and_codex_swebench

# 2. Install dependencies
python -m pip install -r requirements.txt

# 3. Verify setup
python swe_bench.py list-models
```

## Test Strategy

Run **quick tests** (10 instances, ~1-2 hours each) with both frameworks:

### Test 1: v3 Framework
```bash
# Activate v3
cd ~/Desktop/Claude-Master/hogwarts-framework-template
git checkout v3.1.0-stable
export CLAUDE_PROJECT_DIR=$(pwd)

# Run SWE-Bench
cd ~/Desktop/claudecode_gemini_and_codex_swebench
python swe_bench.py run --model opus-4.6 --quick --output v3-results

# Copy results
cp benchmark_scores.log ../hogwarts-framework-template/tests/results/v3-scores.json
cp -r predictions/ ../hogwarts-framework-template/tests/results/v3-predictions/
```

### Test 2: v4 Framework
```bash
# Activate v4
cd ~/Desktop/Claude-Master/hogwarts-framework-template
git checkout v4-development
export CLAUDE_PROJECT_DIR=$(pwd)

# Run SWE-Bench
cd ~/Desktop/claudecode_gemini_and_codex_swebench
python swe_bench.py run --model opus-4.6 --quick --output v4-results

# Copy results
cp benchmark_scores.log ../hogwarts-framework-template/tests/results/v4-scores.json
cp -r predictions/ ../hogwarts-framework-template/tests/results/v4-predictions/
```

## Visual Comparison

After both tests complete, run the comparison script:

```bash
cd ~/Desktop/Claude-Master/hogwarts-framework-template/tests
python compare-frameworks.py
```

This generates:
- `comparison-report.html` — Interactive visual dashboard
- `comparison-chart.png` — Side-by-side bar chart
- `comparison-summary.md` — Markdown summary

## What Gets Tested

SWE-Bench uses real bugs from projects like:
- Django (web framework)
- Flask (web framework)
- Matplotlib (plotting library)
- Pytest (testing framework)
- Requests (HTTP library)
- Scikit-learn (machine learning)

Each task is a real GitHub issue with:
1. Bug description
2. Test suite that currently fails
3. Expected behavior

Claude must:
1. Understand the issue
2. Locate relevant code
3. Generate a patch
4. Verify tests pass

## Interpreting Results

**Key Metrics:**

| Metric | What it Means | Better is |
|--------|---------------|-----------|
| Resolve Rate | % of bugs actually fixed | Higher |
| Avg Tokens/Task | Token efficiency | Lower |
| Avg Time/Task | Speed to resolution | Lower |
| First-Try Success | Fixed without iterations | Higher |

**Winner Criteria:**
- v4 wins if: Higher resolve rate OR (same resolve rate + lower tokens)
- v3 wins if: Higher resolve rate despite higher tokens
- Tie if: Same resolve rate + similar token usage

## Timeline

- **Setup**: 30 minutes
- **v3 Test**: 1-2 hours (10 tasks)
- **v4 Test**: 1-2 hours (10 tasks)
- **Analysis**: 15 minutes
- **Total**: ~4 hours

## Notes

- Run tests when you can leave computer running
- Don't interrupt during tests (Docker containers running)
- Both tests must use same `--quick` or `--standard` setting
- If test fails, check Docker has 8GB+ RAM allocated
