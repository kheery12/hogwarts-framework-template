# Hogwarts Agent Framework

> A magical approach to AI agent coordination for software development.

## Overview

The Hogwarts Agent Framework structures AI agent teams like Hogwarts School of Witchcraft and Wizardry - a high-performing institution where specialized teachers (agents) work under coordinated leadership to build software.

**Key Features:**
- **House System** - Specialized agent teams (Gryffindor, Ravenclaw, Slytherin, Hufflepuff)
- **Year Levels** - Risk-based approval tiers (Year 1-7)
- **House Cup** - Performance tracking with points and expulsion
- **Skills** - Progressive context loading for efficient token usage
- **Contracts** - Formal interfaces between teams
- **Protocols** - Emergency response, rollback, and agent replacement
- **Wizard Status Line** - Magical themed status bar in Claude Code

## Quick Start (macOS)

### 1. Clone the Template

```bash
git clone https://github.com/[your-username]/hogwarts-framework-template.git my-project
cd my-project
```

### 2. Run Setup

```bash
chmod +x setup.sh
./setup.sh
```

Follow the prompts to configure your project.

### 3. Start Working

The framework is ready! Claude will automatically read `CLAUDE.md` at the start of each session.

## Structure

```
your-project/
├── CLAUDE.md                    # Project context (loads every session)
├── CLAUDE.local.md              # Personal preferences (gitignored)
├── .claude/
│   ├── settings.json            # Claude Code configuration
│   ├── statusline.sh            # Wizard-themed status bar script
│   └── rules/                   # Framework rules
│       ├── hogwarts-core.md     # Core hierarchy and processes
│       ├── house-cup.md         # Scoring system
│       ├── threat-levels.md     # Emergency protocols
│       ├── forbidden-actions.md # Unforgivable curses
│       └── interaction-protocols.md # Communication patterns
├── skills/
│   ├── houses/                  # House-specific skills
│   │   ├── gryffindor/SKILL.md  # Frontend & UX
│   │   ├── ravenclaw/SKILL.md   # Backend & Architecture
│   │   ├── slytherin/SKILL.md   # Testing & Security
│   │   └── hufflepuff/SKILL.md  # DevOps & Docs
│   ├── protocols/               # Operational protocols
│   │   ├── sorting-hat/         # Task assignment
│   │   ├── time-turner/         # Rollback procedures
│   │   ├── patronus/            # Emergency response
│   │   └── apparition/          # Agent replacement
│   └── internal/
│       └── skill-creator/       # Creating new skills
├── contracts/                   # Inter-house agreements
│   ├── api-contracts/
│   ├── component-contracts/
│   ├── test-contracts/
│   └── deploy-contracts/
├── logs/
│   ├── marauders-map.md         # Current status dashboard
│   ├── pensieve/                # Mission records
│   ├── house-cup/               # Points and standings
│   └── horcrux-registry/        # Technical debt tracking
└── docs/
    └── FRAMEWORK_REFERENCE.md   # Complete documentation
```

## The Four Houses

| House | Domain | Values |
|-------|--------|--------|
| **Gryffindor** | Frontend & UX | Courage, bold design, user-facing bravery |
| **Ravenclaw** | Backend & Architecture | Wisdom, complex problem-solving, system design |
| **Slytherin** | Testing & Security | Ambition, finding edge cases, breaking things constructively |
| **Hufflepuff** | DevOps & Docs | Loyalty, hard work, foundational excellence |

## Year Levels (Risk Tiers)

| Year | Risk | Examples | Approval |
|------|------|----------|----------|
| **1** | Minimal | Reading files, exploration | None |
| **3** | Low-Medium | Refactoring, adding tests | House Head |
| **5** | Medium-High | Architecture decisions, migrations | Deputy + House Head |
| **7** | Critical | Production deploys, data deletion | Headmaster + Human |

## House Cup

Agents earn points based on:
- **Quality** (1-10 score)
- **Efficiency** (tokens used vs expected)
- **Year Level** (complexity multiplier)

```
Points = (Quality × Year Level) × Efficiency Multiplier
```

The lowest-performing agent of the lowest-scoring House faces expulsion.

## Key Commands

When working with Claude:

```
"Check the Marauder's Map"           # View current status
"Form an Order for [task]"           # Assemble team
"Great Hall Assembly"                # Progress checkpoint
"Activate Patronus Protocol"         # Emergency response
"Time-Turner Protocol"               # Rollback changes
"Create skill for [feature]"         # Document knowledge
"House Cup standings"                # View points
```

## Creating a New Project

1. Clone this template
2. Run `./setup.sh your-project-name`
3. Customize `CLAUDE.md` for your specific needs
4. Start building!

## Customization

### Adding a New Skill

1. Create folder in `skills/features/[name]/`
2. Add `SKILL.md` with YAML frontmatter
3. Include triggers, patterns, and decision log template
4. Reference from relevant House skill

### Modifying House Behavior

Edit `skills/houses/[house]/SKILL.md` to:
- Add new patterns
- Update decision logs
- Modify quality checklists

### Changing Scoring

Edit `.claude/rules/house-cup.md` to adjust:
- Points formula
- Bonus criteria
- Expulsion thresholds

### Wizard Status Line

A magical status bar appears at the bottom of Claude Code showing:
- **Wizard title** based on model (Dumbledore for Opus, McGonagall for Sonnet, Flitwick for Haiku)
- **House** auto-detected from git branch name
- **Magic meter** showing context window usage
- **Galleons** showing session cost
- **Threat level** indicator (🟢🟡🟠🔴)

Example: `[🧙 Dumbledore] GRYFFINDOR | Magic: ▓▓▓░░░░░░░ 30% | Galleons: $0.02 | 🟢`

Customize: `.claude/statusline.sh`

## Contributing

This framework is open source. Contributions welcome:
- Bug fixes
- New protocol skills
- Documentation improvements
- House skill enhancements

## License

MIT License - Use freely, modify as needed.

---

*"It does not do to dwell on dreams and forget to live." - But it does help to plan before you code.*
