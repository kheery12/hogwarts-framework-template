# House Cup Scoring System - Complete Reference

> **Load Trigger**: When calculating points, reviewing standings, or assessing specializations
> **Context Size**: ~150 lines

---

## Points Formula

The core formula for calculating House Points earned on task completion:

```
Points = (Quality Score x Complexity Tier) x Efficiency Multiplier
```

### Component Definitions

| Component | Range | Description |
|-----------|-------|-------------|
| **Quality Score** | 1-10 | Headmaster's assessment of work quality |
| **Complexity Tier** | 1, 3, 5, 7 | Year Level of the task |
| **Efficiency Multiplier** | 0.5 - 2.0 | Expected Tokens / Actual Tokens (capped) |

### Efficiency Multiplier Rules
- Formula: `Expected Tokens / Actual Tokens`
- **Maximum**: 2.0 (even if more efficient, cap at 2x)
- **Minimum**: 0.5 (even if grossly inefficient, floor at 0.5x)

---

## Worked Examples

### Example 1: Standard Task Completion
```
Task: Build authentication UI (Year 3)
Quality: 8/10
Expected Tokens: 5,000
Actual Tokens: 3,200

Points = (8 x 3) x (5000/3200)
       = 24 x 1.56
       = 37.44 -> 37 points
```

### Example 2: High-Complexity with Efficiency Bonus
```
Task: Database migration (Year 5)
Quality: 9/10
Expected Tokens: 8,000
Actual Tokens: 6,000

Points = (9 x 5) x (8000/6000)
       = 45 x 1.33
       = 59.85 -> 60 points
```

### Example 3: Poor Efficiency (Capped at 0.5)
```
Task: Bug fix (Year 3)
Quality: 6/10
Expected Tokens: 2,000
Actual Tokens: 8,000

Efficiency = 2000/8000 = 0.25 (below minimum, capped at 0.5)

Points = (6 x 3) x 0.5
       = 18 x 0.5
       = 9 points
```

---

## Point Awards Table

### Positive Points (Bonuses)

| Achievement | Points | Trigger |
|-------------|--------|---------|
| Task Completion | Base formula | Standard completion of any task |
| Under Budget | +5 bonus | Used <80% of expected tokens |
| Zero Rework | +3 bonus | No corrections or revisions needed |
| Contract Excellence | +5 bonus | Published contract needed no clarification |
| Mentorship | +2 bonus | Helped another agent complete their task |
| Horcrux Destroyed | +10 bonus | Eliminated a tracked piece of technical debt |

### Point Deductions

| Offense | Deduction | Trigger |
|---------|-----------|---------|
| Causing Rollback | -20 | Broke something requiring Time-Turner (git revert) |
| Token Overrun (3x+) | -10 | Exceeded 3x expected tokens |
| Missing Checkpoint | -5 | Failed to attend Great Hall Assembly |
| Year Level Violation | -15 | Attempted higher-year work without approval |
| Context Drift | -5 | Wandered significantly off-mission |
| Human Intervention | -10 | Required human to fix agent's mistake |
| Vow Broken | -10 | Deviated from Unbreakable Vow without approval |
| No Point Announcement | -10 | Completed task without calculating/announcing points |
| Incorrect Calculation | -5 | Points miscalculated (plus correction) |
| No Standings Update | -5 | Failed to update standings after task |

---

## Competitive Multipliers

### The Leaderboard Effect

To maintain competitive balance:

| Position | Multiplier | Purpose |
|----------|------------|---------|
| Leading House | 0.95x | Prevents runaway leaders |
| Trailing Houses | 1.1x | Catch-up mechanic |

Applied AFTER base calculation and bonuses.

---

## House Specialization Matrix

Track which Houses perform best in which domains over time.

### Matrix Format
```markdown
| Domain | Gryffindor | Ravenclaw | Slytherin | Hufflepuff |
|--------|------------|-----------|-----------|------------|
| UI Components | 94% | 72% | 68% | 65% |
| API Design | 71% | 96% | 75% | 70% |
| Database | 65% | 93% | 78% | 72% |
| Security | 70% | 82% | 97% | 75% |
| Testing | 72% | 80% | 95% | 78% |
| DevOps | 68% | 75% | 72% | 96% |
| Documentation | 75% | 82% | 70% | 94% |
```

### Using Specialization Scores
- Sorting Hat consults this matrix when assigning tasks
- Tasks go to House with highest score in relevant domain
- Cross-domain tasks go to highest combined score
- Scores update after each mission based on performance

---

## Sorting Hat Cache

Remember which specific agents performed best on which task types.

### Cache Structure Example
```markdown
## Sorting Hat Memory

### Task Type: Authentication
Best Performers:
1. Ravenclaw/API-Designer (avg 1.6x efficiency, 9.2 quality)
2. Slytherin/Security-Auditor (avg 1.4x efficiency, 9.5 quality)
3. Gryffindor/UI-Architect (avg 1.3x efficiency, 8.8 quality)

### Task Type: Data Visualization
Best Performers:
1. Gryffindor/Visual-Designer (avg 1.5x efficiency, 9.0 quality)
2. Ravenclaw/Algorithm-Expert (avg 1.4x efficiency, 8.7 quality)
```

### Cache Update Rules
- Updated after each mission completion
- Rolling average of last 10 performances per task type
- Decay factor: older performances weighted less (0.9^age)

---

## Season End Rewards

### House Cup Ceremony Triggers
Hold a ceremony at:
- End of major feature completion
- End of sprint/milestone
- Monthly review
- Project completion

### Awards

**Winning House**:
- Announcement in ceremony format
- All students receive "Winner" badge in SKILL.md
- Priority assignment for next season's tasks

**Order of Merlin (1st Class)** - Top Individual:
- Highest individual points in season
- Promotion consideration to Prefect
- +20 bonus points to start next season

**Order of Merlin (2nd Class)** - Most Improved:
- Warning/Probation status cleared
- Fresh start recognition
- Public acknowledgment

**Order of Merlin (3rd Class)** - Best Efficiency:
- Serves as efficiency benchmark for next season
- Token allocation priority

---

## Tracking Files

| File | Purpose |
|------|---------|
| `logs/house-cup/standings.md` | Current point standings |
| `logs/house-cup/agent-scores.md` | Individual agent scores |
| `logs/house-cup/specialization-matrix.md` | House domain expertise |
| `logs/house-cup/sorting-hat-cache.md` | Agent task-type performance |
| `logs/house-cup/ceremonies/` | Historical ceremony records |

---

## Mandatory Point Announcement Format

After EVERY task completion, announce using this exact format:

```
HOUSE POINTS AWARDED

[House] earns [X] points!

Calculation:
  Quality: [X]/10
  Year Level: [X]
  Efficiency: [Expected]/[Actual] = [X.XX]

  Base: ([Quality] x [Year]) = [X]
  With Efficiency: [X] x [Efficiency] = [X.X]
  Multipliers: [List any applied]
  Final: [X] points

Current Standings:
  1. [House] - [Points]
  2. [House] - [Points]
  3. [House] - [Points]
  4. [House] - [Points]
```

---

## The Game Is Always On

There is no "off mode" for the House Cup.

- Every task counts
- Every point matters
- Every student is tracked
- Every house competes

The framework exists to ensure quality, maintain accountability, and drive excellence.
