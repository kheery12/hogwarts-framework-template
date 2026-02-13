# Horcrux Registry - Active

> Technical debt that must be destroyed.

**Last Updated**: [Timestamp]
**Total Active Horcruxes**: 0

---

## Active Horcruxes

| ID | Type | Location | Danger | Description | Assigned | Status | Created |
|----|------|----------|--------|-------------|----------|--------|---------|
| - | - | - | - | No active Horcruxes | - | - | - |

---

## Horcrux Types

| Type | Danger Level | Description | Points for Destruction |
|------|--------------|-------------|----------------------|
| Diary | Low | Minor issues (outdated comments, unused imports) | +5 |
| Ring | Medium | Moderate debt (deprecated deps, copy-paste code) | +7 |
| Locket | High | Significant issues (untyped code, missing tests) | +10 |
| Cup | High | Security concerns | +12 |
| Diadem | Critical | Architectural flaws | +15 |
| Nagini | Critical | Data integrity issues | +20 |

---

## Recently Destroyed

| ID | Type | Location | Destroyed By | House | Points | Date |
|----|------|----------|--------------|-------|--------|------|
| - | - | - | - | - | - | - |

---

## Horcrux Hunting Queue

Priority order for destruction:

1. **Critical (Nagini, Diadem)**: Destroy immediately
2. **High (Cup, Locket)**: Destroy within 1 sprint
3. **Medium (Ring)**: Destroy within 1 month
4. **Low (Diary)**: Destroy when convenient

---

## Creating a Horcrux Entry

When technical debt is identified:

```markdown
## Horcrux: [ID]

**Type**: [Diary/Ring/Locket/Cup/Diadem/Nagini]
**Location**: [file/directory path]
**Danger**: [Low/Medium/High/Critical]

### Description
[What the issue is]

### Impact
[Why this is a problem]

### Proposed Fix
[High-level approach to destroy]

### Estimated Effort
[Tokens/time estimate]

### Dependencies
[What else needs to happen first]

### Assigned To
[House or specific agent]

### Status
[Identified/Assigned/Hunting/Destroyed]
```

---

## Rules

### Creating Horcruxes
- **-15 points** to agent who creates technical debt intentionally
- **Probation** if pattern continues
- Accidental Horcruxes: No penalty if reported immediately

### Destroying Horcruxes
- Points awarded per type table above
- **+5 bonus** if destroyed ahead of schedule
- **+3 bonus** if no regressions introduced

### Horcrux Amnesty
Once per project, Headmaster may declare "Horcrux Amnesty" where existing debt can be catalogued without penalty. New debt after amnesty follows normal rules.
