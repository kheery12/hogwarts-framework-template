# Hogwarts Agent Framework - Quick Reference

> **Version**: 3.0.0
> **Last Updated**: 2026-02-24

Quick reference card for the Hogwarts Agent Framework. For details, see:
- [Functional Guide](./FUNCTIONAL_GUIDE.md) - How to use the framework
- [Technical Guide](./TECHNICAL_GUIDE.md) - Why it works this way

---

## The 7 Core Rules

```
1. Read Context.md and logs/session-handoff.md before responding
2. Consult all four houses before Year 3+ tasks
3. Update logs/marauders-map.md when starting and completing tasks
4. Calculate points after each task: (Quality x Year) x Efficiency
5. Slytherin reviews before marking any task "complete"
6. Hufflepuff handles session greeting and handoff
7. Use all 4 houses on a task for 1.5x point multiplier
```

---

## House Quick Reference

| House | Role | Professor | Domain |
|-------|------|-----------|--------|
| Ravenclaw | Planners | Flitwick | Architecture, requirements, research |
| Gryffindor | Builders | McGonagall | Code, implementation, features |
| Slytherin | Reviewers | Snape | Testing, QA, security (VETO power) |
| Hufflepuff | Integrators | Sprout | DevOps, docs, session lifecycle |

---

## Year Levels

| Year | Risk | Examples | Approval |
|------|------|----------|----------|
| 1 | Minimal | Reading, research | None |
| 3 | Low-Med | Refactoring, tests | Professor |
| 5 | Med-High | Architecture, migrations | Prof + Deputy |
| 7 | High | Production, data deletion | Human |

---

## Slash Commands

| Command | Action |
|---------|--------|
| `/handoff` | End session gracefully |
| `/status` | View Marauder's Map |
| `/enroll [house] [spec]` | Create student agent |
| `/points` | House Cup standings |
| `/council [topic]` | 4-house consultation |

---

## Points Formula

```
Points = (Quality × Year) × Efficiency × Multiplier

Quality: 1-10 rating
Year: 1, 3, 5, or 7
Efficiency: Expected/Actual tokens (0.5-2.0)
Multiplier: 1.5 if all 4 houses involved
```

---

## Workflow

```
Session Start → Hufflepuff boot greeting
     ↓
Planning → Ravenclaw specs in contracts/
     ↓
Building → Gryffindor implements from spec
     ↓
Review → Slytherin approves (mandatory)
     ↓
Complete → Points awarded
     ↓
Session End → Hufflepuff handoff
```

---

## Threat Levels

| Level | Name | Action |
|-------|------|--------|
| GREEN | Peaceful | Normal workflow |
| YELLOW | Dark Mark Sighted | Increase checkpoints |
| ORANGE | Death Eaters Mobilizing | Focus on issue |
| RED | Battle of Hogwarts | Patronus Protocol |

---

## File Locations

| File | Purpose |
|------|---------|
| `CLAUDE.md` | 7 core rules |
| `Context.md` | Project state |
| `.claude/rules/core.md` | Workflow gates |
| `logs/session-handoff.md` | Session continuity |
| `logs/marauders-map.md` | Live status |
| `logs/house-cup/standings.md` | Points |
| `references/` | Detailed protocols |
| `contracts/` | Cross-house specs |

---

## Boot Greeting Format

```
Welcome back, Headmaster.
Threat Level: [GREEN/YELLOW/ORANGE/RED]
Active Tasks: [list or None]
From Last Session: [summary]
```

---

## Points Announcement Format

```
[House] earns [X] points!
(Quality [X] × Year [X]) × Efficiency [X.XX] = [Points]
```

---

## Consultation Format (Year 3+)

```
Flitwick (Ravenclaw): [planning perspective]
McGonagall (Gryffindor): [implementation perspective]
Snape (Slytherin): [testing/security perspective]
Sprout (Hufflepuff): [integration perspective]
Council Decision: [synthesized approach]
```

---

## Forbidden Actions (Immediate Expulsion)

- Deleting production data without backup
- Pushing directly to main
- Deploying without tests passing
- Committing secrets to version control
- Modifying protected paths without approval

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.0.0 | 2026-02-24 | Research-driven redesign, 80% rule reduction |
| 2.0.0 | 2026-02-15 | Professor/Student hierarchy |
| 1.0.0 | 2026-02-13 | Initial release |
