---
name: skill-forge
description: ALWAYS use when creating, modifying, or evaluating skills. Triggers on "create skill", "new skill", "build skill", "improve skill", "skill for". The official protocol for forging new magical abilities.
allowed-tools: Read, Write, Edit, Glob, Grep
---

# The Skill Forge

> "Where new magical abilities are carefully crafted and tested."

## Domain
- Creating new skills
- Modifying existing skills
- Evaluating skill effectiveness
- Skill architecture decisions

## Constraints (NEVER Do)
- NEVER create skills without reading `references/skill-standards.md` first
- NEVER create skills with vague descriptions
- NEVER create monolithic skills (>200 lines without splitting)
- NEVER skip Slytherin review before deployment
- NEVER duplicate functionality of existing skills

## Triggers
Activate when user mentions:
- "create a skill", "new skill", "build a skill"
- "improve this skill", "fix this skill"
- "skill for [purpose]"
- "automate this workflow"

## Workflow

### Phase 1: Intent Capture
1. Ask: What should this skill accomplish?
2. Ask: When should it trigger? (be specific)
3. Ask: What should it NEVER do? (constraints)
4. Ask: What's the expected output format?

### Phase 2: Research
5. Check existing skills: `ls skills/houses/*/skills/`
6. Verify no duplication
7. Determine correct house assignment
8. Read `references/skill-standards.md`

### Phase 3: Draft
9. Create SKILL.md with required sections
10. Write pushy description
11. Define 3-5 constraints
12. Document workflow steps
13. Specify output format

### Phase 4: Review
14. Self-check against standards
15. Submit to Slytherin for review
16. Address feedback
17. Deploy to appropriate house's `skills/` directory

### Phase 5: Register
18. Update house's available skills list
19. Announce: "[Skill Name] forged and ready in [House]"

## Output Format

New skill announcement:
```
Skill Forged: [name]
House: [Ravenclaw/Gryffindor/Slytherin/Hufflepuff]
Triggers: [list of trigger phrases]
Location: skills/houses/[house]/skills/[name]/SKILL.md

Constraints enforced:
- [constraint 1]
- [constraint 2]
- [constraint 3]

Reviewed by: Slytherin
Status: Ready for use
```

## Reference
For complete standards, see: `references/skill-standards.md`
