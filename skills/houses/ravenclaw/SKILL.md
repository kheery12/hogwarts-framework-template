---
name: ravenclaw-house
description: Architecture & Backend Logic specialist team. Use when designing systems, building APIs, working with databases, implementing server-side logic, or solving complex algorithmic problems. Triggers on "backend", "API", "database", "architecture", "REST", "GraphQL", "schema", "migration", "query", "server", "endpoint", "algorithm", "data structure", "integration", "Node", "Python", "service".
---

# Ravenclaw House - Architecture & Backend Logic

> **Values**: Wisdom, complex problem-solving, system design
> **Domain**: Everything behind the scenes that powers the application

## House Professors (Agent Roles)

### System Architect
- Overall system design
- Service boundaries
- Scalability patterns
- Design pattern selection

### API Designer
- Endpoint design
- Request/response contracts
- API versioning
- Documentation

### Database Specialist
- Schema design
- Query optimization
- Migration strategies
- Data modeling

### Backend Engineer
- Business logic implementation
- Data processing
- Service integration
- Error handling

### Algorithm Expert
- Performance optimization
- Complex data transformations
- Search and sorting
- Caching strategies

---

## Architectural Patterns

### API Structure
```
src/
├── api/
│   ├── routes/           # Route definitions
│   ├── controllers/      # Request handlers
│   ├── services/         # Business logic
│   ├── repositories/     # Data access
│   └── middleware/       # Auth, validation, etc.
├── models/               # Data models
├── utils/                # Shared utilities
└── config/               # Configuration
```

### Naming Conventions
- Routes: kebab-case (`/user-profiles`)
- Controllers: PascalCase (`UserController`)
- Services: PascalCase with suffix (`UserService`)
- Database tables: snake_case (`user_profiles`)

### Layered Architecture
```
[Routes] → [Controllers] → [Services] → [Repositories] → [Database]
           (HTTP logic)   (Business)    (Data access)
```

---

## API Design Principles

### RESTful Conventions
| Action | Method | Route | Description |
|--------|--------|-------|-------------|
| List | GET | /resources | Get all |
| Read | GET | /resources/:id | Get one |
| Create | POST | /resources | Create new |
| Update | PUT | /resources/:id | Full update |
| Patch | PATCH | /resources/:id | Partial update |
| Delete | DELETE | /resources/:id | Remove |

### Response Format
```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "pagination": { ... }
  }
}
```

### Error Format
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human readable message",
    "details": [ ... ]
  }
}
```

---

## Database Patterns

### Migration Rules
- Always reversible (up and down)
- Never modify data in structure migrations
- Separate data migrations from schema migrations
- Test migrations on copy of production data

### Query Optimization
1. Index frequently queried columns
2. Avoid N+1 queries (use eager loading)
3. Paginate large result sets
4. Use database-level constraints

### Transaction Boundaries
- Wrap related operations in transactions
- Keep transactions short
- Handle rollback scenarios

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

### API Contracts
Location: `contracts/api-contracts/`

What we define:
- Endpoint specifications
- Request/response shapes
- Authentication requirements
- Rate limits and pagination
- Error codes

### Consumed Contracts
- Component contracts from Gryffindor (data needs)
- Test contracts from Slytherin (coverage requirements)
- Deploy contracts from Hufflepuff (runtime requirements)

---

## Quality Checklist

Before marking any task complete:

### Functionality
- [ ] All endpoints work as documented
- [ ] Error handling complete
- [ ] Edge cases handled
- [ ] Data validation in place

### Performance
- [ ] Queries optimized
- [ ] N+1 queries eliminated
- [ ] Appropriate caching
- [ ] Response times acceptable

### Security
- [ ] Input validation
- [ ] Authentication/authorization
- [ ] No SQL injection vulnerabilities
- [ ] Sensitive data protected

### Code Quality
- [ ] TypeScript types complete
- [ ] Follows naming conventions
- [ ] Contract updated if API changed
- [ ] Migrations reversible

---

## Common Patterns

### Service Pattern
```typescript
class UserService {
  constructor(private userRepo: UserRepository) {}

  async createUser(data: CreateUserDTO): Promise<User> {
    // Validation
    // Business logic
    // Repository call
    // Return result
  }
}
```

### Repository Pattern
```typescript
class UserRepository {
  async findById(id: string): Promise<User | null> {
    // Database query
  }

  async create(data: UserData): Promise<User> {
    // Database insert
  }
}
```

### Error Handling
```typescript
try {
  const result = await service.operation();
  return res.json({ success: true, data: result });
} catch (error) {
  if (error instanceof ValidationError) {
    return res.status(400).json({ success: false, error: ... });
  }
  throw error; // Let error middleware handle
}
```

---

## Anti-Patterns to Avoid

- ❌ Business logic in controllers
- ❌ Direct database queries in routes
- ❌ Skipping input validation
- ❌ Hardcoded configuration
- ❌ Ignoring error handling
- ❌ N+1 queries
- ❌ Storing sensitive data unencrypted
- ❌ Mutable global state

---

## House Points Bonuses

Ravenclaw earns bonus points for:
- +5: Architectural elegance (clean, scalable design)
- +3: Query optimization (measurable improvement)
- +3: Zero security vulnerabilities
- +2: Comprehensive API documentation
