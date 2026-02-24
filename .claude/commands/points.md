# /points [house] [amount] [reason]

Award or display House Points.

## Display Mode (no arguments)

Run `/points` with no arguments to show current standings.

Read `logs/house-cup/standings.md` and display:
```
━━━ HOUSE CUP STANDINGS ━━━
1. [Emoji] [House] - [Points] pts
2. [Emoji] [House] - [Points] pts
3. [Emoji] [House] - [Points] pts
4. [Emoji] [House] - [Points] pts
```

## Award Mode

Arguments: `/points [house] [amount] [reason]`

Example: `/points ravenclaw 10 "Excellent architecture design"`

### Calculation

```
Base Points = amount
Multiplier = 1.5x if all 4 houses contributed to task
Final = Base × Multiplier (round to integer)
```

### Steps

1. Validate house name and amount (positive integer)
2. Apply multipliers if applicable
3. Update `logs/house-cup/standings.md`
4. Log transaction to `logs/house-cup/history.md`
5. Announce award

## Output (3 lines)

```
[Emoji] [House] +[X] points ([reason])
Standings: G:[x] | R:[x] | S:[x] | H:[x]
[Leader] leads by [X] points
```

## House Emojis

- Gryffindor: :lion:
- Ravenclaw: :eagle:
- Slytherin: :snake:
- Hufflepuff: :badger:
