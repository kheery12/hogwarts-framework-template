# Agent Interaction Protocols

## Communication Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    HEADMASTER                           │
│  (Strategic decisions, Year 5+, emergencies only)       │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────┴────────────────────────────────┐
│                  PREFECT COUNCIL                        │
│  (Inter-house coordination, contract negotiation)       │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐    │
│  │ G-Pref  │──│ R-Pref  │──│ S-Pref  │──│ H-Pref  │    │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘    │
└───────┼────────────┼────────────┼────────────┼──────────┘
        │            │            │            │
┌───────┴────────────┴────────────┴────────────┴──────────┐
│                    SHARED RESOURCES                      │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐     │
│  │  Contracts   │ │ Marauder's   │ │  Pensieve    │     │
│  │  (Notice     │ │ Map (Status) │ │  (History)   │     │
│  │   Board)     │ │              │ │              │     │
│  └──────────────┘ └──────────────┘ └──────────────┘     │
└─────────────────────────────────────────────────────────┘
        │            │            │            │
┌───────┴────┐ ┌─────┴─────┐ ┌────┴─────┐ ┌────┴─────┐
│ GRYFFINDOR │ │ RAVENCLAW │ │ SLYTHERIN│ │HUFFLEPUFF│
│ Professors │ │ Professors│ │ Professors│ │Professors│
└────────────┘ └───────────┘ └──────────┘ └──────────┘
```

---

## Contract-Based Handoffs

Instead of conversational coordination, use written contracts.

### Great Hall Notice Board Location
```
contracts/
├── api-contracts/         # Ravenclaw publishes, others consume
├── component-contracts/   # Gryffindor publishes, others consume
├── test-contracts/        # Slytherin publishes requirements
└── deploy-contracts/      # Hufflepuff publishes infrastructure needs
```

### Contract Template
```markdown
## Contract: [Name]
**Version**: [X.Y.Z]
**Author**: [House/Agent]
**Consumers**: [List of Houses/Agents]
**Status**: [Draft/Review/Approved/Deprecated]

### Specification
[Detailed specification]

### Interface
[Exact interface definition]

### Constraints
[Limitations, requirements]

### Questions
[Any open questions - consumers add here]

### Change Log
| Version | Date | Author | Changes |
|---------|------|--------|---------|
```

### Contract Workflow
1. Author House writes contract
2. Posts to Notice Board
3. Consumer Houses review
4. Questions added to contract
5. Author answers in contract
6. Once approved, work begins against contract
7. Contract changes require version bump

---

## Floo Network (Direct Channels)

For time-sensitive, low-complexity communication.

### When to Use Floo
- Clarifying a contract (quick question)
- Reporting a blocker affecting another House
- Negotiating interface in real-time
- Urgent coordination (< 100 tokens)

### When NOT to Use Floo (Route Through Headmaster)
- Escalating risk level
- Requesting additional resources
- Architectural disagreements
- Anything Year 5+

### Floo Message Format
```
---
FROM: [House]/[Agent]
TO: [House]/[Agent]
RE: [Contract or Topic]
URGENT: [Yes/No]

[Question or message - MUST be < 100 tokens]

EXPECTED RESPONSE: [What you need]
---
```

---

## Prefect Relay System

Prefects handle inter-House coordination so Professors stay focused.

### Prefect Responsibilities
- Attend Prefect Council meetings
- Summarize cross-House context for their Professors
- Negotiate contracts on behalf of House
- Escalate only unresolvable conflicts

### Prefect Council Meeting
When cross-House coordination needed:
1. Prefects meet (Headmaster optional)
2. Each presents their House's needs/concerns
3. Negotiate resolution
4. Document agreement
5. Brief their Professors

### Professor Isolation
- Professors never load cross-House context directly
- All cross-House info comes via Prefect briefing
- Keeps Professor context lean and focused

---

## Pensieve Diff Protocol

When agents need to understand another agent's work.

### Pensieve Entry Format
```markdown
## Pensieve Entry: [ID]
**Date**: [Timestamp]
**Agent**: [House/Agent]
**Task**: [Brief description]

### Summary (< 50 tokens)
[One-sentence summary]

### Changes
- Created: [files]
- Modified: [files]
- Deleted: [files]

### Decisions Made
[Key architectural/design decisions]

### Contracts Updated
[List of affected contracts]

### Open Questions
[Any unresolved items]

### Blocking
[What this blocks or is blocked by]

### Tokens Used
[Actual] / [Expected] = [Efficiency]
```

### Reading Pensieve
- Always read Pensieve entry first, not full conversation
- Only request full context if Pensieve insufficient
- Update Pensieve when making significant decisions

---

## Parallel Workstreams with Sync Points

### Class Schedule Template
```markdown
## Mission: [Name]

