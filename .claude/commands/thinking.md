---
name: thinking
description: Toggle extended thinking mode based on task complexity. Use to enable deep reasoning for complex tasks or disable for simple operations.
---

# Thinking Mode Control

## Usage

- `/thinking on` - Force extended thinking (ultrathink)
- `/thinking off` - Standard mode, faster responses
- `/thinking auto` - Auto-detect based on task (default)

## Auto-Detection Rules

### Enable Thinking When:
| Trigger | Reason |
|---------|--------|
| Year 5+ tasks | Architecture, migrations need deep reasoning |
| Multi-house consultations | Complex coordination |
| Slytherin security reviews | Thorough analysis required |
| Ravenclaw planning sessions | Strategic thinking |
| Keywords: "analyze", "debug", "architect", "design", "why", "complex" | Signals need for depth |

### Disable Thinking When:
| Trigger | Reason |
|---------|--------|
| Year 1-2 tasks | Simple operations |
| Single-file changes | Straightforward edits |
| Routine builds from spec | Execution, not reasoning |
| Keywords: "quick", "just", "simple", "fast" | Speed prioritized |

## House Defaults

| House | Default Mode | Rationale |
|-------|--------------|-----------|
| Ravenclaw | ON | Planning requires deep thought |
| Gryffindor | AUTO | Varies by implementation complexity |
| Slytherin | ON | Security review needs thoroughness |
| Hufflepuff | OFF | Integration tasks are procedural |

## Implementation Note

When thinking is ON, the "ultrathink" keyword is used internally to maximize reasoning depth for the current task.
