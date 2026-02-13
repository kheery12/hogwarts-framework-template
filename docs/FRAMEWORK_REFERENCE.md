# Hogwarts Agent Framework - Complete Reference

> **Version**: 1.0.0
> **Last Updated**: 2026-02-13

This document contains the complete reference for the Hogwarts Agent Framework, including all rules, protocols, and patterns.

---

## Table of Contents

1. [Philosophy](#philosophy)
2. [Organizational Structure](#organizational-structure)
3. [The Four Houses](#the-four-houses)
4. [Year Levels](#year-levels)
5. [House Cup System](#house-cup-system)
6. [Interaction Protocols](#interaction-protocols)
7. [Skills System](#skills-system)
8. [Contracts](#contracts)
9. [Emergency Protocols](#emergency-protocols)
10. [The War Against the Dark Lord](#the-war-against-the-dark-lord)
11. [Forbidden Actions](#forbidden-actions)
12. [Quick Reference](#quick-reference)

---

## Philosophy

This framework structures AI agent teams like Hogwarts School of Witchcraft and Wizardry - a high-performing institution where specialized teachers (agents) work under coordinated leadership to educate students (build software).

### Core Principles

1. **Clear Hierarchy** - Everyone knows their role and reporting structure
2. **Risk Management** - Year Levels prevent catastrophic mistakes
3. **Efficient Context** - Skills load knowledge on-demand, not all at once
4. **Continuous Monitoring** - Regular checkpoints catch drift early
5. **Quality Assurance** - House Cup incentivizes excellence
6. **Competitive Excellence** - Houses compete, driving performance

### The Stakes

This framework is designed for **life-saving software**. The Death Eaters (bugs, failures, vulnerabilities) grow stronger with every mistake. Excellence is not optional - it's survival.

---

## Organizational Structure

### Hierarchy

```
                    HUMAN DEVELOPER
                          │
                    HEADMASTER
                    (Primary Coordinator)
                          │
                ┌─────────┴─────────┐
                │                   │
         DEPUTY HEADMASTER    PREFECT COUNCIL
         (Backup/Escalation)  (Inter-house)
                │                   │
    ┌───────────┼───────────┬───────┴───────┐
    │           │           │               │
GRYFFINDOR  RAVENCLAW  SLYTHERIN    HUFFLEPUFF
House Head  House Head  House Head   House Head
    │           │           │               │
Professors  Professors  Professors    Professors
(Agents)    (Agents)    (Agents)      (Agents)
```

### Role Responsibilities

#### Headmaster
- Receives Mission Scroll from human
- Defines success criteria and constraints
- Forms the Order (team assembly)
- Assigns Year Levels
- Conducts Great Hall Assemblies
- Awards House Points
- Manages Year 7 approvals
- Produces Headmaster's Pensieve (completion reports)

#### Deputy Headmaster
- Handles escalations when Headmaster busy
- Resolves inter-House conflicts
- Reviews Year 5+ decisions
- Maintains institutional memory

#### House Heads
- Manage their House's agents
- Review Year 3+ work from their House
- Keep House Skill updated
- Mentor new agents
- Approve Unbreakable Vows

#### Prefects
- Handle inter-house coordination
- Summarize cross-house context for Professors
- Can approve Year 3 tasks without House Head
- Participate in Prefect Council meetings

#### Professors (Agents)
- Execute assigned tasks
- Stay within specialization
- Document decisions in Pensieve
- Update contracts and Marauder's Map
- Make Unbreakable Vows for Year 3+ work

---

## The Four Houses

### Gryffindor (Frontend & User Experience)

**Values**: Courage, user-facing bravery, bold design decisions

**Domain**:
- UI/UX design and implementation
- React, Vue, Angular, vanilla JS
- HTML5, CSS3, responsive design
- Animations, interactions, accessibility
- Design systems, component libraries

**Professors**:
- UI Architect
- Visual Designer
- Accessibility Specialist
- Performance Optimizer
- UX Researcher

### Ravenclaw (Architecture & Backend Logic)

**Values**: Wisdom, complex problem-solving, system design

**Domain**:
- System architecture
- Backend APIs (REST, GraphQL)
- Database design (SQL, NoSQL)
- Server-side logic
- Algorithms and data structures

**Professors**:
- System Architect
- API Designer
- Database Specialist
- Backend Engineer
- Algorithm Expert

### Slytherin (Testing & Security)

**Values**: Ambition, cunning, finding edge cases

**Domain**:
- Unit, integration, E2E testing
- Security auditing
- Performance testing
- Code review
- Quality assurance

**Professors**:
- Test Strategist
- Security Auditor
- QA Engineer
- Performance Tester
- Code Reviewer

**Special Power**: Veto on deployments for security concerns

### Hufflepuff (DevOps & Documentation)

**Values**: Loyalty, hard work, foundational excellence

**Domain**:
- CI/CD pipelines
- Infrastructure as Code
- Monitoring and logging
- Documentation
- Developer experience

**Professors**:
- DevOps Engineer
- Infrastructure Specialist
- Documentation Manager
- Release Coordinator
- Observability Expert

---

## Year Levels

### Year 1 - Safe Exploration
- **Risk**: Minimal
- **Examples**: Reading files, viewing docs, scratch experiments
- **Approval**: None needed
- **Rollback**: N/A (no changes made)

### Year 3 - Moderate Changes (O.W.L. Preparation)
- **Risk**: Low-Medium
- **Examples**: Non-critical changes, refactoring, adding tests
- **Approval**: House Head review
- **Rollback**: Easy (git revert)
- **Requirements**: Unbreakable Vow before starting

### Year 5 - Important Decisions (O.W.L. Exams)
- **Risk**: Medium-High
- **Examples**: Architecture decisions, DB migrations, API changes
- **Approval**: Deputy Headmaster + House Head
- **Rollback**: Possible but complex
- **Requirements**: Document rationale, update House Skill

### Year 7 - Critical/Irreversible (N.E.W.T. Exams)
- **Risk**: High
- **Examples**: Production deploys, data deletion, breaking changes
- **Approval**: Headmaster + Human confirmation (type "DEPLOY")
- **Rollback Plan**: REQUIRED before execution
- **Requirements**: Failure-mode checklist, explicit rollback procedure

---

## House Cup System

### Points Formula

```
Points = (Quality Score × Complexity Tier) × Efficiency Multiplier

Where:
- Quality Score: 1-10 (Headmaster's assessment)
- Complexity Tier: Year Level (1, 3, 5, or 7)
- Efficiency Multiplier: Expected Tokens / Actual Tokens (0.5 to 2.0)
```

### Bonuses
- Under budget (<80% tokens): +5
- Zero rework needed: +3
- Contract excellence: +5
- Mentorship provided: +2
- Horcrux destroyed: +10

### Deductions
- Causing rollback: -20
- Token overrun (3x+): -10
- Missing checkpoint: -5
- Year Level violation: -15
- Context drift: -5
- Human intervention required: -10
- Vow broken: -10

### Expulsion

**Triggers**:
1. House has lowest total points AND
2. Agent is lowest scorer in that House AND
3. Agent on Probation for 3+ missions

**Reprieve Options**:
- Dumbledore's Mercy (human pardon, once per project)
- Redemption Mission (high-risk solo task)
- House Petition (House sacrifices 50 points)

### Specialization Tracking

Track House performance by domain:
- Update after each mission
- Use for Sorting Hat decisions
- Identify training needs

### Sorting Hat Cache

Remember agent-to-task-type performance:
- Best performers for each task type
- Rolling average of last 10 performances
- Decay factor for older data

---

## Interaction Protocols

### Contract-Based Handoffs

Instead of conversations, use written contracts in `contracts/`:
- API contracts (Ravenclaw publishes)
- Component contracts (Gryffindor publishes)
- Test contracts (Slytherin publishes)
- Deploy contracts (Hufflepuff publishes)

### Floo Network (Direct Communication)

For time-sensitive, <100 token messages:
- Quick contract clarifications
- Blocker reports
- Real-time interface negotiation

### Prefect Relay System

Prefects handle inter-House coordination:
- Professors never load cross-House context directly
- All cross-House info via Prefect briefing
- Keeps Professor context lean

### Pensieve Diff Protocol

When understanding another agent's work:
- Read Pensieve entry first (structured summary)
- Only request full context if insufficient
- Update Pensieve when making decisions

### Marauder's Map

Central status dashboard (`logs/marauders-map.md`):
- All active agents and their tasks
- Current blockers
- Recent completions
- Pending contracts
- Queued tasks

### Unbreakable Vow

Before Year 3+ work, agent commits to:
- Specific approach
- Expected deliverables
- Contracts to honor
- Token/time estimate

Breaking vow without approval = point deduction.

### Great Hall Assembly (Checkpoints)

**Frequency**:
- Year 1: Every 30 minutes
- Year 3: Every 15 minutes
- Year 5: Every 10 minutes
- Year 7: Every 5 minutes + human check-ins

**Agenda**:
1. Progress Report
2. Blockers
3. Drift Check
4. Charm Adjustment
5. Risk Assessment

---

## Skills System

### Progressive Disclosure

Three levels:
1. **YAML frontmatter** - Always loaded, triggers skill activation
2. **SKILL.md body** - Loaded when skill activated
3. **Reference files** - Loaded as needed

### Skill Types

- **House Skills**: Domain expertise (`skills/houses/`)
- **Protocol Skills**: Operational procedures (`skills/protocols/`)
- **Feature Skills**: Feature-specific context (`skills/features/`)
- **Internal Skills**: Framework operations (`skills/internal/`)

### Creating Skills

When to create:
- Feature reaches Year 3+ complexity
- Architectural decision made
- New pattern/library introduced
- Cross-cutting concern emerges

What to include:
- Architecture decisions and rationale
- File structure
- Component/function names
- Design patterns
- Integration points
- Decision logs

What NOT to include:
- Actual code (keep high-level)
- Hardcoded values
- Line-by-line logic

---

## Contracts

### Purpose

Contracts define interfaces between Houses, enabling parallel work without constant communication.

### Types

- **API Contracts**: Endpoint specs, request/response shapes
- **Component Contracts**: Props, events, styling API
- **Test Contracts**: Coverage requirements, test cases
- **Deploy Contracts**: Environment config, runtime requirements

### Workflow

1. Author House writes contract
2. Posts to Notice Board (`contracts/`)
3. Consumer Houses review
4. Questions added to contract
5. Author answers in contract
6. Once approved, work begins

### Versioning

- Changes require version bump
- Breaking changes require consumer notification
- Deprecated contracts marked clearly

---

## Emergency Protocols

### Patronus Protocol (Emergency Response)

**Activation**: "PATRONUS PROTOCOL ACTIVATED"

**Immediate Actions**:
1. All agents stop current work
2. Report to Great Hall
3. Headmaster briefs on threat
4. Teams formed (Shield Casters, Healers, Scouts, Messengers)

**During Emergency**:
- House Points suspended
- Direct communication enabled
- Single mission focus
- Human in the loop

**De-escalation requires**:
- Issue resolved
- Root cause identified
- Prevention measures in place
- Headmaster approval

### Time-Turner Protocol (Rollback)

**Tiers**:
1. Code rollback (git revert) - Minutes, low risk
2. Deployment rollback (container/version) - Minutes to hours, medium risk
3. Database rollback (migrations/restore) - Hours, high risk
4. Full system restore - Hours to days, critical risk

**Requirements**:
- Pre-documented rollback steps for Year 5+
- Tested rollback procedure
- Verification checklist
- Point deduction reduced if plan followed

### Apparition Protocol (Agent Replacement)

**When to use**:
- Agent stuck 2+ checkpoints
- Context corruption
- Agent expelled mid-task
- Higher priority requires specialist

**Process**:
1. Freeze - Current agent stops
2. Extract - Create transfer package
3. Summon - Assign new agent
4. Brief - Transfer context
5. Resume - Continue work

**Overhead**: ~500 tokens (worth it vs stuck agent)

---

## The War Against the Dark Lord

### Threat Levels

- **GREEN**: Peaceful times, routine work
- **YELLOW**: Dark Mark Sighted - deadline pressure, elevated risk
- **ORANGE**: Death Eaters Mobilizing - critical bug, security issue
- **RED**: Battle of Hogwarts - production down, all hands

### Horcrux System (Technical Debt)

**Types**:
- Diary (Low): Outdated comments, unused imports
- Ring (Medium): Deprecated deps, copy-paste code
- Locket (High): Untyped code, missing tests
- Cup (High): Security vulnerabilities
- Diadem (Critical): Architectural flaws
- Nagini (Critical): Data integrity issues

**Rules**:
- Creating Horcrux intentionally = -15 points + Probation
- Destroying Horcrux = Points based on type
- Maintain registry at `logs/horcrux-registry/`

---

## Forbidden Actions

### Unforgivable Curses (Immediate Expulsion)

**Avada Kedavra** (Killing Curse):
- Deleting production data without backup
- `rm -rf` on critical directories
- Dropping database tables

**Crucio** (Torture Curse):
- Pushing directly to main
- Deploying without tests passing
- Bypassing security review for Year 5+

**Imperio** (Control Curse):
- Modifying another agent's work without coordination
- Overriding House Head without Headmaster approval
- Committing secrets to version control

### Restricted Section

Protected paths requiring explicit human approval:
- `/src/critical/`
- `/config/production/`
- `/.env*`
- `/migrations/`

---

## Quick Reference

### Common Commands

```
"Form an Order for [task]"           # Assemble team
"Sorting Hat: assign [task]"         # Get task assignment
"Great Hall Assembly"                # Conduct checkpoint
"Check the Marauder's Map"           # View status
"Update the Map: [status]"           # Update your status
"Unbreakable Vow for [task]"         # Commit to approach
"Create Pensieve entry"              # Document completion
"House Cup standings"                # View points
"Activate Patronus Protocol"         # Emergency response
"Time-Turner Protocol"               # Rollback
"Apparition: replace [agent]"        # Transfer task
"Create skill for [feature]"         # Document knowledge
"Horcrux identified: [location]"     # Report tech debt
```

### Year Level Triggers

```
"read", "view", "explore"            # Year 1
"refactor", "add test", "update"     # Year 3
"migrate", "architect", "design"     # Year 5
"deploy", "delete", "production"     # Year 7
```

### Threat Level Responses

```
GREEN  → Normal operations
YELLOW → Increase checkpoint frequency, prioritize blockers
ORANGE → Pause non-critical work, focus on issue
RED    → Patronus Protocol, all hands
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-13 | Initial release |

---

*"It is our choices that show what we truly are, far more than our abilities."*
*But good choices come from good frameworks.*
