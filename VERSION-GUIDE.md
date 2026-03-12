# Framework Version Guide

## Available Versions

### v4.0.0 - Lean Framework (RECOMMENDED) ✅
**Branch:** `v4-development`
**Tag:** `v4.0.0`

**Performance:**
- 3x more token efficient than vanilla Claude
- 3.5x more efficient than v3
- 3x faster execution (1 min vs 3 min)

**Structure:**
- Total lines: 203 (vs v3's 15,000+)
- CLAUDE.md: 32 lines
- Professional, blunt tone
- Skills-based architecture
- Progressive disclosure

**Use when:**
- You want maximum efficiency
- Speed and cost matter
- Production-grade work
- Simple to moderate complexity tasks

**Get started:**
```bash
git checkout v4-development
# or
git checkout v4.0.0
```

---

### v3.1.0 - Hogwarts Framework
**Tag:** `v3.1.0-stable`

**Performance:**
- Baseline
- 3.5x more tokens than v4
- 3x slower execution

**Structure:**
- Total lines: 15,000+
- CLAUDE.md: 41 lines
- Hogwarts theming (houses, professors, points)
- Complex constraint system
- Verbose guidance

**Use when:**
- Testing against v4 for comparisons
- You prefer detailed, guided workflows
- Legacy projects

**Get started:**
```bash
git checkout v3.1.0-stable
```

---

## Benchmark Results

**Task:** Restaurant sales data → Interactive dashboard (1,000 transactions)

| Framework | Tokens | Time | vs v4 | Cost (per 1,000) |
|-----------|--------|------|-------|------------------|
| v4 (Lean) | Baseline | 1 min | **WINNER** | $1.40 |
| Vanilla | +187% | 2 min | 3x worse | $4.10 |
| v3 (Hogwarts) | +254% | 3 min | 3.5x worse | $5.00 |

**Annual savings (1,000 tasks/year):** v4 saves $3.60 vs v3

---

## How to Share

**Share v4:**
```bash
git clone https://github.com/kheery12/hogwarts-framework-template.git
cd hogwarts-framework-template
git checkout v4.0.0
```

**Compare both versions:**
```bash
# Clone repo
git clone https://github.com/kheery12/hogwarts-framework-template.git
cd hogwarts-framework-template

# Try v4
git checkout v4.0.0
cat CLAUDE.md

# Try v3
git checkout v3.1.0-stable
cat CLAUDE.md

# Run benchmarks
git checkout v4-development
cd tests
./dashboard-benchmark.sh
```

---

## Repository Structure

```
hogwarts-framework-template/
├── CLAUDE.md                    # Main framework file
├── docs/
│   ├── references.md            # Quick shortcuts
│   ├── context.md               # Session state
│   ├── skillsreference.md       # Skill registry
│   ├── Plan.md                  # Active plans
│   └── Todo.md                  # Task list
├── .claude/
│   └── skills/                  # Pre-installed skills
├── tests/
│   ├── dashboard-benchmark.sh   # Real-world benchmark
│   └── dashboard-benchmark-results.json
└── VERSION-GUIDE.md             # This file
```

---

## Recommendations

**For most users:** Use v4.0.0
**For testing/comparison:** Keep both v3.1.0-stable and v4.0.0
**For production:** v4.0.0 is proven 3x more efficient

---

**Repository:** https://github.com/kheery12/hogwarts-framework-template
**Benchmark Report:** `/tmp/dashboard-benchmark-report.txt`
**Comparison Graphic:** `/tmp/framework-comparison-graphic.html`
