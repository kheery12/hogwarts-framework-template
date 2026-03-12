# Claude Framework v4

Production-grade Claude Code framework. Lean, efficient, professional.

## Structure

```
CLAUDE.md                 # Core rules (30 lines)
docs/
  ├── references.md       # Quick shortcuts & patterns
  ├── context.md          # Session state
  └── skillsreference.md  # Skill registry
.claude/
  └── skills/            # 9 pre-installed Anthropic skills
      ├── claude-api/
      ├── frontend-design/
      ├── mcp-builder/
      ├── webapp-testing/
      ├── pptx/
      ├── docx/
      ├── xlsx/
      ├── pdf/
      └── skill-creator/
```

## Philosophy

v4 removes all Hogwarts theming from v3. No houses, professors, students, or points.

**Core principles:**
- Context is expensive — manage it aggressively
- Verification is mandatory — tests, screenshots, proof
- Skills load on-demand — progressive disclosure
- Subagents coordinate via CLAUDE.md only
- Quality standards are non-negotiable

## Usage

1. **Copy CLAUDE.md to your project root**
2. **Copy .claude/ directory** (or just the skills you need)
3. **Copy docs/** for reference structure
4. **Customize references.md** with your project's shortcuts
5. **Update context.md** at session start/end

## Pre-installed Skills

| Skill | Use for |
|-------|---------|
| `claude-api` | API integration, tool use, structured outputs |
| `frontend-design` | UI/UX, CSS, distinctive web design |
| `mcp-builder` | Build MCP servers and tools |
| `webapp-testing` | Selenium, Playwright, test automation |
| `pptx` | PowerPoint generation and editing |
| `docx` | Word document creation |
| `xlsx` | Excel spreadsheet manipulation |
| `pdf` | PDF generation |
| `skill-creator` | Create new custom skills |

Invoke with `/skill-name` or let Claude auto-detect when relevant.

## A/B Testing v3 vs v4

See `tests/scenarios/` for test cases comparing framework versions.

**v3**: Hogwarts-themed, house system, point tracking
**v4**: Lean, professional, skill-based

Compare on:
- Token efficiency
- Task completion rate
- Number of corrections needed
- User cognitive load

## Version History

- **v3.1.0** — Hogwarts Framework with houses, skills, remote control
- **v4.0.0** — Complete rewrite: removed theming, lean structure, professional tone

## License

MIT
