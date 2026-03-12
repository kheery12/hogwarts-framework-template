# Example Test Output

What the comparison reports will look like after running tests.

## comparison-report.html (Interactive Dashboard)

```
┌─────────────────────────────────────────────────────────────┐
│        Framework Performance Comparison                      │
│        SWE-Bench Results: v3.1.0 vs v4.0.0                  │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────────┬──────────────────────────┐
│  v3.1.0 (Hogwarts)       │  v4.0.0 (Lean)          │
│  ❌ LOSER                │  ✅ WINNER              │
├──────────────────────────┼──────────────────────────┤
│  Resolve Rate            │  Resolve Rate            │
│  18.5%                   │  22.3%                   │
│                          │                          │
│  Tasks Resolved          │  Tasks Resolved          │
│  5/10                    │  7/10                    │
│                          │                          │
│  Avg Tokens/Task         │  Avg Tokens/Task         │
│  12,450                  │  8,320                   │
│                          │                          │
│  Avg Time/Task           │  Avg Time/Task           │
│  245s                    │  198s                    │
└──────────────────────────┴──────────────────────────┘

Visual Comparison
─────────────────

Resolve Rate
v3 (Hogwarts) ████████████░░░░░░░░░░░░░░░░░░░░ 18.5%
v4 (Lean)     ██████████████░░░░░░░░░░░░░░░░░░ 22.3%

Token Efficiency (Lower is Better)
v3 (Hogwarts) ████████████████████████░░░░░░ 12,450
v4 (Lean)     ████████████░░░░░░░░░░░░░░░░░░ 8,320

Generated: 2026-03-12 14:35:22
```

## comparison-summary.md (Text Report)

```markdown
# Framework Comparison Summary

**Test Date:** 2026-03-12 14:35:22

## Results

| Metric | v3 (Hogwarts) | v4 (Lean) | Winner |
|--------|---------------|-----------|--------|
| Resolve Rate | 18.5% | 22.3% | v4 ✅ |
| Tasks Resolved | 5/10 | 7/10 | - |
| Avg Tokens/Task | 12,450 | 8,320 | v4 ✅ |
| Total Tokens | 124,500 | 83,200 | - |
| Avg Time/Task | 245s | 198s | v4 ✅ |

## Overall Winner: v4 (Lean)

### Analysis

**Resolve Rate:**
- v3: 18.5% (5 tasks)
- v4: 22.3% (7 tasks)
- Difference: 3.8 percentage points

**Token Efficiency:**
- v3: 12,450 avg tokens/task
- v4: 8,320 avg tokens/task
- Savings: 4,130 tokens/task (33.2%)

## Recommendation

v4 is more efficient with better results.
```

## Terminal Output During Test

```bash
$ ./run-ab-test.sh

╔══════════════════════════════════════════════════╗
║   Framework A/B Test: v3 vs v4                   ║
║   Using SWE-Bench (Real-World Code Tasks)        ║
╚══════════════════════════════════════════════════╝

🔍 Checking prerequisites...
✅ Prerequisites met

Test size? (quick=10 tasks ~2hrs, standard=50 tasks ~8hrs) [quick]: quick

═══════════════════════════════════════════════════
  TEST 1: v3 Framework (Hogwarts)
═══════════════════════════════════════════════════

🚀 Running SWE-Bench with v3 framework...
   This will take 1-2 hours...

[Progress: 1/10] django__django-12345 ... ✅ RESOLVED
[Progress: 2/10] flask__flask-5678 ... ❌ FAILED
[Progress: 3/10] pytest__pytest-9101 ... ✅ RESOLVED
[Progress: 4/10] requests__requests-1121 ... ❌ FAILED
[Progress: 5/10] matplotlib__matplotlib-3141 ... ✅ RESOLVED
...

💾 Saving v3 results...
✅ v3 test complete

═══════════════════════════════════════════════════
  TEST 2: v4 Framework (Lean)
═══════════════════════════════════════════════════

🚀 Running SWE-Bench with v4 framework...
   This will take 1-2 hours...

[Progress: 1/10] django__django-12345 ... ✅ RESOLVED
[Progress: 2/10] flask__flask-5678 ... ✅ RESOLVED
[Progress: 3/10] pytest__pytest-9101 ... ✅ RESOLVED
[Progress: 4/10] requests__requests-1121 ... ❌ FAILED
...

💾 Saving v4 results...
✅ v4 test complete

═══════════════════════════════════════════════════
  ANALYSIS: Generating Comparison Reports
═══════════════════════════════════════════════════

🔍 Loading SWE-Bench results...

📊 Generating comparison reports...

✅ Generated comparison-report.html
✅ Generated comparison-summary.md

╔══════════════════════════════════════════════════╗
║              TESTING COMPLETE! ✅                 ║
╚══════════════════════════════════════════════════╝

📊 View results:
   - HTML Report: open ~/Desktop/.../comparison-report.html
   - Summary: cat ~/Desktop/.../comparison-summary.md

📁 Raw data saved to: ~/Desktop/.../tests/results
```

## Detailed Task Breakdown (Available in results/)

Each task shows:
- **Instance ID**: e.g., `django__django-12345`
- **Description**: "Fix session timeout bug"
- **Status**: ✅ RESOLVED / ❌ FAILED
- **Tokens Used**: 15,230
- **Time**: 312s
- **Patch Generated**: Yes/No
- **Tests Passed**: 45/47

## What the Reports Tell You

**High Resolve Rate + Low Tokens = Clear Winner**

Example interpretation:
- v4 resolves 22% vs v3's 18% → v4 is more effective
- v4 uses 8,320 tokens vs v3's 12,450 → v4 is 33% more efficient
- **Conclusion**: v4 is both better AND cheaper → deploy v4

**Mixed Results Example:**
- v3 resolves 25% vs v4's 22% → v3 is more effective
- v4 uses 8,000 tokens vs v3's 15,000 → v4 is 47% more efficient
- **Conclusion**: Trade-off - v3 for quality, v4 for cost → depends on priority
