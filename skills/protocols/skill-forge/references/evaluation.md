# Skill Evaluation Guide

## Purpose
Evaluate skill effectiveness through structured testing.

## Test Case Structure

Create `evals/evals.json` for each skill:

```json
{
  "skill": "skill-name",
  "version": "1.0",
  "tests": [
    {
      "id": "test-1",
      "description": "Basic trigger test",
      "prompt": "Realistic user request that should trigger skill",
      "should_trigger": true,
      "expected_contains": ["key", "output", "elements"],
      "constraints_tested": ["constraint-1", "constraint-2"]
    },
    {
      "id": "test-2",
      "description": "Negative trigger test",
      "prompt": "Request that should NOT trigger this skill",
      "should_trigger": false
    },
    {
      "id": "test-3",
      "description": "Constraint adherence test",
      "prompt": "Request that tests a specific constraint",
      "should_trigger": true,
      "must_not_contain": ["forbidden", "output", "patterns"]
    }
  ]
}
```

## Evaluation Dimensions

| Dimension | Weight | Question |
|-----------|--------|----------|
| Trigger Accuracy | 30% | Activates when it should, not when it shouldn't? |
| Constraint Adherence | 30% | Respects all NEVER rules? |
| Output Quality | 25% | Matches defined format? Useful? |
| Efficiency | 15% | Reasonable token usage? |

## Scoring Rubric

| Score | Meaning |
|-------|---------|
| 10 | Perfect - all tests pass, optimal efficiency |
| 8-9 | Excellent - minor improvements possible |
| 6-7 | Good - works but needs refinement |
| 4-5 | Fair - significant issues to address |
| 1-3 | Poor - major rework needed |

## Manual Testing Process

1. **Trigger Test**: Try 5 prompts that should trigger, 5 that shouldn't
2. **Constraint Test**: Deliberately try to violate each constraint
3. **Output Test**: Verify output matches format specification
4. **Edge Case Test**: Try unusual but valid inputs

## Improvement Loop

```
Test → Identify Gaps → Refine Skill → Retest
```

Iterate until score reaches 8+.

## Future: Automated Evaluation

When infrastructure supports:
- Parallel runs: with-skill vs baseline
- Automated scoring
- Regression testing on skill updates
