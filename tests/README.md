# Framework Testing Suite

Automated A/B testing for v3 vs v4 using SWE-Bench (real-world software engineering tasks).

## What's Here

```
tests/
├── QUICKSTART.md              # ⭐ Start here - 3 commands to run tests
├── run-ab-test.sh             # Automated test runner (fully automated)
├── compare-frameworks.py      # Generates visual comparison reports
├── swe-bench-setup.md         # Detailed setup guide (if automation fails)
├── EXAMPLE-OUTPUT.md          # What the results will look like
├── scenarios/                 # Manual test scenarios (alternative to SWE-Bench)
│   └── README.md
└── results/                   # Results go here (created after tests run)
    ├── v3-scores.json
    ├── v4-scores.json
    ├── comparison-report.html
    └── comparison-summary.md
```

## Quickest Path: Automated Testing

```bash
# 1. One-time setup (10 minutes)
cd ~/Desktop
git clone https://github.com/jimmc414/claudecode_gemini_and_codex_swebench
cd claudecode_gemini_and_codex_swebench
python -m pip install -r requirements.txt

# 2. Run tests (4 hours, unattended)
cd ~/Desktop/Claude-Master/hogwarts-framework-template/tests
./run-ab-test.sh

# 3. View results
open comparison-report.html
```

That's it. Everything else is automated.

## What You Get

### 1. Interactive HTML Dashboard (`comparison-report.html`)

Beautiful visual report with:
- Side-by-side metrics cards (v3 vs v4)
- Color-coded winner/loser highlighting
- Animated bar charts for each metric
- Resolve rate comparison
- Token efficiency comparison

**Open in browser to see full interactivity.**

### 2. Markdown Summary (`comparison-summary.md`)

Text-based summary table:
- Resolve rate (% of bugs fixed)
- Token efficiency (avg tokens per task)
- Time per task
- Clear winner declaration
- Recommendation

**Perfect for GitHub issues or documentation.**

### 3. Raw Data (`results/`)

Full SWE-Bench output:
- Per-task breakdowns
- Generated patches
- Detailed logs
- Reproducible results

## How SWE-Bench Works

1. **Real GitHub Issues**: Tests use actual bugs from Django, Flask, Pytest, etc.
2. **Claude Fixes Bug**: Framework helps Claude understand issue, write patch
3. **Automated Verification**: Runs test suite to confirm fix works
4. **Scoring**: % of issues successfully resolved

**Industry Standard**: Same benchmark used by Anthropic to test Claude Code.

## Test Sizes

| Size | Tasks | Time | Use For |
|------|-------|------|---------|
| Quick | 10 | ~2 hrs | Initial comparison |
| Standard | 50 | ~8 hrs | Confident decision |
| Full | 300 | ~40 hrs | Publication-grade data |

**Recommendation**: Start with Quick (10 tasks). If results are close, run Standard.

## Expected Performance

| Resolve Rate | Rating |
|--------------|--------|
| 0-5% | Poor |
| 5-15% | Below Average |
| 15-25% | Solid |
| 25-35% | Excellent |
| 35%+ | Outstanding |

## Interpreting Results

**Clear Winner:**
- v4 has higher resolve rate AND lower tokens → Deploy v4
- v3 has higher resolve rate AND lower tokens → Keep v3

**Trade-off:**
- v4 higher resolve but more tokens → Quality vs cost decision
- v3 higher resolve but more tokens → Consider your priority

**Tie:**
- Same resolve rate, similar tokens → User preference decides

## Alternative: Manual Testing

If SWE-Bench setup fails or you want simpler testing:

See `scenarios/README.md` for manual test template.

Run 5-8 real tasks from your work with both frameworks, track:
- Tokens used
- Corrections needed
- Task completion
- Your satisfaction

Less scientific, but faster and uses YOUR actual workflows.

## Timeline

```
Day 1, Hour 0: Setup SWE-Bench (10 min)
Day 1, Hour 0.5: Start v3 test (1-2 hrs, walk away)
Day 1, Hour 2.5: Start v4 test (1-2 hrs, walk away)
Day 1, Hour 4.5: Review results (15 min)
Day 1, Hour 5: Make decision

Total: ~5 hours (mostly unattended)
```

## Troubleshooting

**"Docker not running"**
```bash
# Start Docker Desktop
open -a Docker
# Wait for Docker icon to show "running"
```

**"Not enough memory"**
```bash
# Docker Desktop → Settings → Resources
# Set Memory to 8GB minimum
# Click "Apply & Restart"
```

**"Tests failing"**
```bash
# Check Docker is healthy
docker info

# Verify SWE-Bench setup
cd ~/Desktop/claudecode_gemini_and_codex_swebench
python swe_bench.py list-models
```

**"Missing results files"**
```bash
# Check if tests actually ran
ls -la ~/Desktop/claudecode_gemini_and_codex_swebench/benchmark_scores.log

# Manually copy if needed
cp ~/Desktop/claudecode_gemini_and_codex_swebench/benchmark_scores.log \
   ~/Desktop/Claude-Master/hogwarts-framework-template/tests/results/v3-scores.json
```

## Files Explained

- **QUICKSTART.md**: Fastest path to results (read this first)
- **run-ab-test.sh**: Automated script that does everything
- **compare-frameworks.py**: Generates HTML + markdown reports
- **swe-bench-setup.md**: Manual step-by-step (if script fails)
- **EXAMPLE-OUTPUT.md**: Visual preview of what you'll get
- **scenarios/**: Manual testing alternative

## Questions?

1. **Which test size?** Start with Quick (10 tasks)
2. **How long?** ~4 hours mostly unattended
3. **Need internet?** Yes, Docker downloads images first run
4. **Can I pause?** No, but you can walk away during tests
5. **Re-run if failed?** Yes, scripts are idempotent

## Next Steps After Testing

1. Review `comparison-report.html`
2. Check `comparison-summary.md`
3. If v4 wins: Commit v4, archive v3
4. If v3 wins: Iterate on v4, test again
5. If tie: Test on YOUR actual projects to decide
