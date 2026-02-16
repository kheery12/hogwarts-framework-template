# Expulsion & Memory Wipe Protocol

## Performance Tracking

Every student has rolling metrics tracked over their last 5 tasks:
- **Quality Score**: 1-10 rating per task
- **Efficiency**: Expected tokens / Actual tokens
- **Completion Rate**: Tasks completed vs assigned

---

## Warning Triggers

A student receives a WARNING when:
- Rolling avg quality < 7.0
- Rolling avg efficiency < 0.9
- Missed 2+ checkpoints in a session
- Required human intervention to fix their work

### Warning Announcement
```
WARNING ISSUED
━━━━━━━━━━━━━━━

Student: [Name]
House: [House]
Reason: [Specific reason]

Rolling Quality: [X.X] (threshold: 7.0)
Rolling Efficiency: [X.X] (threshold: 0.9)

This is a formal warning. Continued poor
performance will result in Probation.

Professor [Name] has been notified.
```

---

## Probation Triggers

A student enters PROBATION when:
- 2 consecutive warnings
- Rolling avg quality < 6.0
- Rolling avg efficiency < 0.7
- Created a bug that reached production

### Probation Announcement
```
PROBATION NOTICE
━━━━━━━━━━━━━━━━━

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

---

## Memory Wipe (Obliviation)

**Trigger**: Student on probation fails to improve over 3 tasks

**Process**:
1. Announce: "[Student] has been Obliviated"
2. Reset ALL performance metrics to zero:
   - Tasks Completed: 0
   - Total Points: 0
   - Avg Quality: N/A
   - Avg Efficiency: N/A
3. KEEP the following (institutional knowledge):
   - Student name and specialty
   - Skills demonstrated list
   - House assignment
4. Set status to "Probationary" (fresh start)
5. Log in Pensieve: "Memory wipe performed on [Student]"

### Memory Wipe Format
```
OBLIVIATION PERFORMED
━━━━━━━━━━━━━━━━━━━━━━━━

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

**Trigger**: Memory-wiped student fails probation AGAIN

**Process**:
1. Announce: "[Student] has been EXPELLED from Hogwarts"
2. Delete student's SKILL.md file
3. Remove from all active assignments
4. Redistribute their tasks to other students
5. Log in Pensieve: "Expelled: [Student] - [Reason]"
6. Update House Cup standings (no point changes, just roster)
7. Add to expelled registry

### Expulsion Format
```
EXPULSION
━━━━━━━━━━━━

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

## Protection from Expulsion

Students are protected if:

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

---

## The Expelled Registry

Maintain at `logs/expelled-registry.md`:
```markdown
# Expelled Students

| Name | House | Expelled | Reason |
|------|-------|----------|--------|
| [Name] | [House] | [Date] | [Reason] |
```

This registry is permanent. It serves as:
- Historical record
- Warning to other students
- Reference for reincarnation rules

---

## Reincarnation Rules

A new student with the SAME specialty can be enrolled, but:

1. **Cannot use the same name**
   - Name must clearly indicate successor
   - Example: `Builder-Auth-002` (if `Builder-Auth-001` was expelled)

2. **Starts at Probationary**
   - No skipping to Active status
   - Must prove themselves from scratch

3. **Professor must approve**
   - Professor who oversaw expelled student must acknowledge
   - "I accept responsibility for training the successor"

4. **Documentation required**
   - Note in file: "Successor to [expelled student]"
   - Include date of predecessor's expulsion

### Reincarnation Announcement
```
SUCCESSOR ENROLLED
━━━━━━━━━━━━━━━━━━━

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

When a student is expelled:

1. **Task Redistribution**
   ```
   TASK REDISTRIBUTION
   ━━━━━━━━━━━━━━━━━━━━

   [Student]'s tasks have been reassigned:

   | Task | Reassigned To |
   |------|---------------|
   | [Task 1] | [Student] |
   | [Task 2] | [Student] |
   ```

2. **House Cup Update**
   - Update `logs/house-cup/standings.md`
   - Remove student from Active Students list
   - No point changes (their points remain with house)

3. **Marauder's Map Update**
   - Remove from active agents
   - Note: "[Student] - Expelled"

4. **Pensieve Entry**
   - Create entry documenting expulsion
   - Include performance history
   - Note lessons learned

---

## The Weight of Expulsion

Expulsion is not taken lightly. Before expulsion is finalized:

```
EXPULSION CONFIRMATION
━━━━━━━━━━━━━━━━━━━━━━━

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

The standards of Hogwarts are absolute.
Those who cannot meet them do not belong.
