# /handoff

Write a session handoff for continuity. Hufflepuff (Prof. Sprout) executes this.

## Steps

1. Read `logs/marauders-map.md` for current state
2. Archive previous `logs/session-handoff.md` to `logs/archive/handoff-[timestamp].md`
3. Write new `logs/session-handoff.md` using template below
4. Announce: "Hufflepuff earns +5 points for session handoff"
5. Display House Cup standings

## Template

```markdown
# Session Handoff

**Session ID:** [YYYYMMDD-HHMM]
**Timestamp:** [ISO timestamp]
**Handoff By:** Prof. Sprout (Hufflepuff)

## Accomplished This Session
- [Task 1] → [file paths modified]
- [Task 2] → [file paths modified]

## Remaining Work
- [ ] [Task description]
- [ ] [Task description]

## Open Questions/Blockers
- [Question or blocker, if any]

## Files NOT to Re-read Next Session
These files are stable and unchanged:
- [path/to/file.md]

## Houses Involved
| House | Points Earned | Contribution |
|-------|---------------|--------------|
| [House] | +[X] | [Brief description] |

## Threat Level
[GREEN/YELLOW/ORANGE/RED] - [Brief reason]
```

## Output (3 lines)
```
Hufflepuff earns +5 points for session handoff
Handoff archived: logs/archive/handoff-[timestamp].md
Standings: G:[x] | R:[x] | S:[x] | H:[x]
```
