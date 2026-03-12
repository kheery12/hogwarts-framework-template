# A/B Test Scenarios

Test identical tasks on both v3 and v4 to measure performance.

## Test Protocol

For each scenario:
1. Run task with v3 framework (use v3.1.0-stable tag)
2. Run identical task with v4 framework (use v4-development branch)
3. Record metrics in `results/` directory
4. Document observations

## Metrics to Track

| Metric | v3 | v4 | Notes |
|--------|----|----|-------|
| Total tokens used | | | From /context or statusline |
| Number of corrections | | | How many times user had to redirect |
| Task completion | ✅/❌ | ✅/❌ | Did it work? |
| Time to completion | | | Optional - not required |
| User cognitive load | Low/Med/High | Low/Med/High | How hard to understand/manage |

## Scenario Template

Create files named `01-task-name.md`, `02-another-task.md`, etc.

```markdown
# Scenario: [Name]

## Task Description
[Exact prompt to give Claude]

## Expected Outcome
[What success looks like]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## v3 Results
- Tokens:
- Corrections:
- Status: ✅/❌
- Notes:

## v4 Results
- Tokens:
- Corrections:
- Status: ✅/❌
- Notes:

## Winner
[v3 or v4, and why]
```

## Sample Scenarios

1. **Simple feature**: "Add a login button to the navbar"
2. **Refactor task**: "Refactor auth module to use hooks instead of HOCs"
3. **Debug scenario**: "Fix the bug where logout doesn't clear session storage"
4. **Multi-file change**: "Add TypeScript support to the project"
5. **API integration**: "Integrate Stripe checkout"
6. **Documentation**: "Write API documentation for all endpoints"
7. **Testing**: "Add unit tests for the user service"
8. **Performance**: "Optimize the database queries in the dashboard"

Run at least 5-8 scenarios before making v4 official.
