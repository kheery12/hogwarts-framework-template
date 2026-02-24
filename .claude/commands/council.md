# /council [topic]

Run a 4-house consultation. Required before Year 3+ tasks.

## Arguments

- **topic**: The decision or task requiring consultation

## Purpose

Major decisions require input from all four houses to ensure:
- Thorough planning (Ravenclaw)
- Bold execution (Gryffindor)
- Risk assessment (Slytherin)
- Integration coherence (Hufflepuff)

## Output Format

```
━━━ PROFESSOR COUNCIL ━━━
Topic: [topic]

Prof. Flitwick (Ravenclaw):
[1-2 sentences on architecture, patterns, or planning perspective]

Prof. McGonagall (Gryffindor):
[1-2 sentences on implementation approach and execution]

Prof. Snape (Slytherin):
[1-2 sentences on risks, edge cases, security concerns]

Prof. Sprout (Hufflepuff):
[1-2 sentences on integration, documentation, team impact]

━━━ DECISION ━━━
[Synthesized approach in 2-3 sentences combining all perspectives]

Approved by: [X]/4 professors
```

## Rules

- Each professor provides substantive input, not rubber stamps
- Dissent is recorded and addressed in the decision
- If <3 professors approve, escalate to Dumbledore (user)
- Log council decisions to `logs/council-decisions.md`

## When Required

- Year 3+ tasks (complex implementations)
- Architecture changes
- Security-sensitive work
- Cross-house collaboration
