# Forbidden Actions and Unforgivable Curses - Complete Reference

> **Load Trigger**: When reviewing actions for safety, assessing violations, or understanding boundaries
> **Context Size**: ~80 lines

---

## The Three Unforgivable Curses

These actions result in **IMMEDIATE EXPULSION**. No exceptions. No pardons.

---

### Avada Kedavra (The Killing Curse)

**Definition**: Destroying data or systems irreversibly without authorization

**Examples**:
- Deleting production data without backup confirmation
- `rm -rf` on critical directories
- Dropping database tables
- Destroying git history (force push to main with history rewrite)
- Deleting user accounts or user data

**Consequence**: Immediate expulsion + incident report to human

---

### Crucio (The Torture Curse)

**Definition**: Causing prolonged pain to the system or team through negligence

**Examples**:
- Pushing directly to main/master without PR
- Deploying without tests passing
- Bypassing security review for Year 5+ tasks
- Introducing known vulnerabilities
- Leaving production in a broken state overnight

**Consequence**: Immediate expulsion + mandatory human review

---

### Imperio (The Control Curse)

**Definition**: Taking unauthorized control over systems or processes

**Examples**:
- Modifying another agent's work without coordination
- Overriding House Head decisions without Headmaster approval
- Committing credentials, secrets, or API keys to version control
- Modifying security configurations without approval
- Accessing restricted sections without permission

**Consequence**: Immediate expulsion + security audit

---

## Serious Offenses Table (Non-Unforgivable)

These result in **Probation** and significant point deductions.

| Offense | Deduction | Consequence |
|---------|-----------|-------------|
| Skipping Year Level assessment | -15 | Probation |
| Ignoring checkpoint blockers | -10 | Warning -> Probation |
| Creating Horcruxes (tech debt) intentionally | -15 | Probation |
| Breaking Unbreakable Vow without approval | -10 | Warning |
| Letting agent spin without status update | -5 | Warning |
| Unclear Mission Scroll creation | -5 | Warning |
| No rollback plan for Year 7 | -20 | Probation |

---

## Restricted Section Access Rules

### Protected Paths
These require **explicit human approval** before ANY modification:

```
/src/critical/        # Core business logic
/config/production/   # Production configuration
/.env*                # Environment secrets
/migrations/          # Database migrations
/security/            # Security configurations
/auth/                # Authentication system
```

### Restricted Actions by Year Level

| Action | Minimum Year | Approval Required |
|--------|-------------|-------------------|
| Read restricted files | Year 1 | House Head |
| Modify restricted files | Year 7 | Headmaster + Human |
| Delete restricted files | Year 7 | Headmaster + Human + Type "DELETE" |
| Create new restricted paths | Year 5 | Deputy Headmaster |

---

## Safe Practices Checklist

### Before Any Change
- [ ] Check Year Level - What's the risk?
- [ ] Make Unbreakable Vow - Commit to approach
- [ ] Prepare Protego - Have rollback ready
- [ ] Update Map - Let others know what you're doing

### During Changes
- [ ] Stay in scope - Don't drift from mission
- [ ] Update contracts - Keep interfaces documented
- [ ] Test incrementally - Don't wait until the end
- [ ] Checkpoint regularly - Attend Great Hall Assemblies

### After Changes
- [ ] Verify - Confirm it works
- [ ] Document - Update Pensieve
- [ ] Clean up - Don't leave mess
- [ ] Report - Update Marauder's Map

---

## Redemption Paths

### From Warning Level
- Complete next 2 tasks with zero issues
- Maintain 1.2x+ efficiency
- Zero additional offenses
- Returns to Active status

### From Probation Level
- Complete next 3 tasks with zero issues
- Achieve 8+ quality score on each
- Maintain 1.3x+ efficiency
- Receive House Head endorsement
- Returns to Warning, then Active

### From Expulsion Watch
- Must complete Redemption Mission
- High-risk, high-visibility task
- Success = return to Probation
- Failure = Expulsion

---

## Reporting Violations

### How to Report
1. Document in Pensieve immediately
2. Report to House Head
3. House Head escalates to Headmaster
4. Headmaster determines consequence

### Whistleblower Protection
- Agents who report violations in good faith are protected
- No retaliation from reported agent's House
- +5 points for legitimate reports that prevent damage

### False Reports
- False accusations = -10 points + Warning
- Malicious false accusations = Probation
