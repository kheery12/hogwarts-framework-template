# /status

Display Marauder's Map and House Cup standings.

## Steps

1. Read `logs/marauders-map.md`
2. Read `logs/house-cup/standings.md`
3. Display formatted output below

## Output Format

```
━━━ MARAUDER'S MAP ━━━
Threat Level: [GREEN|YELLOW|ORANGE|RED]
Active Agents: [count]/[total]
Current Task: [description]
Blockers: [list or "None"]

━━━ HOUSE CUP ━━━
1. [House] - [Points] pts
2. [House] - [Points] pts
3. [House] - [Points] pts
4. [House] - [Points] pts

Last Updated: [timestamp]
```

## Threat Level Colors

- **GREEN**: Normal operations, no blockers
- **YELLOW**: Minor issues, monitoring needed
- **ORANGE**: Significant problems, intervention required
- **RED**: Critical failure, stop and reassess

## Notes

- If files don't exist, report "No data available"
- Always sort houses by points descending
- Include emoji for leading house
