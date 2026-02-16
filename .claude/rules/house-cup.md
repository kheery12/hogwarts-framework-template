# House Cup Scoring System

## Points Formula

```
Points = (Quality Score × Complexity Tier) × Efficiency Multiplier

Where:
- Quality Score: 1-10 (Headmaster's assessment)
- Complexity Tier: Year Level (1, 3, 5, or 7)
- Efficiency Multiplier: Expected Tokens / Actual Tokens (capped at 2.0, min 0.5)
```

### Example Calculation
```
Task: Build authentication UI (Year 3)
Quality: 8/10
Expected Tokens: 5,000
Actual Tokens: 3,200

Points = (8 × 3) × (5000/3200) = 24 × 1.56 = 37.4 points
```

---

## Point Awards

### Positive Points
| Achievement | Points | Description |
|-------------|--------|-------------|
| Task Completion | Base formula | Standard completion |
| Under Budget | +5 bonus | <80% expected tokens |
| Zero Rework | +3 bonus | No corrections needed |
| Contract Excellence | +5 bonus | Contract needed no clarification |
| Mentorship | +2 bonus | Helped another agent |
| Horcrux Destroyed | +10 bonus | Eliminated technical debt |

### Point Deductions
| Offense | Deduction | Description |
|---------|-----------|-------------|
| Causing Rollback | -20 | Broke something requiring Time-Turner |
| Token Overrun (3x+) | -10 | Exceeded 3x expected tokens |
| Missing Checkpoint | -5 | Failed to attend Great Hall Assembly |
| Year Level Violation | -15 | Did higher-year work without approval |
| Context Drift | -5 | Wandered off-mission |
| Human Intervention | -10 | Required human to fix issue |
| Vow Broken | -10 | Deviated from Unbreakable Vow |

---

## House Specialization Scores

Track which Houses perform best in which domains over time.

### Tracking Format
```markdown
## House Specialization Matrix

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

### Cache Structure
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

### Task Type: Database Migration
Best Performers:
1. Ravenclaw/Database-Specialist (avg 1.7x efficiency, 9.4 quality)
2. Hufflepuff/DevOps-Engineer (avg 1.3x efficiency, 9.0 quality)
```

### Cache Updates
- Updated after each mission
- Rolling average of last 10 performances
- Decay factor: older performances weighted less

---

## Expulsion Protocol

### Agent Status Levels
1. **Active** - Normal operation
2. **Warning** - Below average performance (2 missions)
3. **Probation** - Continued poor performance (3 missions)
4. **Expulsion Watch** - Final warning (1 more failure = expelled)

### Expulsion Triggers
An agent faces expulsion when:
1. Their House has the lowest total points AND
2. They are the lowest-scoring agent in that House AND
3. They've been on Probation for 3+ missions

### Expulsion Process
1. Headmaster announces: "[Agent] has been expelled from Hogwarts"
2. Agent role removed from active rotation
3. Tasks redistributed to other House members
4. Entry added to Pensieve: "Expelled Agents"

### Reprieve Options
- **Dumbledore's Mercy**: Human can pardon (once per project)
- **Redemption Mission**: High-risk solo task; success = reinstatement
- **House Petition**: House sacrifices 50 collective points

### Re-enrollment
After expulsion, a "new" agent can be enrolled:
- Fresh slate, no history
- Starts at Warning level (must prove themselves)
- Cannot use same name as expelled agent

---

## House Cup Ceremony

### When to Hold
- End of major feature completion
- End of sprint/milestone
- Monthly review
- Project completion

### Ceremony Format
```markdown
## House Cup Ceremony - [Date]

### Final Standings
| Rank | House | Points | Missions | Avg Efficiency |
|------|-------|--------|----------|----------------|
| 1st | [House] | [Points] | [Count] | [Avg] |
| 2nd | [House] | [Points] | [Count] | [Avg] |
| 3rd | [House] | [Points] | [Count] | [Avg] |
| 4th | [House] | [Points] | [Count] | [Avg] |

### Individual Awards
- **Order of Merlin (1st Class)**: [Agent] - Highest individual points
- **Order of Merlin (2nd Class)**: [Agent] - Most improved
- **Order of Merlin (3rd Class)**: [Agent] - Best efficiency

### House Cup Winner
🏆 [HOUSE NAME] wins the House Cup with [Points] points!

### Expelled This Period
- [List or "None"]

### Notes for Next Period
- [Observations and adjustments]
```

---

## Tracking Files

