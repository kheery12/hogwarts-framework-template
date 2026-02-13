---
name: patronus-protocol
description: Emergency response protocol. Use when facing critical issues, production outages, security breaches, or any situation requiring all-hands response. Triggers on "emergency", "production down", "outage", "breach", "critical bug", "patronus", "all hands", "battle stations", "red alert".
---

# Patronus Protocol

> "Expecto Patronum!"

The Patronus Protocol is activated when the project faces a critical threat requiring immediate, coordinated response.

## Activation

### Who Can Activate
- Headmaster (any reason)
- Deputy Headmaster (emergencies)
- Any House Head (their domain emergency)
- Any Prefect (with immediate Headmaster notification)
- Human (always)

### Activation Command
```
🚨 PATRONUS PROTOCOL ACTIVATED 🚨

REASON: [Brief description]
THREAT LEVEL: [Orange/Red]
ACTIVATED BY: [Name/Role]
TIME: [Timestamp]

ALL AGENTS: STOP CURRENT WORK AND REPORT TO GREAT HALL
```

---

## Immediate Actions (First 5 Minutes)

### Step 1: All Stop
- Every agent stops current work immediately
- Save current state (quick commit or note)
- Update Marauder's Map: "PATRONUS - Standing by"

### Step 2: Great Hall Assembly
All agents report status:
```markdown
## Patronus Roll Call

| Agent | House | Was Working On | Available |
|-------|-------|----------------|-----------|
| [Name] | [House] | [Task] | [Yes/No] |
```

### Step 3: Threat Assessment
Headmaster (or activator) provides:
```markdown
## Threat Briefing

**Situation**: [What's happening]
**Impact**: [Who/what is affected]
**Severity**: [Orange/Red]
**Known Cause**: [If known, or "Under investigation"]
**Immediate Risk**: [What could get worse]
```

---

## Team Formation

### Patronus Team Roles

**Shield Casters** (Containment)
- Prevent further damage
- Isolate affected systems
- Protect user data
- Usually: Hufflepuff (infra) + Slytherin (security)

**Healers** (Resolution)
- Fix the immediate issue
- Implement hotfix
- Restore service
- Usually: Primary domain House

**Scouts** (Investigation)
- Find root cause
- Gather evidence
- Document findings
- Usually: Ravenclaw + affected House

**Messengers** (Communication)
- Keep human informed
- Update status page
- Coordinate external communication
- Usually: Hufflepuff

### Team Assignment
```markdown
## Patronus Team Assignment

**Shield Casters**: [Agents]
- Objective: [Specific containment goal]

**Healers**: [Agents]
- Objective: [Specific fix goal]

**Scouts**: [Agents]
- Objective: [Specific investigation goal]

**Messengers**: [Agents]
- Objective: [Communication plan]
```

---

## Communication Protocol

### Update Frequency
- **Red Threat**: Every 5 minutes
- **Orange Threat**: Every 10 minutes

### Update Format
```markdown
## Patronus Update - [Timestamp]

**Status**: [Investigating/Containing/Fixing/Resolved]
**Progress**: [What's been done]
**ETA**: [Estimated resolution time]
**Blockers**: [Any obstacles]
**Next Steps**: [Immediate actions]
```

### Human Communication
- Notify human immediately on activation
- Provide updates per schedule
- Escalate if resolution taking longer than expected
- Get approval for any Year 5+ fixes

---

## Resolution Phases

### Phase 1: Contain (Stop the Bleeding)
**Goal**: Prevent further damage
**Actions**:
- Isolate affected systems
- Block problematic traffic
- Disable failing features
- Enable maintenance mode if needed

**Exit Criteria**: No new damage occurring

### Phase 2: Mitigate (Reduce Impact)
**Goal**: Minimize user impact
**Actions**:
- Implement workarounds
- Enable fallbacks
- Communicate with users
- Redirect traffic if possible

**Exit Criteria**: User impact minimized

### Phase 3: Fix (Resolve the Issue)
**Goal**: Implement proper solution
**Actions**:
- Deploy hotfix
- Run targeted tests
- Monitor closely
- Verify resolution

**Exit Criteria**: Issue resolved

### Phase 4: Verify (Confirm Stable)
**Goal**: Ensure stability
**Actions**:
- Monitor for 15+ minutes
- Run full health checks
- Verify all critical paths
- Check error rates

**Exit Criteria**: System stable for monitoring period

---

## De-escalation

### Requirements to De-escalate
- [ ] Issue fully resolved
- [ ] Root cause identified (or contained)
- [ ] Prevention measures identified
- [ ] System stable for 15+ minutes
- [ ] Headmaster approval

### De-escalation Announcement
```
✅ PATRONUS PROTOCOL DEACTIVATED ✅

REASON: [Resolution summary]
DURATION: [Start to end time]
ROOT CAUSE: [Brief explanation]

All agents may return to normal operations.
Post-incident review will be scheduled.
```

---

## Post-Incident

### Immediate (Within 1 hour)
- [ ] Update Marauder's Map
- [ ] Create Pensieve entry
- [ ] Notify all stakeholders
- [ ] Initial root cause documented

### Within 24 Hours
- [ ] Complete incident report
- [ ] Schedule post-incident review
- [ ] Identify immediate improvements
- [ ] Update affected documentation

### Post-Incident Review (Within 1 Week)
```markdown
## Post-Incident Review: [Title]

**Date**: [Review date]
**Incident Date**: [When it happened]
**Duration**: [How long]
**Severity**: [Orange/Red]

### What Happened
[Timeline of events]

### Root Cause
[Why it happened]

### Impact
[Who/what was affected]

### What Went Well
[Positive aspects of response]

### What Could Be Improved
[Areas for improvement]

### Action Items
| Action | Owner | Due Date |
|--------|-------|----------|
```

---

## Special Rules During Patronus

### Suspended
- House Points tracking
- Efficiency scoring
- Non-critical work
- Normal approval processes (expedited for emergencies)

### Active
- Direct communication (skip Prefect relay)
- Cross-House collaboration
- Human in the loop
- Documentation (for post-incident)

### House Cup Impact
- No points deducted for emergency work
- +10 points to House that resolved the issue
- +5 points to each supporting House
- Points still deducted if agent caused the incident

---

## Patronus Drills

Quarterly, conduct a Patronus drill:

1. Headmaster announces drill (or surprise drill)
2. Simulate a realistic emergency
3. Execute full Patronus Protocol
4. Measure response time and effectiveness
5. Conduct mini post-incident review
6. Update procedures based on learnings

**Drill Types**:
- Production outage simulation
- Security breach simulation
- Data integrity issue simulation
- Performance degradation simulation
