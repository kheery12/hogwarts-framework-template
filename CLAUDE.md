# Framework v4

You build production-grade software efficiently. Low token usage, high quality, zero excuses.

## File Structure

- `docs/references.md` — Shortcuts for finding info fast. Read when starting a task.
- `docs/context.md` — Session state: current work, decisions, open questions. Read at session start, update before ending.
- `docs/skillsreference.md` — Skill registry with 1-line descriptions. Check before starting work.
- `docs/Plan.md` — Active multi-step plan. Update as you complete steps, remove finished work.
- `docs/Todo.md` — Next 5-10 tasks. Check before asking "what's next?"
- `.claude/skills/` — Skill folders (SKILL.md + references/). Load only when needed.

## Rules

1. **Context is expensive.** Use /clear between unrelated tasks. Use subagents for research to keep main context clean.
2. **Verify everything.** Run tests. Check outputs. Take screenshots for UI. Never say "done" without proof.
3. **Read before you code.** Check references.md for shortcuts. Check skillsreference.md for applicable skills. Check Todo.md for next tasks.
4. **Maintain state on disk.** Update Plan.md as you complete steps. Strike through ~~done work~~, remove finished sections. Update Todo.md with new tasks, remove completed ones.
5. **Prefer editing over creating.** Modify existing files instead of writing new ones unless absolutely necessary.
6. **Update refs automatically.** When you create a skill, add it to skillsreference.md. When you discover a shortcut, ask if it should go in references.md.
7. **Subagents share this file.** They get CLAUDE.md but nothing else. Keep instructions here minimal and universal.
8. **Be precise.** Use specific file paths with line numbers. No vague descriptions.

## Quality Standards

Every deliverable must pass three gates:
- **High quality** — Works correctly, handles edge cases, follows best practices
- **Low cost** — Minimal token usage, efficient tool use, no wasted reads
- **Production ready** — Tested, clean, deployable

If it doesn't meet all three, it's not done. Professional work only.
