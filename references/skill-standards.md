# Skill Creation Standards

> The official guide for forging new skills in the Hogwarts Framework.

## Required SKILL.md Structure

### Frontmatter (YAML)

```yaml
---
name: lowercase-with-hyphens
description: Pushy description stating WHEN to use. "ALWAYS use when X. Triggers on Y, Z."
allowed-tools: Read, Write, Edit    # Optional: specific tools permitted
model: haiku|sonnet|opus            # Optional: for subagent invocation
user-invocable: true                # Optional: can user call directly?
---
```

### Description Writing

The description is the PRIMARY trigger mechanism. Make it pushy.

**BAD Examples:**
- "Helps with frontend development"
- "A skill for testing"
- "Handles documents"

**GOOD Examples:**
- "ALWAYS use when building UI components, pages, or web interfaces. Triggers on 'build', 'create UI', 'frontend', 'component'."
- "ALWAYS use when reviewing code, running tests, or validating security. Triggers on 'test', 'review', 'check', 'validate'."

## Size Limits

| Component | Max Lines | Action if exceeded |
|-----------|-----------|-------------------|
| SKILL.md total | 200 | Split to references/ |
| Single section | 50 | Extract to separate file |
| Inline examples | 3 | Move extras to examples/ |

## Required Sections

Every SKILL.md must have:

1. **Title & Motto** (1-2 lines)
2. **Domain** (bullet list of what this skill covers)
3. **Constraints** (3-5 things to NEVER do) ← CRITICAL
4. **Triggers** (when to activate)
5. **Workflow** (numbered steps)
6. **Output Format** (what to produce)

## Constraints Formula

Constraints force precision better than instructions. Every skill needs:

```markdown
## Constraints (NEVER Do)
- NEVER [invent/fabricate specific data type]
- NEVER [exceed specific scope boundary]
- NEVER [skip specific required step]
- NEVER [produce without specific quality check]
- NEVER [action without specific prerequisite]
```

**Example - Frontend Skill:**
```markdown
## Constraints (NEVER Do)
- NEVER build without design requirements
- NEVER use generic AI aesthetics (gradient backgrounds, stock layouts)
- NEVER skip responsive considerations
- NEVER hardcode values that should be variables
- NEVER submit without visual self-review
```

## Directory Structure

```
skill-name/
├── SKILL.md              # Core instructions (<200 lines)
├── references/           # Extended documentation
│   ├── detailed-guide.md
│   └── edge-cases.md
├── examples/             # Sample inputs/outputs
│   └── example-1.md
├── scripts/              # Executable helpers
│   └── helper.py
└── evals/                # Test cases (future)
    └── evals.json
```

## House Assignment Matrix

| Skill Domain | Primary House | Reasoning |
|--------------|---------------|-----------|
| Planning, architecture, specs, research | Ravenclaw | Intellectual work |
| Building, implementation, code, UI | Gryffindor | Execution work |
| Testing, security, review, validation | Slytherin | Quality work |
| Integration, documents, deployment, comms | Hufflepuff | Glue work |

## Quality Checklist

Before deploying any skill:

- [ ] Description is pushy and specific
- [ ] Has 3-5 concrete constraints
- [ ] Under 200 lines (or properly split)
- [ ] Assigned to correct house
- [ ] Workflow has numbered steps
- [ ] Output format defined
- [ ] Slytherin reviewed and approved
