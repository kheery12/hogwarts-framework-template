# Deploy Contract Template

Copy this template for new deployment contracts.

---

## Contract: [Service/Application] Deployment

**Version**: 1.0.0
**Author**: Hufflepuff/[Agent]
**Consumers**: All Houses
**Status**: Draft | Review | Approved | Deprecated

---

### Service Overview

**Name**: [Service name]
**Type**: [Web app/API/Worker/etc]
**Repository**: [repo URL]
**Production URL**: [URL]

---

### Environment Configuration

#### Required Environment Variables

| Variable | Description | Secret | Example |
|----------|-------------|--------|---------|
| DATABASE_URL | Database connection | Yes | postgres://... |
| API_KEY | External API key | Yes | sk-... |
| NODE_ENV | Environment name | No | production |
| LOG_LEVEL | Logging verbosity | No | info |

#### Environment Files
- `.env.example` - Template (committed)
- `.env.local` - Local dev (gitignored)
- `.env.staging` - Staging values (secure storage)
- `.env.production` - Production values (secure storage)

---

### Build Configuration

**Build Command**:
```bash
npm run build
```

**Build Output**: `dist/` or `build/`

**Build Requirements**:
- Node.js version: [X.Y.Z]
- Memory: [Minimum RAM]
- Dependencies: `npm ci`

**Build Artifacts**:
| Artifact | Path | Purpose |
|----------|------|---------|
| Application | `dist/` | Main build output |
| Static assets | `public/` | Static files |
| Source maps | `dist/*.map` | Debugging (staging only) |

---

### Runtime Requirements

**Container**:
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY dist/ ./dist/
COPY package*.json ./
RUN npm ci --production
CMD ["node", "dist/index.js"]
```

**Resources**:
| Resource | Minimum | Recommended |
|----------|---------|-------------|
| CPU | 0.5 cores | 1 core |
| Memory | 512MB | 1GB |
| Storage | 1GB | 5GB |

**Ports**:
| Port | Protocol | Purpose |
|------|----------|---------|
| 3000 | HTTP | Application |
| 9090 | HTTP | Metrics (internal) |

---

### Health Checks

**Liveness Probe**:
```
GET /health/live
Expected: 200 OK
Timeout: 5s
Interval: 10s
```

**Readiness Probe**:
```
GET /health/ready
Expected: 200 OK with {"status": "ready"}
Timeout: 5s
Interval: 5s
```

---

### Database Migrations

**Migration Command**:
```bash
npm run migrate
```

**Rollback Command**:
```bash
npm run migrate:down
```

**Pre-deploy Checklist**:
- [ ] Migration tested on staging
- [ ] Rollback tested
- [ ] Backup taken
- [ ] Downtime window communicated (if needed)

---

### Deployment Pipeline

```
[Commit] → [Lint] → [Test] → [Build] → [Deploy Staging] → [Smoke Test] → [Deploy Prod]
```

**Stages**:

| Stage | Trigger | Approval | Duration |
|-------|---------|----------|----------|
| Build | Auto on PR | None | ~5 min |
| Staging | Auto on main | None | ~10 min |
| Production | Manual | Headmaster + Human | ~15 min |

---

### Rollback Procedure

**Automatic Rollback Triggers**:
- Health check fails 3x consecutively
- Error rate > 5% for 5 minutes
- P1 alert triggered

**Manual Rollback**:
```bash
# Identify previous version
kubectl rollout history deployment/[name]

# Rollback
kubectl rollout undo deployment/[name]

# Or specific version
kubectl rollout undo deployment/[name] --to-revision=[N]
```

**Rollback Verification**:
- [ ] Service responding
- [ ] Health checks passing
- [ ] Error rate normalized
- [ ] No data corruption

---

### Monitoring & Alerting

**Dashboards**:
- [Link to main dashboard]
- [Link to error dashboard]

**Key Metrics**:
| Metric | Warning | Critical |
|--------|---------|----------|
| Error rate | > 1% | > 5% |
| Response time (p95) | > 500ms | > 2000ms |
| CPU usage | > 70% | > 90% |
| Memory usage | > 80% | > 95% |

**Alert Channels**:
- Slack: #alerts-[service]
- PagerDuty: [Policy name]

---

### Security Requirements

- [ ] HTTPS only
- [ ] Security headers configured
- [ ] Secrets in secret manager (not env files)
- [ ] Network policies in place
- [ ] Vulnerability scan passed

---

### Pre-Deployment Checklist

**Before Staging**:
- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] No critical security issues
- [ ] Documentation updated

**Before Production**:
- [ ] Staging deployed and verified
- [ ] Smoke tests passing
- [ ] Rollback plan documented
- [ ] On-call aware of deployment
- [ ] Slytherin security sign-off
- [ ] Headmaster approval
- [ ] Human confirmation

---

### Post-Deployment Verification

- [ ] Health checks passing
- [ ] Smoke tests passing
- [ ] No error rate increase
- [ ] No performance degradation
- [ ] Key user flows working
- [ ] Monitor for 15 minutes

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
