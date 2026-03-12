# Current Plan

## Active Work

*No active plan. Update this when starting multi-step work.*

---

## Instructions

**When to use:**
- Multi-step features requiring 3+ changes
- Architectural changes affecting multiple files
- Uncertain approaches needing exploration first

**How to maintain:**
1. Write plan before implementation
2. Strike through ~~completed steps~~ as you finish them
3. Remove completed sections to keep file lean
4. Clear plan when work is done

**Example format:**

```markdown
## Feature: Add user authentication

**Goal:** JWT-based auth with refresh tokens

**Approach:**
- API endpoints in /api/auth/
- Middleware for protected routes
- Frontend AuthContext provider

**Steps:**
1. ~~Create auth schema and migration~~
2. ~~Implement /login and /register endpoints~~
3. Build JWT middleware
4. Add refresh token logic
5. Wire up frontend AuthContext
6. Add login/logout UI components
7. Test flow end-to-end

**Blockers:** None
**Next:** Step 3 - JWT middleware
```

Keep this file SHORT. Archive completed plans to project docs if needed.
