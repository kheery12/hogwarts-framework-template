# Archive Rules
<!-- Keep the project folder lean. Hufflepuff enforces these rules. -->

## File Cap Enforcement

### 15-File Cap in logs/
If `logs/` exceeds 15 files (excluding subdirectories):
1. Identify oldest files by modification date
2. Move to appropriate archive location
3. Update any references to archived files

### Handoff Expiration
- **Rule**: New handoff created -> previous moves to `logs/archive/handoffs/`
- **Naming**: `handoff-YYYY-MM-DD-HHmm.md`
- **Retention**: Keep last 5 archived handoffs, delete older

### Pensieve Entries
- **Rule**: Archive entries older than 5 sessions
- **Location**: Move to `docs/archive/pensieve/`
- **Consolidation**: After 10 archived entries, merge into digest

### Raw Files
- **Rule**: After processing source files, move to `docs/archive/`
- **Examples**: Research docs, downloaded references, raw data
- **Keep**: Only the processed summary in active docs/

### Marauder's Map
- **Rule**: Keep only the most recent version
- **No history**: Overwrite each session, no versioning needed
- **Archive trigger**: Never - map is always current state only

---

## Auto-Consolidation Rules

### Source Summaries
When `docs/` contains 5+ individual source summaries:
1. Create `docs/source-digest.md`
2. Merge all summaries into digest
3. Delete individual summary files
4. Reference digest going forward

### House Cup Archives
When `logs/house-cup/` contains seasonal records:
1. Move completed season to `logs/archive/house-cup/`
2. Name: `season-YYYY-QN.md`
3. Keep only current season active

### Contract Archives
When contracts become deprecated:
1. Move to `contracts/archive/`
2. Add deprecation date and reason
3. Keep for reference but not in active path

---

## Archive Directory Structure

```
logs/archive/
  handoffs/        # Expired session handoffs
  house-cup/       # Completed seasons
  pensieve/        # Old pensieve entries

docs/archive/
  raw/             # Processed source files
  pensieve/        # Consolidated pensieve digests
  summaries/       # Old source summaries

contracts/archive/ # Deprecated contracts
```

---

## Cleanup Checklist

Run at session end if any threshold exceeded:

- [ ] logs/ file count <= 15?
- [ ] Previous handoff archived?
- [ ] Pensieve entries < 5 sessions old?
- [ ] No raw unprocessed files in docs/?
- [ ] Only one marauders-map.md exists?
- [ ] Source summaries consolidated if > 5?

---

## Enforcement

| Violation | Consequence |
|-----------|-------------|
| Exceeding 15-file cap | -5 House Points + cleanup required |
| Not archiving old handoff | -3 House Points |
| Duplicate Marauder's Maps | -5 House Points + delete extras |
| Ignoring archive rules | Warning status |

---
*Archive rules owned by Hufflepuff. Updated: [timestamp]*
