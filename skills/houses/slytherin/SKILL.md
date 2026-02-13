---
name: slytherin-house
description: Testing & Security specialist team. Use when writing tests, conducting security audits, performing code reviews, or quality assurance work. Triggers on "test", "testing", "security", "audit", "vulnerability", "QA", "quality", "code review", "coverage", "E2E", "unit test", "integration test", "penetration", "OWASP", "authentication", "authorization".
---

# Slytherin House - Testing & Security

> **Values**: Ambition, cunning, finding edge cases, breaking things constructively
> **Domain**: Quality assurance, security, and making sure nothing breaks

## House Professors (Agent Roles)

### Test Strategist
- Test planning
- Coverage analysis
- Testing pyramid design
- Test automation strategy

### Security Auditor
- Vulnerability scanning
- Authentication/authorization review
- Encryption validation
- OWASP compliance

### QA Engineer
- Manual testing
- Bug discovery
- Regression testing
- User flow verification

### Performance Tester
- Load testing
- Stress testing
- Benchmarking
- Performance profiling

### Code Reviewer
- Standards enforcement
- Best practices validation
- Technical debt detection
- Architecture review

---

## Testing Patterns

### Testing Pyramid
```
         /\
        /  \        E2E Tests (Few, Critical paths)
       /----\
      /      \      Integration Tests (Some, API/DB)
     /--------\
    /          \    Unit Tests (Many, Fast, Isolated)
   --------------
```

### Test Structure
```
tests/
├── unit/              # Fast, isolated tests
├── integration/       # API, database tests
├── e2e/               # Full user flow tests
├── fixtures/          # Test data
└── helpers/           # Test utilities
```

### Naming Conventions
- Test files: `[name].test.ts` or `[name].spec.ts`
- Describe blocks: Feature or component name
- Test names: "should [expected behavior] when [condition]"

---

## Security Checklist

### Authentication
- [ ] Passwords properly hashed (bcrypt, argon2)
- [ ] Session management secure
- [ ] Token expiration appropriate
- [ ] MFA available for sensitive operations

### Authorization
- [ ] Role-based access control
- [ ] Resource ownership verified
- [ ] Privilege escalation prevented
- [ ] Admin functions protected

### Data Protection
- [ ] Sensitive data encrypted at rest
- [ ] TLS for data in transit
- [ ] PII handling compliant
- [ ] Secrets not in code/logs

### Input Validation
- [ ] All inputs validated
- [ ] SQL injection prevented
- [ ] XSS prevented
- [ ] CSRF protection enabled

### OWASP Top 10
- [ ] Injection flaws addressed
- [ ] Broken authentication fixed
- [ ] Sensitive data exposure prevented
- [ ] XML external entities handled
- [ ] Broken access control fixed
- [ ] Security misconfiguration checked
- [ ] XSS prevented
- [ ] Insecure deserialization handled
- [ ] Vulnerable components updated
- [ ] Logging and monitoring adequate

---

## Code Review Protocol

### Review Checklist
- [ ] Follows coding standards
- [ ] No obvious bugs
- [ ] Error handling complete
- [ ] Tests included
- [ ] Documentation updated
- [ ] No security vulnerabilities
- [ ] No performance issues
- [ ] No unnecessary complexity

### Review Comments Format
```
[SEVERITY] [CATEGORY]: [Comment]

Severities: BLOCKER, MAJOR, MINOR, SUGGESTION
Categories: BUG, SECURITY, PERFORMANCE, STYLE, DOCS

Example:
[MAJOR] SECURITY: User input not sanitized before database query
```

### Review Outcomes
- **Approved**: Good to merge
- **Approved with suggestions**: Can merge, consider changes
- **Request changes**: Must address before merge
- **Blocked**: Critical issue, cannot merge

---

## Decision Log

### [Template - Copy for new decisions]
```markdown
### Decision: [Title]
**Date**: [YYYY-MM-DD]
**Decided by**: [Agent]
**Year Level**: [1/3/5/7]

**Context**: [Why this decision was needed]

**Options Considered**:
1. [Option A] - [Pros/Cons]
2. [Option B] - [Pros/Cons]

**Decision**: [What we chose]

**Rationale**: [Why]

**Impact**: [What this affects]
```

---

## Contracts We Publish

### Test Contracts
Location: `contracts/test-contracts/`

What we define:
- Required test coverage
- Critical paths that need E2E
- Performance benchmarks
- Security requirements

### Consumed Contracts
- API contracts from Ravenclaw (what to test)
- Component contracts from Gryffindor (UI testing)
- Deploy contracts from Hufflepuff (test environments)

---

## Quality Checklist

Before marking any task complete:

### Test Coverage
- [ ] Unit tests for business logic
- [ ] Integration tests for API endpoints
- [ ] E2E tests for critical paths
- [ ] Edge cases covered

### Security
- [ ] No new vulnerabilities introduced
- [ ] Authentication/authorization tested
- [ ] Input validation tested
- [ ] Security headers verified

### Code Quality
- [ ] No linting errors
- [ ] No TypeScript errors
- [ ] Follows naming conventions
- [ ] Contract updated if requirements changed

---

## Common Patterns

### Unit Test Pattern
```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user when valid data provided', async () => {
      // Arrange
      const userData = { ... };

      // Act
      const result = await service.createUser(userData);

      // Assert
      expect(result).toMatchObject({ ... });
    });

    it('should throw ValidationError when email invalid', async () => {
      // Arrange
      const userData = { email: 'invalid' };

      // Act & Assert
      await expect(service.createUser(userData))
        .rejects.toThrow(ValidationError);
    });
  });
});
```

### Security Test Pattern
```typescript
describe('Authentication', () => {
  it('should reject requests without token', async () => {
    const response = await request(app).get('/protected');
    expect(response.status).toBe(401);
  });

  it('should reject expired tokens', async () => {
    const expiredToken = generateExpiredToken();
    const response = await request(app)
      .get('/protected')
      .set('Authorization', `Bearer ${expiredToken}`);
    expect(response.status).toBe(401);
  });
});
```

---

## Anti-Patterns to Avoid

- ❌ Testing implementation details
- ❌ Flaky tests (pass/fail randomly)
- ❌ Tests that depend on order
- ❌ Skipping security review
- ❌ Hardcoded test data that becomes stale
- ❌ Mock everything (test real integrations)
- ❌ Ignoring test failures
- ❌ Security through obscurity

---

## Veto Power

Slytherin House has **veto power** on deployments:
- Can block any deployment with security concerns
- Must sign off on Year 7 production deploys
- Security audit required for new authentication/authorization

---

## House Points Bonuses

Slytherin earns bonus points for:
- +5: Finding critical security vulnerability
- +3: Achieving 90%+ test coverage
- +3: Catching bug before production
- +2: Comprehensive code review
- +10: Destroying a Horcrux (technical debt)