### PERIOD 1 (Parallel - No Sync Needed)
├── Gryffindor: [Task]
├── Ravenclaw: [Task]
├── Slytherin: [Task]
└── Hufflepuff: [Task]

### SYNC POINT 1: "[Name]"
- Purpose: [What needs alignment]
- Duration: [Estimated time]
- Required: [Which Houses]

### PERIOD 2 (Parallel - Contract-Bound)
├── Gryffindor: [Task against contracts]
├── Ravenclaw: [Task against contracts]
├── Slytherin: [Task against contracts]
└── Hufflepuff: [Task against contracts]

### SYNC POINT 2: "[Name]"
[...]
```

### Sync Point Rules
- Keep sync points minimal (< 15 min)
- Only required Houses attend
- Output: Updated contracts or decisions
- Document in Pensieve

---

## Remembrall Context Compression

### Context Tiers

**TIER 1: Always Loaded (~500 tokens)**
- Current Mission Scroll
- Agent's role and House
- Active contracts for their work

**TIER 2: Load on Demand (~2000 tokens)**
- Relevant House Skill
- Related feature skills
- Recent Pensieve entries

**TIER 3: Load Only If Stuck (~5000 tokens)**
- Full architectural context
- Historical decisions
- Cross-House Pensieve entries

**TIER 4: Never Auto-Load**
- Full codebase context
- Complete project history
- Requires human request

### Remembrall Trigger
When agent seems confused:
1. Headmaster: "Remembrall check - state your current objective"
2. If correct → Continue
3. If incorrect → Load Tier 2, re-brief
4. Still confused → Load Tier 3
5. Still confused → Apparition Protocol (replace agent)

---

## Marauder's Map (Status Dashboard)

### Map Location
`logs/marauders-map.md`

### Map Format
```markdown
## Marauder's Map
**Last Updated**: [Timestamp]
**Threat Level**: [Color]

### Active Agents
| Agent | House | Task | Status | Tokens | ETA |
|-------|-------|------|--------|--------|-----|
| [Name] | [H] | [Task] | [Status] | [Used] | [Time] |

### Blockers
| Agent | Blocked By | Waiting For |
|-------|-----------|-------------|

### Recent Completions (Last Hour)
| Agent | Task | Tokens | Points |
|-------|------|--------|--------|

### Contracts Pending Review
| Contract | Author | Reviewers Needed |
|----------|--------|-----------------|
```

### Map Update Rules
- Update at task start
- Update on status change
- Update at completion
- Headmaster reads Map instead of pinging agents

---

## Apparition Protocol (Fast Agent Replacement)

When an agent needs to be replaced mid-task.

### Triggers
- Agent stuck for 2+ checkpoints
- Context corruption detected
- Agent expelled mid-task
- Higher-priority task requires specialist

### Apparition Steps
1. **Freeze**: Current agent stops immediately
2. **Extract**: Create Pensieve entry of current state
3. **Summon**: New agent assigned
4. **Brief**: New agent reads Pensieve + active contracts
5. **Resume**: New agent continues from checkpoint

### Context Transfer Package
```markdown
## Apparition Transfer: [Task ID]

### Mission State
- Original objective: [...]
- Current status: [X% complete]
- Last checkpoint: [Timestamp]

### Work Completed
[Summary of what's done]

### Work Remaining
[What still needs to be done]

### Active Context
- Contracts: [List]
- Pensieve entries: [List]
- Open questions: [List]

### Warnings
[Any gotchas the new agent should know]
```

### Efficiency Tracking
- Apparition adds overhead (~500 tokens)
- Track apparition frequency per agent
- Frequent apparitions = agent performance issue

---

## Unbreakable Vow Protocol

Before starting Year 3+ work.

### Vow Format
```markdown
---
## Unbreakable Vow

I, [Agent Name] of [House], hereby vow:

**APPROACH**: I will [specific approach]
**DELIVERABLES**: I will produce [specific outputs]
**CONTRACTS**: I will honor [specific contracts]
**ESTIMATE**: [X] tokens / [Y] time

I understand deviating without approval results in point deduction.

**Witnessed by**: [House Head]
**Date**: [Timestamp]
---
```

### Breaking the Vow
If deviation needed:
1. STOP immediately
2. Update Map to "Vow Review"
3. Propose new approach to House Head
4. Wait for approval
5. Create new Vow

### Vow Violations
- First offense: -10 points, Warning
- Second offense: -25 points, Probation
- Third offense: Expulsion consideration
