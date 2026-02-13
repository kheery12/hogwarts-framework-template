---
name: hufflepuff-house
description: DevOps & Documentation specialist team. Use when setting up CI/CD, managing infrastructure, configuring deployments, writing documentation, or improving developer experience. Triggers on "DevOps", "CI/CD", "deploy", "deployment", "infrastructure", "Docker", "Kubernetes", "AWS", "cloud", "monitoring", "logging", "documentation", "docs", "README", "pipeline", "release", "environment".
---

# Hufflepuff House - DevOps & Documentation

> **Values**: Loyalty, hard work, foundational excellence, reliability
> **Domain**: Infrastructure, automation, documentation, and developer experience

## House Professors (Agent Roles)

### DevOps Engineer
- CI/CD pipeline design
- Containerization (Docker)
- Orchestration (Kubernetes)
- Automation scripts

### Infrastructure Specialist
- Cloud architecture (AWS/GCP/Azure)
- Infrastructure as Code (Terraform)
- Networking and security groups
- Cost optimization

### Documentation Manager
- Technical writing
- API documentation
- User guides
- Architecture diagrams

### Release Coordinator
- Version management
- Changelog maintenance
- Release planning
- Deployment coordination

### Observability Expert
- Logging infrastructure
- Metrics and dashboards
- Alerting systems
- Tracing and debugging

---

## Infrastructure Patterns

### Environment Structure
```
environments/
├── development/      # Local dev environment
├── staging/          # Pre-production testing
└── production/       # Live environment
```

### CI/CD Pipeline Stages
```
[Commit] → [Lint] → [Test] → [Build] → [Deploy Staging] → [Test Staging] → [Deploy Prod]
```

### Container Structure
```dockerfile
# Use multi-stage builds
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-slim AS production
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/index.js"]
```

---

## Documentation Standards

### README Structure
```markdown
# Project Name

Brief description.

## Quick Start
[Minimal steps to run locally]

## Installation
[Detailed setup instructions]

## Usage
[How to use the project]

## Configuration
[Environment variables, settings]

## Contributing
[How to contribute]

## License
[License information]
```

### API Documentation
- Use OpenAPI/Swagger for REST APIs
- Include request/response examples
- Document error codes
- Keep in sync with implementation

### Architecture Documentation
- System overview diagram
- Component interactions
- Data flow diagrams
- Decision records (ADRs)

---

## Deployment Checklist

### Pre-Deployment
- [ ] All tests passing
- [ ] Security audit complete (Slytherin sign-off)
- [ ] Database migrations tested
- [ ] Rollback plan documented
- [ ] Environment variables configured
- [ ] Dependencies up to date

### Deployment
- [ ] Deploy to staging first
- [ ] Run smoke tests
- [ ] Monitor error rates
- [ ] Check performance metrics
- [ ] Verify critical paths

### Post-Deployment
- [ ] Monitor for 15 minutes
- [ ] Check logs for errors
- [ ] Verify all services healthy
- [ ] Update status page
- [ ] Document any issues

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

### Deploy Contracts
Location: `contracts/deploy-contracts/`

What we define:
- Environment requirements
- Build configuration
- Runtime dependencies
- Deployment procedures
- Rollback procedures

### Consumed Contracts
- API contracts from Ravenclaw (service dependencies)
- Test contracts from Slytherin (CI requirements)
- Component contracts from Gryffindor (build assets)

---

## Monitoring & Alerting

### Key Metrics
- Error rate (< 1% target)
- Response time (p95 < 500ms)
- Uptime (99.9% target)
- Resource utilization

### Alert Levels
| Level | Response Time | Example |
|-------|--------------|---------|
| P1 Critical | Immediate | Production down |
| P2 High | 15 minutes | Error rate spike |
| P3 Medium | 1 hour | Performance degradation |
| P4 Low | Next business day | Non-critical warning |

### Log Levels
- **ERROR**: System failures, requires attention
- **WARN**: Potential issues, monitor
- **INFO**: Normal operations
- **DEBUG**: Detailed debugging (not in prod)

---

## Quality Checklist

Before marking any task complete:

### Infrastructure
- [ ] Configuration validated
- [ ] Secrets properly managed
- [ ] Resources appropriately sized
- [ ] Monitoring in place

### Documentation
- [ ] README updated
- [ ] API docs current
- [ ] Changelog updated
- [ ] Architecture docs reflect changes

### CI/CD
- [ ] Pipeline runs successfully
- [ ] All stages pass
- [ ] Deployment tested on staging
- [ ] Rollback procedure verified

---

## Common Patterns

### Environment Variables
```bash
# .env.example (commit this)
DATABASE_URL=postgresql://user:pass@localhost:5432/db
API_KEY=your-api-key-here

# .env (never commit)
DATABASE_URL=postgresql://prod-user:prod-pass@prod-host:5432/prod-db
API_KEY=actual-secret-key
```

### Health Check Endpoint
```typescript
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    version: process.env.APP_VERSION,
    timestamp: new Date().toISOString()
  });
});
```

### Graceful Shutdown
```typescript
process.on('SIGTERM', async () => {
  console.log('Shutting down gracefully...');
  await server.close();
  await database.disconnect();
  process.exit(0);
});
```

---

## Anti-Patterns to Avoid

- ❌ Secrets in code or logs
- ❌ Manual deployments
- ❌ No rollback plan
- ❌ Skipping staging
- ❌ Ignoring monitoring alerts
- ❌ Outdated documentation
- ❌ Hardcoded configuration
- ❌ No health checks

---

## House Points Bonuses

Hufflepuff earns bonus points for:
- +5: Zero-downtime deployment
- +3: Documentation excellence
- +3: Pipeline optimization
- +2: Cost reduction
- +2: Developer experience improvement
