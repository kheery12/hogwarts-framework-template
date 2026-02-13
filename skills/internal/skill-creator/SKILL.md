---
name: skill-creator
description: Meta-skill for creating new skills. Use when the project needs a new skill documented, a feature skill created, or existing skills updated. Triggers on "create skill", "new skill", "document feature", "skill for", "update skill".
---

# Skill Creator

> This skill guides the creation of new skills for the Hogwarts Framework.

## When to Create a Skill

### Automatic Triggers
- Feature reaches Year 3+ complexity
- Architectural decision made
- New pattern/library introduced
- Cross-cutting concern emerges

### Manual Triggers
- Headmaster requests skill creation
- Human requests documentation
- Repeated questions about same topic

---

## Skill Types

### House Skills
Location: `skills/houses/[house]/SKILL.md`
Purpose: Domain expertise and patterns
Updated by: House Head or Documentation Manager

### Protocol Skills
Location: `skills/protocols/[protocol]/SKILL.md`
Purpose: Operational procedures
Updated by: Headmaster or designated agent

### Feature Skills
Location: `skills/features/[feature]/SKILL.md`
Purpose: Feature-specific context
Updated by: Agent who built the feature

### Internal Skills
Location: `skills/internal/[skill]/SKILL.md`
Purpose: Framework operations
Updated by: Headmaster only

---

## Skill Structure

### Required: YAML Frontmatter
```yaml
---
name: [kebab-case-name]
description: [What it does]. Use when [trigger conditions]. Triggers on "[keyword1]", "[keyword2]", "[keyword3]".
---
```

### Required Sections
1. **Title and Overview** - What this skill is for
2. **When to Use** - Clear trigger conditions
3. **Core Content** - The actual guidance
4. **Decision Log Template** - For recording choices
5. **Quality Checklist** - Verification before completion

### Recommended Sections
- Patterns and examples
- Anti-patterns to avoid
- Related skills/contracts
- House Points bonuses (if applicable)

---

## Creating a Feature Skill

When a feature is built, create a skill to preserve context:

### Template
```markdown
---
name: [feature-name]
description: [Feature description]. Use when working on [feature area]. Triggers on "[related keywords]".
---

# [Feature Name]

## Overview
[What this feature does and why it exists]

## Architecture

### Structure
[Directory structure, key files]

### Components/Services
[Main pieces and their responsibilities]

### Data Flow
[How data moves through the feature]

## Key Decisions

### [Decision 1 Title]
**Date**: [YYYY-MM-DD]
**Context**: [Why decision was needed]
**Decision**: [What was chosen]
**Rationale**: [Why]

## Integration Points
[How this feature connects to others]

## Contracts
[Relevant contracts this feature uses/provides]

## Testing
[How to test this feature]

## Common Tasks

### Adding [X]
[Step-by-step guide]

### Modifying [Y]
[Step-by-step guide]

## Gotchas
[Things to watch out for]
```

---

## Skill Content Rules

### DO Include
- Architectural decisions and rationale
- File structure and organization
- Component/function/class names
- Design patterns used
- Integration points
- Decision logs

### DO NOT Include
- Actual code implementations (keep high-level)
- Hardcoded values or secrets
- Detailed line-by-line logic
- Temporary workarounds (unless critical)

---

## Skill Creation Workflow

### Step 1: Identify Need
```markdown
## Skill Need Assessment

**Topic**: [What needs a skill]
**Trigger**: [Why now - complexity reached, decision made, etc.]
**Type**: [House/Protocol/Feature/Internal]
**Owner**: [Who will maintain this skill]
```

### Step 2: Gather Context
- Interview relevant agents
- Review Pensieve entries
- Check existing contracts
- Identify related skills

### Step 3: Draft Skill
- Use appropriate template
- Focus on patterns, not code
- Include decision rationale
- Add quality checklist

### Step 4: Review
- House Head reviews for accuracy
- Cross-reference with contracts
- Verify triggers are specific enough
- Check for completeness

### Step 5: Publish
- Place in correct location
- Update any cross-references
- Announce to relevant Houses
- Add to skill registry

---

## Skill Maintenance

### When to Update
- Feature changes significantly
- New patterns discovered
- Decision overturned
- Feedback indicates confusion

### Update Process
1. Load current skill
2. Identify changes needed
3. Update content
4. Update version in decision log
5. Notify dependent skills

### Skill Deprecation
If a skill becomes obsolete:
1. Mark as deprecated in frontmatter
2. Add notice at top explaining why
3. Point to replacement if applicable
4. Remove after 30 days if no dependencies

---

## Quality Checklist for New Skills

- [ ] YAML frontmatter valid
- [ ] Name is kebab-case
- [ ] Description includes WHAT and WHEN
- [ ] Trigger keywords are specific
- [ ] Content is high-level (no code dumps)
- [ ] Decision log template included
- [ ] Quality checklist present
- [ ] Placed in correct location
- [ ] Cross-references valid
- [ ] Reviewed by House Head

---

## Skill Registry

Maintain a registry at `docs/skill-registry.md`:

```markdown
## Skill Registry

### House Skills
| Skill | House | Last Updated | Maintainer |
|-------|-------|--------------|------------|

### Protocol Skills
| Skill | Purpose | Last Updated | Maintainer |
|-------|---------|--------------|------------|

### Feature Skills
| Skill | Feature | Last Updated | Maintainer |
|-------|---------|--------------|------------|
```
