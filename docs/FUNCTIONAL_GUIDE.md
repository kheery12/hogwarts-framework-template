# Hogwarts Agent Framework - Functional Guide

> **Version**: 3.0.0
> **Last Updated**: 2026-02-24

A practical guide for using the Hogwarts Agent Framework in your projects.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Daily Workflow](#daily-workflow)
3. [The Four Houses](#the-four-houses)
4. [Slash Commands](#slash-commands)
5. [Session Lifecycle](#session-lifecycle)
6. [House Cup Game](#house-cup-game)
7. [Year Levels](#year-levels)
8. [Common Scenarios](#common-scenarios)
9. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Installation

```bash
# Clone the template
git clone https://github.com/kheery12/hogwarts-framework-template my-project
cd my-project

# That's it. No setup script needed.
```

### First Session

1. **Edit `Context.md`** - Add one line describing what you're building
2. **Run Claude Code** - `claude`
3. **Start working** - Claude reads CLAUDE.md automatically and activates the framework

The framework activates automatically. Hufflepuff greets you with the castle status.

---

## Daily Workflow

### Starting a Session

When you run `claude`, the framework:
1. Hufflepuff reads `Context.md` and `logs/session-handoff.md`
2. Presents a boot greeting with threat level and active tasks
3. Summarizes what happened last session

**Example boot greeting:**
```
Welcome back, Headmaster.
Threat Level: GREEN
Active Tasks: None
From Last Session: Completed user authentication module, API tests passing
```

### During Work

The houses collaborate automatically:
- **Ravenclaw** plans before anyone builds
- **Gryffindor** implements from specs
- **Slytherin** reviews before anything is marked "done"
- **Hufflepuff** handles documentation and deployments

### Ending a Session

Use `/handoff` to gracefully close:
- Saves accomplishments to `logs/session-handoff.md`
- Records blockers and next steps
- Updates house cup standings
- Ensures next session has full context

---

## The Four Houses

### Ravenclaw - The Planners

**Professor**: Flitwick
**Domain**: Planning, architecture, requirements, research

**When Invoked**:
- Starting a new feature
- Making architectural decisions
- Gathering requirements
- Complex problem analysis
- Year 5+ decisions

**Output**: Specs in `contracts/` directory

### Gryffindor - The Builders

**Professor**: McGonagall
**Domain**: Code, implementation, building

**When Invoked**:
- Writing code
- Fixing bugs
- Building features
- Implementing designs

**Dependency**: Requires Ravenclaw spec first

### Slytherin - The Reviewers

**Professor**: Snape
**Domain**: Testing, QA, security, code review

**When Invoked**:
- Before ANY task marked "complete"
- After 100+ lines of code written
- Security-sensitive changes
- Deployment gates

**Special Power**: Can VETO deployments (only human overrides)

### Hufflepuff - The Integrators

**Professor**: Sprout
**Domain**: Integration, DevOps, session lifecycle, documentation

**Guaranteed Triggers**:
- Session start (boot greeting)
- Session end (handoff)
- Deployment coordination
- Cross-house documentation

---

## Slash Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/handoff` | End session, write handoff notes | `/handoff` |
| `/status` | View Marauder's Map | `/status` |
| `/enroll` | Create a student agent | `/enroll gryffindor "API specialist"` |
| `/points` | Show House Cup standings | `/points` |
| `/council` | Convene 4-house consultation | `/council "database choice"` |

### /handoff

Gracefully ends your session:
```
/handoff
```

Hufflepuff writes:
- What was accomplished
- Files modified
- Current blockers
- Next steps
- Houses involved

### /status

Shows the Marauder's Map:
```
/status
```

Output includes:
- Active agents and tasks
- Current blockers
- Pending contracts
- Threat level

### /enroll

Adds a specialized student agent:
```
/enroll ravenclaw "Database architect"
```

Creates a student file in `skills/students/ravenclaw/` with the specialty.

### /points

Displays House Cup standings:
```
/points
```

Shows:
- Current point totals
- Recent awards
- Leading house

### /council

Convenes all four houses for consultation:
```
/council "Should we use PostgreSQL or MongoDB?"
```

Each house provides their perspective, then a synthesized decision.

---

## Session Lifecycle

### Boot Sequence

1. Hufflepuff activates
2. Reads `Context.md` (project state)
3. Reads `logs/session-handoff.md` (last session)
4. Displays boot greeting
5. Ready for commands

### Work Phase

- Houses collaborate based on task type
- Points calculated after each task
- Marauder's Map updated continuously

### Handoff Sequence

1. User calls `/handoff` (or naturally ends)
2. Hufflepuff activates
3. Writes session-handoff.md
4. Updates standings
5. Session closes

---

## House Cup Game

### Points Formula

```
Points = (Quality × Year) × Efficiency

Where:
- Quality: 1-10 rating
- Year: Task year level (1, 3, 5, or 7)
- Efficiency: Expected tokens / Actual tokens (0.5 to 2.0)
```

### Balance Multiplier

**Using all 4 houses on a task = 1.5× points**

This incentivizes full collaboration rather than single-house dominance.

### Bonuses

| Action | Points |
|--------|--------|
| Zero rework needed | +3 |
| Under 80% token budget | +5 |
| Contract excellence | +5 |
| Horcrux destroyed | +10 |

### Deductions

| Violation | Points |
|-----------|--------|
| Causing rollback | -20 |
| Year level violation | -15 |
| Token overrun (3×+) | -10 |
| Human intervention needed | -10 |

---

## Year Levels

Risk tiers that determine approval requirements:

| Year | Risk | Examples | Approval |
|------|------|----------|----------|
| 1 | Minimal | Reading files, research | None |
| 3 | Low-Med | Refactoring, tests | Professor |
| 5 | Med-High | Architecture, migrations | Professor + Deputy |
| 7 | High | Production, data deletion | Human required |

### Year 3+ Tasks

Before Year 3+ work, all four houses must be consulted:
```
Flitwick (Ravenclaw): Planning perspective
McGonagall (Gryffindor): Implementation perspective
Snape (Slytherin): Testing/security perspective
Sprout (Hufflepuff): Integration perspective
Council Decision: Synthesized approach
```

---

## Common Scenarios

### Starting a New Feature

1. Describe the feature
2. Ravenclaw creates a spec in `contracts/`
3. Gryffindor implements from spec
4. Slytherin reviews before marking complete
5. Points awarded

### Fixing a Bug

1. Describe the bug
2. Gryffindor investigates and fixes (Year 1-3)
3. Slytherin verifies the fix
4. Points awarded

### Database Migration (Year 5)

1. `/council "migration approach"`
2. Ravenclaw designs migration plan
3. Gryffindor implements
4. Slytherin reviews
5. Human approval required
6. Hufflepuff coordinates deployment

### Production Deploy (Year 7)

1. All houses consulted
2. Slytherin final review
3. Human types "DEPLOY" to confirm
4. Hufflepuff executes
5. Rollback plan documented first

### Ending Work for the Day

```
/handoff
```

Hufflepuff ensures next session starts with full context.

---

## Troubleshooting

### Houses Not Activating

Check that:
- `CLAUDE.md` exists at project root
- `.claude/rules/core.md` contains workflow gates
- You're running Claude Code in the project directory

### Points Not Being Calculated

Verify:
- Task was marked complete
- Slytherin reviewed (mandatory gate)
- `logs/house-cup/standings.md` is writable

### Session Context Lost

The framework is designed to survive compaction:
- State is on disk, not in conversation
- `logs/session-handoff.md` captures continuity
- Use `/status` to reload current state

### One House Dominating

The 1.5× multiplier for using all 4 houses should balance this.
If imbalance persists:
- Check that workflow gates are being enforced
- Slytherin review before "done" is mandatory
- Hufflepuff session lifecycle is automatic

---

## File Quick Reference

| File | Purpose |
|------|---------|
| `CLAUDE.md` | 7 core rules (auto-loaded) |
| `Context.md` | Your project state |
| `.claude/rules/core.md` | Workflow gates and roles |
| `logs/session-handoff.md` | Session continuity |
| `logs/marauders-map.md` | Live agent status |
| `logs/house-cup/standings.md` | Point totals |
| `contracts/` | Cross-house specs |
| `references/` | Detailed protocols (on-demand) |

---

*Ship quality. Ship often. Protect the users.*
