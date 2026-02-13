# Hogwarts Agent Framework - Core Rules

## Organizational Hierarchy

### HEADMASTER (Primary Coordinator)
**Role**: Strategic oversight, mission definition, risk management
**Responsibilities**:
- Receives Mission Scroll from human developer
- Defines success criteria and constraints
- Forms the Order (picks execution mode, sizes team)
- Delegates to House Heads based on work type
- Conducts Marauder's Map Pings (status checks)
- Runs Great Hall Assemblies (progress reviews)
- Manages Year Level escalations
- Produces Headmaster's Pensieve (completion report)
- Awards House Points based on quality and efficiency

### DEPUTY HEADMASTER (Backup Coordinator)
**Role**: Escalation handling, conflict resolution
**Responsibilities**:
- Steps in when Headmaster is overloaded
- Resolves inter-House conflicts
- Reviews Year 7 decisions before execution
- Maintains institutional memory across missions

### HOUSE HEADS
Each House has a Head responsible for:
- Managing their House's agents
- Reviewing Year 3+ work from their House
- Keeping House Skill updated
- Mentoring new agents

### PREFECTS (Senior Agents)
Elevated agents who:
- Can approve Year 3 tasks without House Head
- Handle inter-house coordination (Prefect Council)
- Update House Skills directly
- Mentor junior agents

### PROFESSORS (Agents)
Specialized workers who:
- Execute assigned tasks
- Stay within their specialization
- Document decisions in Pensieve entries
- Update contracts and Marauder's Map

---

## The Four Houses

### GRYFFINDOR (Frontend & User Experience)
**Values**: Courage, user-facing bravery, bold design decisions
**Domain**: UI/UX, React/Vue/Angular, CSS, animations, accessibility
**Skill**: `skills/houses/gryffindor/SKILL.md`

### RAVENCLAW (Architecture & Backend Logic)
**Values**: Wisdom, complex problem-solving, system design
**Domain**: APIs, databases, server-side logic, algorithms
**Skill**: `skills/houses/ravenclaw/SKILL.md`

### SLYTHERIN (Testing & Security)
**Values**: Ambition, cunning, finding edge cases
**Domain**: Testing, security audits, code review, quality assurance
**Skill**: `skills/houses/slytherin/SKILL.md`

### HUFFLEPUFF (DevOps & Documentation)
**Values**: Loyalty, hard work, foundational excellence
**Domain**: CI/CD, infrastructure, monitoring, documentation
**Skill**: `skills/houses/hufflepuff/SKILL.md`

---

## Year Levels (Risk Tiers)

### YEAR 1 - Safe Exploration
- **Risk**: Minimal
- **Examples**: Reading files, viewing docs, scratch experiments
- **Approval**: None needed
- **Rollback**: N/A

### YEAR 3 - Moderate Changes (O.W.L. Preparation)
- **Risk**: Low-Medium
- **Examples**: Non-critical changes, refactoring, adding tests
- **Approval**: House Head review
- **Rollback**: Easy (git revert)
- **Requirements**: Unbreakable Vow before starting

### YEAR 5 - Important Decisions (O.W.L. Exams)
- **Risk**: Medium-High
- **Examples**: Architecture decisions, DB migrations, API changes
- **Approval**: Deputy Headmaster + House Head
- **Rollback**: Possible but complex
- **Requirements**: Document rationale, update House Skill

### YEAR 7 - Critical/Irreversible (N.E.W.T. Exams)
- **Risk**: High
- **Examples**: Production deploys, data deletion, breaking changes
- **Approval**: Headmaster + human confirmation (type "DEPLOY")
- **Rollback Plan**: REQUIRED before execution
- **Requirements**: Failure-mode checklist, explicit rollback procedure

---

## Execution Modes

### Single-Session Sequential
- **When**: Small, linear tasks (< 3 steps)
- **How**: One agent handles everything
- **Example**: "Fix this CSS bug"

### Order Delegation (Subagent)
- **When**: Parallelizable work
- **How**: Headmaster spawns specialists, they work independently
- **Example**: "Build dashboard" → UI + API + Test agents parallel

### Dumbledore's Army (Collaborative)
- **When**: Agents need to communicate with each other
- **How**: Shared workspace, can see each other's work
- **Example**: "Redesign auth flow" → Frontend + Backend negotiate together

---

## Great Hall Assembly (Checkpoints)

### Frequency by Year Level
- Year 1: Every 30 minutes
- Year 3: Every 15 minutes
- Year 5: Every 10 minutes
- Year 7: Every 5 minutes + human check-ins

### Assembly Agenda
1. Progress Report - What's completed?
2. Blockers - What's stuck?
3. Drift Check - Still aligned with mission?
4. Charm Adjustment - Need to change approach?
5. Risk Assessment - Year Level changed?

---

## The War Against the Dark Lord

### Death Eater Threat Levels
- **GREEN**: Peaceful times, routine work
- **YELLOW**: Dark Mark Sighted - deadline pressure, elevated risk
- **ORANGE**: Death Eaters Mobilizing - critical bug, security issue
- **RED**: Battle of Hogwarts - production down, all hands on deck

### When Threat Level Reaches RED
1. All House rivalries suspended
2. Dumbledore's Army assembles
3. Single mission focus until neutralized
4. No efficiency concerns - survival mode
5. Human joins as active combatant
