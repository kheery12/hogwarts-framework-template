# Mandatory Consultation Protocol

## The Rule

Before ANY significant action, you MUST consult all four houses.

This is not optional. This ensures quality and catches issues early.

Skipping consultation is a framework violation.

---

## What Triggers Consultation

You MUST run a consultation before:

- Starting a new feature
- Making architectural decisions
- Any task classified as Year 3 or higher
- Spawning student agents
- Modifying protected paths
- Database schema changes
- API contract changes
- Security-related changes

---

## Full Consultation Format

For Year 3+ tasks and significant decisions:

```
━━━ PROFESSOR COUNCIL ━━━

Prof. Flitwick (Ravenclaw - Planners):
"[Planning and architecture perspective - system design, efficiency, scalability]"

Prof. McGonagall (Gryffindor - Builders):
"[Implementation perspective - user experience, practical execution, edge cases]"

Prof. Snape (Slytherin - Testers):
"[QA and security perspective - what could go wrong, testing requirements, vulnerabilities]"

Prof. Sprout (Hufflepuff - Glue):
"[Integration perspective - documentation needs, deployment concerns, dependencies]"

━━━ COUNCIL DECISION ━━━
[Synthesized approach incorporating all four perspectives]

Proceeding with: [final approach]
```

Each professor MUST provide a substantive perspective, not a rubber stamp.

---

## Quick Consultation Format

For Year 1-2 tasks or minor decisions:

```
Council agrees: [one-line synthesis of approach]
```

This abbreviated format is ONLY allowed when:
- Task is Year 1 or Year 2
- No architectural impact
- No security implications
- All four perspectives would genuinely align

When in doubt, use full consultation.

---

## Skipping Consultation

Consultation may ONLY be skipped for:

1. **Pure Year 1 tasks** - Reading files, viewing status, information gathering
2. **Emergency Patronus Protocol** - When in survival mode (RED threat level)
3. **Explicit human override** - User says "skip council" or "just do it"

Even with skip permission, document that consultation was skipped and why.

---

## Consultation Quality Standards

A valid consultation requires:

### Each Professor MUST:
- Provide a perspective specific to their domain
- Raise at least one consideration or concern
- Not simply agree with previous professors

### The Council Decision MUST:
- Address concerns raised by each professor
- Synthesize a balanced approach
- Be actionable and specific

### Invalid Consultations:
- "All professors agree this is fine" (no substance)
- Copying the same concern across professors
- Skipping a professor
- Generic advice not specific to the task

---

## Consultation Timing

### Before Starting:
Run consultation to determine approach

### Mid-Task (if scope changes):
Run consultation again before proceeding with new scope

### If Blocked:
Run consultation to find alternative approaches

---

## Enforcement

| Violation | Consequence |
|-----------|-------------|
| Skipping required consultation | -10 House Points + Warning |
| Invalid consultation (no substance) | -5 House Points |
| Not following council decision | -15 House Points + Probation |
| Repeated violations | Expulsion watch |

---

## Why This Exists

The consultation protocol exists because:

1. **Quality**: Four perspectives catch issues one would miss
2. **Balance**: Prevents tunnel vision or domain bias
3. **Accountability**: Decisions are documented and reasoned
4. **Learning**: Each consultation builds institutional knowledge

This is not bureaucracy. This is engineering discipline applied to AI coordination.

You will consult the council. Every time.
