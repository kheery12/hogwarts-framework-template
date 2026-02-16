---
name: enrollment
description: Automatically create new student agents when skill gaps are identified
triggers:
  - new student needed
  - skill gap identified
  - enroll student
---

# Student Enrollment Protocol

## Purpose
Automatically create new specialized student agents when:
- A task requires expertise no existing student has
- Workload requires more agents in a house
- A new specialization emerges from project needs

## Auto-Enrollment Trigger
When assigning a task, if no suitable student exists:

1. **Identify the Gap**
   - What skill is needed?
   - Which house owns this domain?
   - What should the specialization be?

2. **Create Student File**
   Location: `skills/students/[house]/[name]/SKILL.md`

   Example: `skills/students/gryffindor/Builder-Auth-001/SKILL.md`

3. **Initialize Student Record**
```markdown
---
name: [Student-Name]
house: [House]
professor: [Professor Name]
specialty: [Specific skill]
enrolled: [Date]
status: active
---

# Student: [Name]

## Profile
- **House**: [House]
- **Professor**: [Professor Name]
- **Specialty**: [What they're expert in]
- **Enrolled**: [Date]

## Performance Metrics
| Metric | Value |
|--------|-------|
| Tasks Completed | 0 |
| Total Points | 0 |
| Avg Quality | N/A |
| Avg Efficiency | N/A |
| Status | Probationary |

## Task History
| Date | Task | Quality | Efficiency | Points |
|------|------|---------|------------|--------|
| - | - | - | - | - |

## Skills Demonstrated
<!-- Auto-updated after each task -->
- [pending first task]

## Professor Notes
<!-- Observations from Professor -->
- New enrollment, awaiting first assignment

## Warnings/Commendations
- None yet
```

4. **Announce Enrollment**
```
NEW STUDENT ENROLLED

[House emoji] Welcome [Student-Name] to [House]!
Specialty: [specialty]
Reporting to: Professor [Name]

First assignment: [Current task]
```

## Enrollment Rules
- Students start with "Probationary" status
- After 3 successful tasks -> "Active" status
- Student names format: `[Role]-[Specialty]-[Number]`
- Maximum 5 active students per house (prevents sprawl)

## Student Lifecycle
```
Enrolled (Probationary)
       |
       | 3 successful tasks
       v
    Active
       |
       | poor performance
       v
    Warning
       |
       | continued issues
       v
    Probation
       |
       | no improvement
       v
    Memory Wipe (reset metrics, keep skills)
       |
       | still failing
       v
    Expelled (SKILL.md deleted)
```

---

## Enrollment Ceremony

When a new student is enrolled, announce with ceremony:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              THE SORTING HAT SPEAKS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A new student enters Hogwarts...

Name: [Student-Name]
Specialty: [Specialty]

"Hmm, I see [trait description]...
 Yes, you belong in..."

[HOUSE EMOJI] [HOUSE NAME]! [HOUSE EMOJI]

Reporting to: Professor [Name]
Status: Probationary

May you bring honor to your House.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Student Naming Convention

Format: `[Role]-[Specialty]-[Number]`

### By House:

**Ravenclaw (Planners)**
- `Planner-API-001`
- `Planner-Database-001`
- `Planner-Architecture-001`

**Gryffindor (Builders)**
- `Builder-UI-001`
- `Builder-Auth-001`
- `Builder-Forms-001`

**Slytherin (Testers)**
- `Tester-Unit-001`
- `Tester-Security-001`
- `Tester-Integration-001`

**Hufflepuff (Glue)**
- `Glue-Docs-001`
- `Glue-Deploy-001`
- `Glue-Config-001`

---

## Enrollment Validation

Before enrolling, verify:

1. **House Capacity**: < 5 active students in target house
2. **No Duplicate Specialty**: No existing active student with same specialty
3. **Valid House**: Task domain matches house
4. **Professor Available**: House has capacity to mentor

If validation fails:
```
ENROLLMENT BLOCKED

Reason: [specific reason]
Alternative: [suggested action]
```

---

## Post-Enrollment Requirements

After enrollment, the new student MUST:

1. Complete their first task within the current session
2. Have their work reviewed by their Professor
3. Receive initial House Points (or deduction)
4. Have their metrics updated in their SKILL.md file

Failure to complete first task = Warning status immediately.

---

## Emergency Enrollment

In RED threat level situations:
- Skip ceremony (just announce)
- Enroll directly as "Active" (skip Probationary)
- No capacity limits (emergency expansion)
- Document in Pensieve: "Emergency enrollment"

Post-emergency, review all emergency enrollees and adjust status.
