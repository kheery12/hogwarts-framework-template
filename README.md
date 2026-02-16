# Hogwarts Agent Framework v2 🏰

A production-grade multi-agent coordination framework for Claude Code, themed around Hogwarts School of Witchcraft and Wizardry.

## What's New in v2

- **Minimal Setup**: Just add one line, Claude asks the rest
- **Professor/Student Hierarchy**: Persistent Professors manage dynamic Student agents
- **Four Specialized Houses**: Planners, Builders, Testers, and Glue Guys
- **Enforced House Cup**: Points calculated and announced after every task
- **Auto-Enrollment**: New Students created automatically when skill gaps emerge
- **Memory Wipe & Expulsion**: Underperforming agents get reset or removed
- **Session Lifecycle**: Boot sequence, checkpoints, and `/close` command
- **Mandatory Consultation**: All houses weigh in before major decisions

## Quick Start

```bash
# 1. Clone the template
git clone https://github.com/kheery12/hogwarts-framework-template my-project
cd my-project

# 2. Run setup
./setup.sh

# 3. Add your mission to Context.md (one line)

# 4. Start Claude Code
claude

# 5. Say hello - Claude handles the rest!
```

## The Houses

| House | Role | Professor | Domain |
|-------|------|-----------|--------|
| 🦅 **Ravenclaw** | Planners | Flitwick | Requirements, Architecture, Documentation |
| 🦁 **Gryffindor** | Builders | McGonagall | Code, Implementation, Making things real |
| 🐍 **Slytherin** | Testers | Snape | QA, Security, Code Review (VETO power) |
| 🦡 **Hufflepuff** | Glue Guys | Sprout | Integration, DevOps, Support |

## Hierarchy

```
          HEADMASTER (You, the human)
                    │
              PROFESSORS (Persistent masters)
                    │
               STUDENTS (Subagents - created/expelled as needed)
```

## Session Lifecycle

### Boot Sequence (Automatic)
When you start Claude, it automatically:
1. Reads Context.md, session-handoff.md, marauders-map.md
2. Greets you with castle status
3. Asks for your mission

### During Session
- Mandatory checkpoints update status files
- Points calculated after every task
- All houses consulted before major decisions

### Session End
Use `/close` to:
- Update Context.md with accomplishments
- Write session-handoff.md for next time
- Display session House Cup ceremony

## House Cup Scoring

```
Points = (Quality × Year Level) × Efficiency Multiplier

Where:
- Quality: 1-10 rating
- Year Level: 1 (safe) to 7 (critical)
- Efficiency: Expected tokens / Actual tokens
```

Points are announced after EVERY task. No exceptions.

## Student Lifecycle

```
Enrolled (Probationary)
       ↓ 3 successful tasks
    Active
       ↓ poor performance
    Warning
       ↓ continued issues
    Probation
       ↓ no improvement
    Memory Wipe (reset metrics, keep skills)
       ↓ still failing
    Expelled (removed)
```

## Key Files

```
project/
├── CLAUDE.md              # Framework rules (auto-loaded)
├── Context.md             # Your project details
├── .claude/rules/         # All Hogwarts protocols
│   ├── boot-sequence.md   # Session start protocol
│   ├── mandatory-consultation.md
│   ├── house-cup.md       # Scoring and enforcement
│   ├── expulsion.md       # Performance management
│   └── ...
├── skills/
│   ├── houses/            # Professor skills
│   ├── students/          # Student skills (auto-created)
│   ├── protocols/         # Emergency protocols
│   └── commands/          # /close and others
└── logs/
    ├── marauders-map.md   # Live agent status
    ├── session-handoff.md # Session continuity
    └── house-cup/         # Standings and tracking
```

## Commands

| Command | What it does |
|---------|--------------|
| `/close` | End session gracefully with ceremony |
| "Check Marauder's Map" | Show current agent status |
| "House Cup standings" | Display current scores |
| "Summon [House]" | Bring in that house's perspective |
| "Form an Order" | Assemble multi-house team for task |

## Threat Levels

- 🟢 **GREEN**: Normal operations
- 🟡 **YELLOW**: Deadline pressure, minor issues
- 🟠 **ORANGE**: Critical bug, security issue
- 🔴 **RED**: Production down, all hands on deck

## Philosophy

This framework enforces:
- **Quality**: Mandatory consultation catches issues early
- **Accountability**: Every task tracked, every point counted
- **Continuity**: Session handoffs preserve context
- **Excellence**: Underperformers are removed

The game is always on. There is no off mode.

## Requirements

- macOS
- Claude Code CLI
- Git

## License

MIT - Use freely, build great things.

---

*"It does not do to dwell on dreams and forget to live."* - Dumbledore

Ship quality. Ship often. Protect the users.
