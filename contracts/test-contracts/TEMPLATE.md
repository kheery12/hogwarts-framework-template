# Test Contract Template

Copy this template for new test contracts.

---

## Contract: [Feature/Component] Testing Requirements

**Version**: 1.0.0
**Author**: Slytherin/[Agent]
**Subject**: [What is being tested]
**Status**: Draft | Review | Approved | Deprecated

---

### Coverage Requirements

| Metric | Minimum | Target | Current |
|--------|---------|--------|---------|
| Line coverage | 80% | 90% | -% |
| Branch coverage | 75% | 85% | -% |
| Function coverage | 90% | 95% | -% |

---

### Test Categories

#### Unit Tests
**Location**: `tests/unit/[feature]/`
**Runner**: [Jest/Vitest/etc]

| Test Case | Priority | Status |
|-----------|----------|--------|
| [Function] returns expected value | High | Pending |
| [Function] handles null input | High | Pending |
| [Function] throws on invalid input | Medium | Pending |

#### Integration Tests
**Location**: `tests/integration/[feature]/`
**Dependencies**: [Database, API, etc]

| Test Case | Priority | Status |
|-----------|----------|--------|
| API endpoint returns correct data | High | Pending |
| Database operations persist correctly | High | Pending |
| Service integrations work end-to-end | Medium | Pending |

#### E2E Tests
**Location**: `tests/e2e/[feature]/`
**Runner**: [Playwright/Cypress/etc]

| Test Case | Priority | Status |
|-----------|----------|--------|
| User can complete [flow] | Critical | Pending |
| Error states display correctly | High | Pending |
| Mobile viewport works | Medium | Pending |

---

### Critical Paths

These paths MUST have E2E coverage:

1. **[Critical Flow 1]**
   - Steps: [1, 2, 3]
   - Success criteria: [What success looks like]

2. **[Critical Flow 2]**
   - Steps: [1, 2, 3]
   - Success criteria: [What success looks like]

---

### Test Data Requirements

**Fixtures Needed**:
| Fixture | Location | Description |
|---------|----------|-------------|
| validUser | `fixtures/users.ts` | Standard user data |
| invalidInput | `fixtures/invalid.ts` | Edge case inputs |

**Mock Services**:
| Service | Mock Location | Notes |
|---------|--------------|-------|
| [API] | `mocks/api.ts` | Returns fixture data |
| [Database] | `mocks/db.ts` | In-memory database |

---

### Edge Cases to Test

| Category | Case | Expected Behavior |
|----------|------|-------------------|
| Empty state | No data exists | Show empty message |
| Error state | API fails | Show error, retry option |
| Boundary | Max items | Pagination works |
| Boundary | Min items | Single item works |
| Invalid | Malformed input | Validation error shown |
| Permission | Unauthorized | Redirect to login |

---

### Performance Requirements

| Metric | Threshold | Test Method |
|--------|-----------|-------------|
| Page load | < 2s | Lighthouse |
| API response | < 500ms | Load test |
| Time to interactive | < 3s | Web vitals |

---

### Security Tests

| Test | Tool | Frequency |
|------|------|-----------|
| XSS vulnerability scan | [Tool] | Every PR |
| SQL injection test | [Tool] | Every PR |
| Auth bypass attempts | Manual | Weekly |
| Dependency audit | npm audit | Daily |

---

### Test Environment

**Requirements**:
- [ ] Test database seeded
- [ ] Mock services running
- [ ] Environment variables set
- [ ] Test user accounts created

**Setup Command**:
```bash
npm run test:setup
```

**Cleanup Command**:
```bash
npm run test:cleanup
```

---

### CI/CD Integration

**Pipeline Stage**: [When tests run]
**Blocking**: [Yes/No - blocks deployment]
**Timeout**: [Maximum time]

**Required to Pass**:
- [ ] All unit tests
- [ ] All integration tests
- [ ] Critical E2E tests
- [ ] Coverage thresholds met

---

### Questions

[Other Houses can add questions here]

- Q: [Question]?
  - A: [Answer]

---

### Change Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | [Date] | [Author] | Initial contract |
