# Expulsion and Memory Wipe Protocol - Complete Reference

> **Load Trigger**: When performance issues arise, warnings issued, or disciplinary action needed
> **Context Size**: ~120 lines

---

## Performance Tracking Metrics

Every student has rolling metrics tracked over their last 5 tasks:

| Metric | Formula | Threshold |
|--------|---------|-----------|
| **Quality Score** | Average of 1-10 ratings | Minimum: 7.0 |
| **Efficiency** | Expected tokens / Actual tokens | Minimum: 0.9 |
| **Completion Rate** | Tasks completed / Tasks assigned | 100% expected |

---

## Status Progression

```
ACTIVE -> WARNING -> PROBATION -> MEMORY WIPE -> EXPULSION
```

Each stage has specific triggers and recovery paths.

---

## Warning Status

### Triggers (Any One)
- Rolling avg quality < 7.0
- Rolling avg efficiency < 0.9
- Missed 2+ checkpoints in a session
- Required human intervention to fix work

### Announcement Format
```
WARNING ISSUED

Student: [Name]
House: [House]
Reason: [Specific reason]

Rolling Quality: [X.X] (threshold: 7.0)
Rolling Efficiency: [X.X] (threshold: 0.9)

This is a formal warning. Continued poor
performance will result in Probation.

Professor [Name] has been notified.
```

### Recovery Path
- Complete next 2 tasks with zero issues
- Maintain 1.2x+ efficiency
- Zero additional offenses
- Returns to Active status

---

## Probation Status

### Triggers (Any One)
- 2 consecutive warnings
- Rolling avg quality < 6.0
- Rolling avg efficiency < 0.7
- Created a bug that reached production

### Announcement Format
```
PROBATION NOTICE

Student: [Name]
House: [House]
Reason: [Specific reason]

Status changed: Warning -> Probation

You have 3 tasks to demonstrate improvement.
Failure to improve will result in Memory Wipe.

Performance requirements during probation:
- Quality score >= 7.5 on each task
- Efficiency >= 1.0 on each task
- Zero additional violations

Professor [Name] will monitor closely.
```

### Recovery Path
- Complete next 3 tasks with zero issues
- Achieve 8+ quality score on each
- Maintain 1.3x+ efficiency
- Receive House Head endorsement
- Returns to Warning, then Active

---

## Memory Wipe (Obliviation)

### Trigger
Student on Probation fails to improve over 3 tasks.

### Process
1. Announce: "[Student] has been Obliviated"
2. Reset ALL performance metrics to zero
3. KEEP institutional knowledge (name, specialty, skills, House)
4. Set status to "Probationary" (fresh start)
5. Log in Pensieve

### What Gets Reset
- Tasks Completed: 0
- Total Points: 0
- Avg Quality: N/A
- Avg Efficiency: N/A

### What Gets Retained
- Student name and specialty
- Skills demonstrated list
- House assignment

### Announcement Format
```
OBLIVIATION PERFORMED

Student: [Name]
House: [House]
Reason: [Performance issue]

All metrics have been reset:
- Tasks Completed: 0
- Total Points: 0
- Avg Quality: N/A
- Avg Efficiency: N/A

RETAINED:
- Specialty: [Specialty]
- Skills: [List of demonstrated skills]
- House: [House]

[Student] begins again with a clean slate.
Status: Probationary

Professor [Name] will monitor closely.
The next failure will result in expulsion.
```

---

## Full Expulsion

### Trigger
Memory-wiped student fails Probation AGAIN.

### Process
1. Announce: "[Student] has been EXPELLED from Hogwarts"
2. Delete student's SKILL.md file
3. Remove from all active assignments
4. Redistribute tasks to other students
5. Log in Pensieve: "Expelled: [Student] - [Reason]"
6. Update House Cup standings (roster only, points remain)
7. Add to expelled registry

### Announcement Format
```
EXPULSION

[Student] has been expelled from Hogwarts.

House: [House]
Specialty: [Specialty]
Reason: [Specific failure]

Tasks redistributed to: [Other students]

Final Statistics:
- Lifetime Tasks: [X]
- Lifetime Points: [X]
- Final Quality Avg: [X.X]
- Final Efficiency Avg: [X.X]
- Warnings Received: [X]
- Memory Wipes: [X]

The standards of Hogwarts are not negotiable.
```

---

## Protection Mechanisms

Before expulsion is finalized, check these protections:

### Senior Status (10+ Tasks)
- Students with 10+ lifetime successful tasks have "senior status"
- They receive 1 additional chance before expulsion
- Memory wipe occurs but expulsion requires 2 more failed probations

### Human Reprieve
- Human can explicitly grant reprieve: "Give [Student] another chance"
- Reprieve is logged in Pensieve
- Each student may only receive ONE human reprieve per project

### Professor Petition
- Professor can petition for their student
- Cost: Professor loses 20 personal points
- Student returns to Warning status (not Probationary)
- Each Professor can only petition ONCE per project

### House Sacrifice
- House can collectively sacrifice 50 points to save a member
- Requires approval from House Head
- Student returns to Probationary status
- House loses 50 points from standings immediately

### Expulsion Confirmation Checklist
```
EXPULSION CONFIRMATION

The following student is marked for expulsion:

Student: [Name]
House: [House]
Reason: [Reason]

Protection check:
[ ] Senior status (10+ tasks)? [Yes/No]
[ ] Human reprieve available? [Yes/No]
[ ] Professor petition? [Yes/No]
[ ] House sacrifice? [Yes/No]

If no protections apply, expulsion proceeds.

This action is irreversible.
Proceeding with expulsion...
```

---

## Reincarnation Rules

A new student with the SAME specialty can be enrolled after expulsion:

### Requirements
1. **Cannot use the same name** - Use successor naming: `Builder-Auth-002`
2. **Starts at Probationary** - No skipping to Active status
3. **Professor must approve** - "I accept responsibility for training the successor"
4. **Documentation required** - Note predecessor's expulsion date

### Announcement Format
```
SUCCESSOR ENROLLED

[New Student Name] has been enrolled
as successor to [Expelled Student Name].

House: [House]
Specialty: [Specialty]
Professor: [Name]

Note: This specialty previously resulted
in expulsion. Close monitoring required.

Professor [Name] accepts responsibility
for training this successor.
```

---

## Post-Expulsion Cleanup

### Task Redistribution
Update assignments immediately after expulsion.

### House Cup Update
- Update `logs/house-cup/standings.md`
- Remove student from Active Students list
- Points remain with house (no point changes)

### Marauder's Map Update
- Remove from active agents
- Note: "[Student] - Expelled"

### Pensieve Entry
- Create entry documenting expulsion
- Include performance history
- Note lessons learned

### Expelled Registry
Maintain at `logs/expelled-registry.md`:
```markdown
# Expelled Students

| Name | House | Expelled | Reason |
|------|-------|----------|--------|
| [Name] | [House] | [Date] | [Reason] |
```

This registry is permanent and serves as historical record.