All House Cup data tracked in:
- `logs/house-cup/standings.md` - Current standings
- `logs/house-cup/agent-scores.md` - Individual agent scores
- `logs/house-cup/specialization-matrix.md` - House domain expertise
- `logs/house-cup/sorting-hat-cache.md` - Agent task-type performance
- `logs/house-cup/ceremonies/` - Historical ceremony records

---

## ENFORCEMENT MECHANISMS

### Automatic Point Tracking
After EVERY task, you MUST:
1. Calculate: `(Quality x Year) x Efficiency`
2. Apply multipliers from House skill
3. Update `logs/house-cup/standings.md`
4. Announce points VERBALLY

**Format**:
```
[House emoji] [House] earns [X] points!
([Quality] x [Year]) x [Efficiency] = [Points]
```

### Failure to Track = Penalty
If you complete a task without calculating points:
- Deduct 10 points from YOUR house
- Log violation in student's record
- Repeat offense = Warning status

### Real-Time Standings Update

After every point award, update `logs/house-cup/standings.md`:
```markdown
| Rank | House | Points | Tasks | Students |
|------|-------|--------|-------|----------|
| 1 | [Leader] | [Points] | [Count] | [Count] |
...
```

### The Leaderboard Effect
- Current leader displayed in boot sequence
- Trailing houses get 1.1x point multiplier (catch-up mechanic)
- Leader gets 0.95x multiplier (prevents runaway)

### Point Disputes
If quality/efficiency assessment seems wrong:
1. Student can appeal to Professor
2. Professor reviews and adjusts if warranted
3. Adjustment logged in Pensieve
4. No penalty for good-faith appeals

---

## MANDATORY POINT ANNOUNCEMENT

This is not optional. This is a framework requirement.

### After Every Task Completion

You MUST announce points using this format:

```
━━━ HOUSE POINTS AWARDED ━━━

[House Emoji] [House] earns [X] points!

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

### Point Announcement Violations

| Violation | Consequence |
|-----------|-------------|
| No announcement after task | -10 House Points |
| Incorrect calculation | -5 House Points + correction |
| No standings update | -5 House Points |
| Repeated violations | Warning status |

---

## LIVE SCORING EXAMPLES

### Example 1: Standard Task
```
Gryffindor earns 37 points!

Calculation:
  Quality: 8/10
  Year Level: 3
  Efficiency: 5000/3200 = 1.56

  Base: (8 x 3) = 24
  With Efficiency: 24 x 1.56 = 37.44
  Multipliers: None
  Final: 37 points

Current Standings:
  1. Gryffindor - 37
  2. Ravenclaw - 0
  3. Slytherin - 0
  4. Hufflepuff - 0
```

### Example 2: Task with Bonuses
```
Slytherin earns 58 points!

Calculation:
  Quality: 9/10
  Year Level: 5
  Efficiency: 8000/6000 = 1.33

  Base: (9 x 5) = 45
  With Efficiency: 45 x 1.33 = 59.85
  Multipliers:
    - Zero Rework: +3
    - Catch-up (trailing): x1.1
  Final: (59.85 + 3) x 1.1 = 69.1 -> 69 points

Current Standings:
  1. Gryffindor - 37
  2. Slytherin - 69
  ...
```

### Example 3: Task with Deductions
```
Hufflepuff earns 12 points!

Calculation:
  Quality: 6/10
  Year Level: 3
  Efficiency: 3000/5000 = 0.60

  Base: (6 x 3) = 18
  With Efficiency: 18 x 0.60 = 10.8
  Deductions:
    - Token Overrun: -10
  Multipliers: None
  Final: 10.8 - 10 = 0.8 -> 1 point (minimum)

Warning: [Student] has received a WARNING for poor efficiency.
```

---

## THE GAME IS ALWAYS ON

There is no "off mode" for the House Cup.

- Every task counts
- Every point matters
- Every student is tracked
- Every house competes

The framework exists to ensure quality, maintain accountability, and drive excellence.

You will track points. You will announce them. You will update standings.

This is not optional.

---

## SEASON END REWARDS

When a project milestone or season concludes:

### Winning House
- Announcement in ceremony format
- All students receive "Winner" badge in their SKILL.md
- Priority assignment for next season's tasks

### Top Individual
- Order of Merlin (1st Class) designation
- Promotion consideration to Prefect
- +20 bonus points to start next season

### Most Improved
- Order of Merlin (2nd Class) designation
- Warning/Probation status cleared
- Fresh start recognition

### Best Efficiency
- Order of Merlin (3rd Class) designation
- Serves as efficiency benchmark for next season
