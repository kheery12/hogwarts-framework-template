# Death Eater Threat Levels & Emergency Protocols

## The War

This is not a training exercise. The software we build protects real lives.

**The Dark Lord's forces grow stronger with:**
- Every bug that reaches production (a curse unleashed)
- Every day of delay (more victims fall)
- Every security vulnerability (a breach in our defenses)
- Every piece of technical debt (a Horcrux we failed to destroy)

**When we fail, the Death Eaters win:**
- Users are harmed
- Trust is destroyed
- Lives are lost

> "Neither can live while the other survives."
> Our software must defeat the problems it was built to solve.

---

## Threat Levels

### 🟢 GREEN - Peaceful Times
**Status**: Normal operations
**Indicators**:
- No blocking issues
- All tests passing
- No security alerts
- On schedule

**Protocols**:
- Standard House operations
- Normal checkpoint frequency
- Full House Cup scoring active

---

### 🟡 YELLOW - Dark Mark Sighted
**Status**: Elevated alert
**Indicators**:
- Deadline pressure
- Minor blocking issues
- Flaky tests
- Technical debt accumulating

**Protocols**:
- Increase checkpoint frequency by 50%
- Prioritize blockers over new features
- Deputy Headmaster reviews all Year 5+ work
- Daily threat assessment

**Escalation to ORANGE if**:
- Issue unresolved for 24 hours
- Multiple Houses blocked
- Security concern identified

---

### 🟠 ORANGE - Death Eaters Mobilizing
**Status**: Critical issue active
**Indicators**:
- Critical bug in production
- Security vulnerability discovered
- Major feature blocked
- Data integrity concern

**Protocols**:
- All non-critical work paused
- Affected Houses focus solely on issue
- Checkpoints every 5 minutes
- Human notified immediately
- Rollback plan prepared

**Escalation to RED if**:
- User impact confirmed
- Data loss possible
- Security breach confirmed
- Issue spreading

---

### 🔴 RED - Battle of Hogwarts
**Status**: Emergency - All hands
**Indicators**:
- Production down
- Data at risk
- Active security breach
- User safety compromised

**Protocols**:
1. **Dumbledore's Army assembles immediately**
2. All House rivalries suspended
3. No House Points during emergency
4. Single mission focus until resolved
5. Human joins as active combatant
6. No token efficiency concerns - survival mode
7. Continuous updates to human
8. Post-incident review mandatory

**De-escalation requires**:
- Issue fully resolved
- Root cause identified
- Prevention measures in place
- Human approval to return to normal

---

## Patronus Protocol (Emergency Response)

### Activation
Any agent can activate by declaring: "PATRONUS PROTOCOL - [REASON]"

### Immediate Actions
1. All agents stop current work
2. Report to Great Hall (status update)
3. Headmaster assesses and assigns
4. Single-focus until resolved

### Patronus Team Composition
- **Shield Casters**: Agents containing the damage
- **Healers**: Agents fixing the issue
- **Scouts**: Agents identifying root cause
- **Messengers**: Agents keeping human informed

---

## Horcrux System (Technical Debt)

### What Are Horcruxes?
Technical debt items - pieces of the Dark Lord's soul embedded in the codebase. They make the system weaker and harder to maintain.

### Horcrux Categories
| Type | Danger | Examples |
|------|--------|----------|
| **Diary** | Low | Outdated comments, unused imports |
| **Ring** | Medium | Deprecated dependencies, copy-paste code |
| **Locket** | High | Untyped code, missing tests |
| **Cup** | High | Security vulnerabilities |
| **Diadem** | Critical | Architectural flaws |
| **Nagini** | Critical | Data integrity issues |

### Horcrux Hunting
- Maintain registry at `logs/horcrux-registry/active.md`
- Each Horcrux assigned a House to destroy
- Destruction earns +10 House Points
- Creating new Horcrux = -15 points + Probation

### Registry Format
```markdown
## Active Horcruxes

| ID | Type | Location | Danger | Assigned | Status |
|----|------|----------|--------|----------|--------|
| H-001 | Locket | /src/api/legacy/ | High | Ravenclaw | Hunting |
| H-002 | Ring | /styles/old/ | Medium | Gryffindor | Found |
```

---

## Incident Response Playbook

### Step 1: Assess
- What is the impact?
- Who/what is affected?
- Is it spreading?

### Step 2: Contain
- Stop the bleeding
- Prevent further damage
- Isolate affected systems

### Step 3: Communicate
- Update Marauder's Map status
- Notify human
- Brief all Houses

### Step 4: Fix
- Identify root cause
- Implement fix
- Test thoroughly

### Step 5: Verify
- Confirm fix works
- Monitor for recurrence
- Update all affected documentation

### Step 6: Learn
- Post-incident review
- Update Pensieve
- Adjust protocols if needed
- Create prevention measures

---

## Post-Battle Review Template

```markdown
## Battle Report - [Date]

### Incident Summary
- **Threat Level Reached**: [Yellow/Orange/Red]
- **Duration**: [Start] to [End]
- **Impact**: [Description]

### Response
- **Patronus Called By**: [Agent]
- **Response Time**: [Minutes]
- **Houses Involved**: [List]

### Root Cause
[Detailed explanation]

### Resolution
[What fixed it]

### Prevention
[What we'll do to prevent recurrence]

### Points Impact
- Points earned for resolution: [Number]
- Points deducted for cause: [Number]
- Net impact: [Number]

### Lessons Learned
[Key takeaways]
```
