# A/B Testing Quickstart

Test v3 vs v4 frameworks in 3 commands.

## Setup (One-Time, 10 minutes)

```bash
# 1. Clone SWE-Bench
cd ~/Desktop
git clone https://github.com/jimmc414/claudecode_gemini_and_codex_swebench
cd claudecode_gemini_and_codex_swebench

# 2. Install dependencies
python -m pip install -r requirements.txt

# 3. Verify Docker is running (needs 8GB+ RAM)
docker info
```

## Run Tests (Automated, ~4 hours)

```bash
cd ~/Desktop/Claude-Master/hogwarts-framework-template/tests
./run-ab-test.sh
```

That's it. The script:
1. Tests v3 framework (1-2 hours)
2. Tests v4 framework (1-2 hours)
3. Generates comparison reports
4. Opens results in browser

## What You Get

**Visual Reports:**
- `comparison-report.html` — Interactive dashboard with charts
- `comparison-summary.md` — Text summary
- `results/` — Raw data and predictions

**Metrics Tracked:**
- Resolve rate (% of bugs fixed)
- Token efficiency (tokens per task)
- Time per task
- First-try success rate

## Expected Timeline

| Phase | Time | Can Walk Away? |
|-------|------|----------------|
| Setup | 10 min | No - need to install |
| v3 Test | 1-2 hrs | Yes - fully automated |
| v4 Test | 1-2 hrs | Yes - fully automated |
| Analysis | 30 sec | No - need to review |
| **Total** | **~4 hrs** | **Yes - mostly unattended** |

## Example Output

```
Framework Comparison Summary

Results:
┌─────────────────┬────────────┬────────────┬────────┐
│ Metric          │ v3         │ v4         │ Winner │
├─────────────────┼────────────┼────────────┼────────┤
│ Resolve Rate    │ 18.5%      │ 22.3%      │ v4 ✅  │
│ Tasks Resolved  │ 5/10       │ 7/10       │ v4 ✅  │
│ Avg Tokens/Task │ 12,450     │ 8,320      │ v4 ✅  │
│ Avg Time/Task   │ 245s       │ 198s       │ v4 ✅  │
└─────────────────┴────────────┴────────────┴────────┘

Overall Winner: v4 (Lean)

v4 is more efficient with better results.
```

## Troubleshooting

**Docker errors:**
```bash
# Check Docker has enough RAM
# Docker Desktop → Settings → Resources → Memory: 8GB minimum
```

**Missing results:**
```bash
# Check results were saved
ls -la tests/results/
# Should see: v3-scores.json, v4-scores.json
```

**Script fails:**
```bash
# Run manually (see swe-bench-setup.md for details)
cd ~/Desktop/claudecode_gemini_and_codex_swebench
python swe_bench.py run --model opus-4.6 --quick
```

## Alternative: Manual Testing

If automated script fails, follow `swe-bench-setup.md` for step-by-step manual process.

## Notes

- First run downloads Docker images (~5GB)
- Internet required during tests
- Don't interrupt tests (Docker containers running)
- Results persist - you can re-analyze without re-testing
