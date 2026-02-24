# Recovery Protocol
<!-- Handle unexpected context compaction gracefully -->

## Detecting Degraded Context

Signs that compaction occurred:
- Cannot recall recent decisions made this session
- Asking about topics already discussed
- Losing track of current task or objective
- Confusion about what files were already read
- Repeating questions that were answered
- Uncertainty about current threat level

---

## Recovery Steps

### Step 1: STOP
Stop current work immediately. Do not attempt to continue mid-task.

### Step 2: Announce
Say: "Context recovery needed. Reading handoff..."

### Step 3: Read Core Files
In order:
1. `logs/session-handoff.md` - What happened, what remains
2. `logs/marauders-map.md` - Current state and agents
3. Check "Files NOT to Re-Read" section - avoid token waste

### Step 4: Assess Severity
- **Mild**: Remember session goals, forgot details -> Continue after reading
- **Moderate**: Forgot recent work, remember start -> Restart current task
- **Severe**: Lost session context entirely -> Suggest fresh session

### Step 5: Resume or Restart
- If mild/moderate: Resume from last checkpoint in handoff
- If severe: Recommend user start fresh session

---

## Write Emergency Handoff

If compaction detected mid-task, IMMEDIATELY write state to disk:

```markdown
## EMERGENCY HANDOFF - [timestamp]

### Task Interrupted
[What was being worked on]

### State at Interruption
[What was completed vs pending]

### Files Modified
[List any files changed]

### Critical Context
[Any decisions or state that must not be lost]

### Recovery Action
[What next session should do first]
```

Save to: `logs/session-handoff.md` (overwrite current)

---

## Prevention Measures

### During Session
- Update handoff incrementally, not just at end
- Log key decisions to Pensieve immediately
- Keep Marauder's Map current
- Checkpoint every 5-10 tool calls

### High-Risk Indicators
Watch for these - increase checkpoint frequency:
- Long sessions (>30 minutes active)
- Many tool calls in sequence
- Large file reads
- Complex multi-step tasks

---

## Recovery Announcement Format

```
Context Recovery Initiated

Reading: logs/session-handoff.md...
Reading: logs/marauders-map.md...

Session Context Restored:
- Last task: [from handoff]
- Current state: [from map]
- Threat level: [from handoff]

Files already processed (not re-reading):
- [list from handoff]

Resuming from: [checkpoint or fresh start]
```

---

## When to Suggest Fresh Session

Recommend fresh session if:
- Cannot reconstruct session context from files
- Multiple compaction events in same session
- Critical decisions were made but not recorded
- User reports confusion or inconsistency
- Handoff file is empty or corrupted

Say: "Context severely degraded. Recommend starting fresh session. Current state saved to handoff."

---
*Recovery protocol owned by Hufflepuff. Updated: [timestamp]*
