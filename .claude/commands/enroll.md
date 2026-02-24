# /enroll [house] [specialty]

Create a new student agent. Example: `/enroll gryffindor auth`

## Arguments

- **house**: gryffindor | ravenclaw | slytherin | hufflepuff
- **specialty**: The student's focus area (e.g., auth, api, ui, testing)

## Steps

1. Validate house has capacity (<5 students per house)
2. Generate student name: `[Specialty]-Student-[Number]`
3. Create skill file at `skills/students/[house]/[name]/SKILL.md`
4. Initialize with Probationary status (Year 1)
5. Update `logs/marauders-map.md` with new agent
6. Announce enrollment

## Student SKILL.md Template

```markdown
# [Name]

**House:** [House]
**Professor:** [House Head]
**Specialty:** [specialty]
**Status:** Probationary
**Year:** 1

## Capabilities
- [specialty]-related tasks only
- Must request professor review for all work
- Cannot approve own merges

## Advancement Criteria
- Complete 3 tasks successfully
- Zero rollbacks
- Professor endorsement
```

## Output (3 lines)

```
[House emoji] [Name] enrolled in [House]
Specialty: [specialty] | Professor: [name]
Status: Probationary (Year 1)
```

## Validation Errors

- "House at capacity (5/5 students)" → Cannot enroll
- "Invalid house name" → List valid options
