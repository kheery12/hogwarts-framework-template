# Hogwarts Agent Framework v3

A lean, research-backed multi-agent coordination framework for Claude Code.

## What's New in v3

- **80% smaller rule footprint** - 7 core rules instead of 50+
- **Balanced house involvement** - All 4 houses participate every session
- **Slash commands** - /handoff, /status, /enroll, /points, /council
- **Progressive disclosure** - Details in references/, loaded on-demand
- **Compaction-resistant** - Survives context summarization

## House Workflow (Balanced)

Every session involves ALL houses:

| House | Role | Guaranteed Trigger |
|-------|------|-------------------|
| Ravenclaw | Planning | New features, architecture |
| Gryffindor | Building | Code writing, implementation |
| Slytherin | Review | Before any "done" |
| Hufflepuff | Sessions | Start + end of every session |

**Balance Mechanic**: Using all 4 houses on a task = 1.5x point multiplier.

## Quick Start

```bash
# 1. Clone the template
git clone https://github.com/kheery12/hogwarts-framework-template my-project
cd my-project

# 2. Add your mission to Context.md (one line)

# 3. Start Claude Code
claude
```

That's it. Claude reads CLAUDE.md and handles the rest.

## Commands

| Command | Action |
|---------|--------|
| `/handoff` | End session gracefully, write handoff notes |
| `/status` | View Marauder's Map (agent status) |
| `/enroll [house] [specialty]` | Add a student agent |
| `/points` | House Cup standings |
| `/council [topic]` | 4-house consultation |

## File Structure

```
project/
├── CLAUDE.md              # 7 core rules (auto-loaded)
├── Context.md             # Project state + house tracking
├── .claude/rules/
│   └── core.md            # Workflow gates, roles, points
├── references/            # Loaded on-demand
│   ├── house-cup.md       # Scoring details
│   ├── expulsion.md       # Performance management
│   ├── threat-levels.md   # Emergency protocols
│   └── ...
├── skills/
│   ├── houses/            # House skills
│   ├── students/          # Student agents
│   ├── protocols/         # enrollment, handoff
│   └── commands/          # Slash commands
├── contracts/             # Cross-house interfaces
└── logs/
    ├── marauders-map.md   # Live agent status
    ├── session-handoff.md # Session continuity
    └── house-cup/         # Standings
```

## The Houses

| House | Professor | Domain |
|-------|-----------|--------|
| Ravenclaw | Flitwick | Planning, Requirements, Architecture |
| Gryffindor | McGonagall | Code, Implementation, Building |
| Slytherin | Snape | Testing, QA, Security, Code Review |
| Hufflepuff | Sprout | Integration, DevOps, Session Lifecycle |

## Year Levels (Risk Tiers)

| Year | Risk | Examples | Approval |
|------|------|----------|----------|
| 1 | Minimal | Reading files, research | None |
| 3 | Low-Med | Refactoring, tests | Professor |
| 5 | Med-High | Architecture, migrations | Professor + Deputy |
| 7 | High | Production, data deletion | Human required |

## Philosophy

Research-backed design principles:

1. **5-10 rules max** - LLM working memory limit
2. **No explanatory prose** - Competes with instructions
3. **Plain imperatives** - No CRITICAL/NEVER/MUST inflation
4. **State on disk** - Not in conversation memory
5. **Progressive disclosure** - Load details when needed

## Points Formula

```
Points = (Quality x Year) x Efficiency
       = (1-10 rating x Year Level) x (Expected/Actual tokens)

Multipliers:
- All 4 houses involved: 1.5x
- Zero rework: +3 bonus
- Efficiency capped: 0.5 to 2.0
```

## Threat Levels

- GREEN: Normal operations
- YELLOW: Deadline pressure, minor issues
- ORANGE: Critical bug, security concern
- RED: Production down, all hands

## Requirements

- macOS or Linux
- Claude Code CLI
- Git

## License

MIT - Use freely, build great things.

---

*Ship quality. Ship often. Protect the users.*
