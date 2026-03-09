---
name: remote
description: Switch to remote control mode for mobile/web continuation. Use when user says "go remote", "switch to mobile", or needs to continue from another device.
---

# Remote Control Switch

Activate when user says: "go remote", "switch to mobile", "remote control", or "continue on phone"

## Quick Start

For instant switch:
```
/remote "Session Name"
```

## Full Process

1. **Confirm session name**
   - Default: `[Project Name] - [Current Task]`
   - Ask user if they want custom name

2. **Start remote session**
   ```bash
   claude remote-control "$SESSION_NAME"
   ```

3. **Display access options**
   - Press spacebar to show QR code for mobile
   - Direct URL: claude.ai/code
   - Session appears in list with green dot when online

4. **Confirm ready**
   ```
   Remote session active: "$SESSION_NAME"

   Access options:
   - Scan QR code with Claude mobile app
   - Visit claude.ai/code and find session in list
   - Session has green status dot when connected

   Your local environment stays available remotely.
   ```

## Notes
- Terminal must stay open for session to persist
- Network drops auto-reconnect when back online
- One remote session per Claude Code instance
