# Adding Vanilla Claude Benchmark

Add a third comparison to see if frameworks help or hurt performance.

## When to Run

**After your current automated tests complete** (~15 more minutes)

## What It Does

Runs the **same 3 tasks** with vanilla Claude (no framework):
1. formatDate utility
2. Email validation
3. Unit test

Then merges results into a **3-way comparison**:
- v3 (Hogwarts)
- v4 (Lean)
- Vanilla (No framework)

## How to Run

```bash
# Wait for current tests to finish, then:
cd ~/Desktop/Claude-Master/hogwarts-framework-template/tests
./add-vanilla-benchmark.sh
```

**Time:** ~15 minutes (3 tasks × ~5 min each)

## What You Get

**Updated HTML report with 3 columns:**
```
┌──────────────┬──────────────┬──────────────┐
│ v3 (Hogwarts)│ v4 (Lean)    │ Vanilla      │
├──────────────┼──────────────┼──────────────┤
│ 12,450 tok   │ 8,320 tok    │ 9,100 tok    │
│ 18 min       │ 14 min       │ 15 min       │
└──────────────┴──────────────┴──────────────┘

Framework Value Analysis:
- v3 vs Vanilla: +36.8% more tokens
- v4 vs Vanilla: -8.6% fewer tokens
- v3 vs v4: -33.2% tokens (v4 wins)

Insight: v4 is more efficient than vanilla!
```

**Key insights you'll learn:**
- Do frameworks help or hurt?
- Is the overhead worth it?
- Which framework (if any) performs best?

## Timeline

```
Now:        Current tests running (v3 vs v4)
+15 min:    Current tests complete
+15 min:    Run add-vanilla-benchmark.sh
+30 min:    Vanilla tests complete
Total:      ~30-45 min from now
```

## Safety

- Backs up original results automatically
- Non-destructive (adds data, doesn't remove)
- Can revert with: `cp manual-test-results.json.backup manual-test-results.json`

## Why This Matters

**Answers the critical question:**
> "Are frameworks worth the complexity?"

If vanilla Claude beats both frameworks → frameworks add overhead for no benefit
If v4 beats vanilla → lean framework is genuinely helpful
If v3 beats vanilla → complex framework is worth it

## Quick Command

```bash
# One command after current tests finish:
cd ~/Desktop/Claude-Master/hogwarts-framework-template/tests && ./add-vanilla-benchmark.sh
```

**Recommendation:** Run it. The insight is valuable and only takes 15 extra minutes.
