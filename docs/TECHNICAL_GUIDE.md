# Hogwarts Agent Framework - Technical Guide

> **Version**: 3.0.0
> **Last Updated**: 2026-02-24

A deep dive into the design decisions, research backing, and implementation details of the Hogwarts Agent Framework.

---

## Table of Contents

1. [Design Philosophy](#design-philosophy)
2. [Research Foundation](#research-foundation)
3. [v3 Changes Explained](#v3-changes-explained)
4. [Architecture](#architecture)
5. [Rule System](#rule-system)
6. [House Balance Mechanics](#house-balance-mechanics)
7. [Session Management](#session-management)
8. [Skill System](#skill-system)
9. [Points & Gamification](#points--gamification)
10. [Emergency Protocols](#emergency-protocols)

---

## Design Philosophy

### Core Principles

1. **Minimal rule footprint** - LLMs can only reliably track 5-10 rules
2. **State on disk** - Everything important survives compaction
3. **Progressive disclosure** - Load details only when needed
4. **Workflow gates** - Mandatory checkpoints ensure process compliance
5. **Gamification with teeth** - Points matter because expulsion is real

### What We're Solving

Multi-agent coordination in Claude Code faces several challenges:
- Context window limits force periodic summarization
- Summarization loses procedural instructions
- Agents drift from assigned behaviors over long sessions
- House imbalance (some houses never get used)
- Rule inflation (too many rules = ignored rules)

---

## Research Foundation

### Sources

The v3 redesign was informed by:
1. "The Complete Guide to Building Skills for Claude" (Anthropic, 2026)
2. Community research on CLAUDE.md effectiveness
3. Claude Code 2.1.49 changelog analysis

### Key Findings

#### LLM Working Memory Limits

> "LLMs can reliably track 5-10 rules before silently dropping some"

**v3 Response**: Reduced CLAUDE.md from 50+ rules to exactly 7.

#### Prose Competition

> "Explanatory prose competes with instructions for attention—worse than random noise"

**v3 Response**: Removed all explanatory text from core rules. Details moved to `references/` for on-demand loading.

#### Instruction Position

> "Instructions at the END of a file get ~30% better compliance than middle-positioned instructions"

**v3 Response**: Verification checklist placed at END of CLAUDE.md.

#### Emphasis Overcorrection

> "Claude 4.6+ overtriggers on 'CRITICAL', 'NEVER', 'MUST'—use plain imperatives"

**v3 Response**: Rewrote all rules as plain imperatives. No superlatives.

#### Official Skill Format

Skills should use YAML frontmatter with:
- `name`: kebab-case identifier
- `description`: What it does + trigger phrases
- Optional: `background`, `tools`, `allowed_commands`

**v3 Response**: All house skills converted to official YAML format.

---

## v3 Changes Explained

### Rule Consolidation

**Before (v2)**: 8 separate rule files totaling ~2,000 lines
```
.claude/rules/
├── boot-sequence.md (165 lines)
├── hogwarts-core.md (279 lines)
├── mandatory-consultation.md (144 lines)
├── house-cup.md (381 lines)
├── expulsion.md (305 lines)
├── threat-levels.md (228 lines)
├── interaction-protocols.md (372 lines)
└── forbidden-actions.md (153 lines)
```

**After (v3)**: 1 core file + 5 reference files
```
.claude/rules/
└── core.md (75 lines)  # Auto-loaded

references/  # Loaded on-demand
├── house-cup.md
├── expulsion.md
├── threat-levels.md
├── interaction-protocols.md
└── forbidden-actions.md
```

**Why**: 75 lines of always-loaded rules vs 2,000+ lines. Claude can actually track 10 rules.

### CLAUDE.md Minimization

**Before (v2)**: ~100 lines with explanations

**After (v3)**: 39 lines, 7 rules, no prose

```markdown
## Core Rules

1. Read Context.md and logs/session-handoff.md before responding
2. Consult all four houses before Year 3+ tasks
3. Update logs/marauders-map.md when starting and completing tasks
4. Calculate points after each task: (Quality x Year) x Efficiency
5. Slytherin reviews before marking any task "complete"
6. Hufflepuff handles session greeting and handoff
7. Use all 4 houses on a task for 1.5x point multiplier

## Verification Checklist
- [ ] Context.md read
- [ ] Session handoff reviewed
- [ ] Four houses consulted for Year 3+ work
- [ ] Marauders map updated
- [ ] Slytherin approved before "done"
- [ ] Points calculated and announced
```

**Why**: 7 rules fit in working memory. Checklist at END for compliance.

### Progressive Disclosure

Three-tier loading system:

| Tier | When Loaded | Content |
|------|-------------|---------|
| 1. CLAUDE.md | Always | 7 rules, verification checklist |
| 2. core.md | Always (rules dir) | Workflow gates, formats |
| 3. references/ | On-demand | Full protocols, ceremonies |

**Why**: Keeps context lean. Details available when needed.

---

## Architecture

### File Structure

```
project/
├── CLAUDE.md                 # Entry point (7 rules)
├── Context.md                # Project state (user edits)
│
├── .claude/
│   ├── rules/
│   │   └── core.md          # Workflow gates, formats (auto-loaded)
│   ├── commands/            # Slash commands
│   │   ├── handoff.md
│   │   ├── status.md
│   │   ├── enroll.md
│   │   ├── points.md
│   │   └── council.md
│   └── settings.json
│
├── references/              # On-demand detail files
│   ├── house-cup.md         # Scoring, expulsion, ceremonies
│   ├── expulsion.md         # Performance management
│   ├── threat-levels.md     # Emergency protocols
│   ├── interaction-protocols.md
│   └── forbidden-actions.md
│
├── skills/
│   ├── houses/              # House definitions
│   │   ├── ravenclaw/SKILL.md
│   │   ├── gryffindor/SKILL.md
│   │   ├── slytherin/SKILL.md
│   │   └── hufflepuff/SKILL.md
│   ├── students/            # Enrolled agents
│   ├── protocols/           # enrollment, etc.
│   └── commands/            # close command
│
├── contracts/               # Cross-house interfaces
│   ├── api-contracts/
│   ├── component-contracts/
│   ├── test-contracts/
│   └── deploy-contracts/
│
├── logs/
│   ├── marauders-map.md     # Live status
│   ├── session-handoff.md   # Session continuity
│   ├── house-cup/
│   │   └── standings.md
│   ├── pensieve/            # Decision logs
│   └── horcrux-registry/    # Tech debt tracking
│
└── docs/
    ├── FUNCTIONAL_GUIDE.md  # User guide
    ├── TECHNICAL_GUIDE.md   # This file
    └── context/
        ├── archive-rules.md
        └── recovery-protocol.md
```

### Loading Hierarchy

1. **Claude Code starts** → Loads `CLAUDE.md` (7 rules)
2. **Rules directory scanned** → Loads `.claude/rules/core.md` (10 rules)
3. **Hufflepuff activates** → Reads `Context.md`, `session-handoff.md`
4. **Task requires detail** → Loads from `references/` as needed

Total auto-loaded: ~115 lines (vs ~2,000 in v2)

---

## Rule System

### The 7 CLAUDE.md Rules

| # | Rule | Why |
|---|------|-----|
| 1 | Read Context.md and session-handoff.md first | Context before action |
| 2 | Consult all four houses before Year 3+ | Prevents single-house dominance |
| 3 | Update marauders-map.md at start/end | Tracking survives compaction |
| 4 | Calculate points after each task | Gamification enforcement |
| 5 | Slytherin reviews before "complete" | Quality gate |
| 6 | Hufflepuff handles session lifecycle | Guaranteed house involvement |
| 7 | All 4 houses = 1.5x multiplier | Balance incentive |

### The 10 core.md Rules

Expands on CLAUDE.md with:
- Session lifecycle details (boot/exit formats)
- House roles table
- Workflow gates (spec before build, review before done)
- Year level definitions
- Points calculation format

### Why Not More Rules?

Research shows LLMs track 5-10 rules reliably. Past 10, rules get dropped silently—no error, just ignored.

v3 uses exactly:
- 7 rules in CLAUDE.md
- 10 rules in core.md
- Everything else in on-demand references

---

## House Balance Mechanics

### The Problem

In v2, Gryffindor and Ravenclaw dominated:
- Ravenclaw got invoked for planning
- Gryffindor got invoked for building
- Slytherin rarely involved (testing optional)
- Hufflepuff almost never involved (DevOps rare)

### The Solution

Three mechanisms ensure all houses participate:

#### 1. Guaranteed Triggers

| House | Guaranteed Trigger |
|-------|-------------------|
| Hufflepuff | Every session start, every session end |
| Slytherin | Before ANY task marked "complete" |
| Ravenclaw | New features, architecture decisions |
| Gryffindor | Code writing, implementation |

#### 2. Workflow Gates

```
Ravenclaw spec → Gryffindor builds
                 ↓
            Slytherin reviews (mandatory)
                 ↓
            Task "complete"
                 ↓
            Hufflepuff handoff
```

No shortcuts. Slytherin review is mandatory.

#### 3. Balance Multiplier

**Using all 4 houses on a task = 1.5× points**

Mathematical incentive for full collaboration:
- Single house: 10 × 3 × 1.0 = 30 points
- Four houses: 10 × 3 × 1.5 = 45 points

### Balance Tracking

`Context.md` includes a house activity table:
```markdown
## House Activity (This Session)

| House | Tasks | Points | Last Active |
|-------|-------|--------|-------------|
| Ravenclaw | 0 | 0 | - |
| Gryffindor | 0 | 0 | - |
| Slytherin | 0 | 0 | - |
| Hufflepuff | 0 | 0 | - |
```

Visual feedback on participation balance.

---

## Session Management

### Why Sessions Matter

Context compaction is inevitable. When it happens:
- Conversation history gets summarized
- Procedural instructions often lost
- Agents forget assigned behaviors

### Compaction-Resistant Design

State lives on disk, not in conversation:

| State | Storage | Survives Compaction |
|-------|---------|---------------------|
| Project context | `Context.md` | ✓ |
| Last session | `session-handoff.md` | ✓ |
| Current status | `marauders-map.md` | ✓ |
| Points | `standings.md` | ✓ |
| Decisions | `pensieve/` | ✓ |

### Session Handoff Fields

```markdown
## Accomplishments
- [What got done]

## Files Modified
- [List of files touched]

## Blockers / Open Issues
- [What's stuck]

## Next Steps
- [What to do next]

## Houses Involved
- [Which houses participated]

## Files NOT to Re-Read
- [Files already understood - saves tokens]

## Recovery Instructions
- [If session starts fresh, do this]
```

### Archive Rules

To prevent log bloat:
- Maximum 15 files in `logs/pensieve/`
- Handoffs expire after 5 sessions
- Auto-consolidation into summary files

---

## Skill System

### Official YAML Format

```yaml
---
name: ravenclaw-planners
description: Planning, architecture, and research specialists.
  Use when starting new features, making architectural decisions,
  gathering requirements, or Year 5+ decisions.
  Triggers on "plan", "design", "architecture", "requirements".
---

# Ravenclaw - The Planners

[Rest of skill content]
```

### Three-Level Progressive Disclosure

| Level | Content | When Loaded |
|-------|---------|-------------|
| 1. YAML frontmatter | Name, triggers | Skill scanning |
| 2. SKILL.md body | Full role definition | Skill activation |
| 3. Linked files | Deep references | On-demand |

### Skill Types

- **House Skills** (`skills/houses/`) - Role definitions
- **Protocol Skills** (`skills/protocols/`) - Procedures
- **Command Skills** (`skills/commands/`) - Slash commands
- **Student Skills** (`skills/students/`) - Specialized agents

### Student Enrollment

```yaml
---
name: student-api-specialist
description: Gryffindor student specializing in REST API implementation
house: gryffindor
background: true
---
```

Students can run in background (`background: true`) for parallel work.

---

## Points & Gamification

### Formula

```
Points = (Quality × Year) × Efficiency × Multiplier

Where:
- Quality: 1-10 (Headmaster assessment)
- Year: Task year level (1, 3, 5, or 7)
- Efficiency: Expected tokens / Actual tokens
- Multiplier: 1.5 if all 4 houses involved, else 1.0
```

### Efficiency Bounds

- Minimum: 0.5 (can't earn less than half points)
- Maximum: 2.0 (efficiency capped to prevent gaming)

### Why Points Matter

Points aren't just vanity metrics:
- Low-performing houses face member expulsion
- Expulsion includes "memory wipe" (student file deleted)
- Creates genuine stakes for performance

### Expulsion Triggers

1. House has lowest total points AND
2. Agent is lowest scorer in that House AND
3. Agent on Probation for 3+ missions

### Reprieve Options

- **Dumbledore's Mercy**: Human pardon (once per project)
- **Redemption Mission**: High-risk solo task
- **House Petition**: House sacrifices 50 points

---

## Emergency Protocols

### Threat Levels

| Level | Name | Trigger | Response |
|-------|------|---------|----------|
| GREEN | Peaceful | Normal ops | Standard workflow |
| YELLOW | Dark Mark Sighted | Deadline pressure | Increased checkpoints |
| ORANGE | Death Eaters Mobilizing | Critical bug | Pause non-critical work |
| RED | Battle of Hogwarts | Production down | Patronus Protocol |

### Patronus Protocol

Emergency response activation:
1. All agents stop current work
2. Report to Great Hall (status sync)
3. Headmaster briefs on threat
4. Single-mission focus until resolved

### Time-Turner Protocol

Rollback tiers:
1. Code rollback (git revert)
2. Deployment rollback (container/version)
3. Database rollback (migrations/restore)
4. Full system restore

### Horcrux System

Technical debt tracking in `logs/horcrux-registry/`:

| Horcrux | Severity | Example |
|---------|----------|---------|
| Diary | Low | Outdated comments |
| Ring | Medium | Deprecated deps |
| Locket | High | Missing tests |
| Cup | High | Security vuln |
| Diadem | Critical | Architectural flaw |
| Nagini | Critical | Data integrity issue |

Destroying Horcruxes earns bonus points.

---

## Version History

| Version | Date | Key Changes |
|---------|------|-------------|
| 3.0.0 | 2026-02-24 | Research-driven redesign, 80% rule reduction, house balance |
| 2.0.0 | 2026-02-15 | Professor/Student hierarchy, auto-enrollment |
| 1.0.0 | 2026-02-13 | Initial release |

---

## Contributing

The framework is open source. Improvements welcome:
- Keep rules minimal (remember the 5-10 rule limit)
- Test house balance in real projects
- Document findings in issues

---

*"It does not do to dwell on dreams and forget to live."*
*But good systems let you build those dreams efficiently.*
