# Source: Compound Engineering Plugin
# URL: https://github.com/EveryInc/compound-engineering-plugin
# Ingested: 2026-07-01
# Files: README.md + June 26 2026 update (from @trevin on X)

---

## README

# Compound Engineering

AI skills that make each unit of engineering work easier than the last.

**Stars:** 22,410 (2026-07-01)
**Author:** Every Inc (@trevin = Trevin Chow, CTO of Every)

### Philosophy

**Each unit of engineering work should make subsequent units easier -- not harder.**

Traditional development accumulates technical debt. Compound engineering inverts this. 80% is in planning and review, 20% is in execution:

- Plan thoroughly before writing code with `/ce-brainstorm` and `/ce-plan` using one readiness-based plan artifact
- Review to catch issues and calibrate judgment with `/ce-code-review` and `/ce-doc-review`
- Codify knowledge so it is reusable with `/ce-compound`

The point is not ceremony. The point is leverage. A good brainstorm makes the plan sharper. A good plan makes execution smaller. A good review catches the pattern, not just the bug. A good compound note means the next agent does not have to learn the same lesson from scratch.

### Workflow

The core loop is six steps: **brainstorm** → **plan** → **work** → **simplify** → **review** → **compound** — repeat with better context.

| Skill | Purpose |
|-------|---------|
| `/ce-brainstorm` | Interactive Q&A to think through a feature and write a requirements-only unified plan |
| `/ce-plan` | Enrich requirements-only plans into implementation-ready plans |
| `/ce-work` | Execute implementation-ready plans with worktrees and task tracking |
| `/ce-simplify-code` | Refine freshly written code for clarity and reuse before review |
| `/ce-code-review` | Multi-agent review against the plan before merging |
| `/ce-compound` | Capture the learning into `docs/solutions/` so the next loop starts smarter |

Each cycle compounds: `/ce-compound` writes learnings that the next `/ce-brainstorm` and `/ce-plan` read as grounding.

### Additional skills

| Skill | When to reach for it |
|-------|---------|
| `/ce-ideate` | Before the loop, when you don't know what to build |
| `/ce-strategy` | Upstream anchor — creates and maintains `STRATEGY.md` |
| `/ce-product-pulse` | Outer loop — time-windowed report on user experience |
| `/ce-debug` | Instead of brainstorm→plan→work when input is a bug |
| `/ce-pov` | Decisive verdict on whether to adopt an external technology |
| `/lfg` | Full autonomous engineering workflow (plan→work→review→PR→CI) |

### Architecture

- 27 skills total, 0 standalone agents
- Skills are self-contained: specialist reviewer, research, and workflow behavior lives inside the owning skills as skill-local prompt assets
- Plugin format: installable via Claude Code marketplace, Cursor, Codex App, Codex CLI

---

## June 26, 2026 Update (@trevin)

### We killed our own agents (on purpose)

Previously, Compound Engineering relied on dedicated standalone agent definitions. Those worked great in Claude Code. They worked less fine — or didn't work — across Codex, Cursor, Gemini, Pi, and OpenCode, because formal agent definitions aren't a reliable common denominator across harnesses.

**Change:** Every skill is now self-contained. Specialist "agent" behavior lives in skill-local prompt assets vs formal agent definitions.

**Practical effects:**
- Codex CLI and Codex desktop app — works cleanly now, including as full plugin with auto-updates
- OpenCode, Pi and Cursor — much better native support
- Plugin being skills-only means it can slot into plugin systems that don't have a concept of standalone agents

### The plan is now "/goal" ready

Previously produced two documents: requirements doc + implementation plan. Problem: they drift, you need to track which is authoritative, agents must reconcile both in context.

**Change:** New unified "plan" document collapses these into a single artifact.
- `/ce-brainstorm` lays out scenarios and requirements
- `/ce-plan` updates the document to also cover implementation plan details
- One complete doc package for you and your agent
- Has clear definition of done, bounded scope, explicit implementation approach
- At end of `/ce-plan`, offers option to start `/goal` with the plan

**Results in testing:**
- Multi-hour runs on complete features, one topping 6 hours
- Agent implemented features fully, wrote tests, opened PR, shipped with no human in the loop beyond the initial plan handoff

**Portability bonus:** one document is easier to pass between agents, attach to a task, drop into a new context.

### Documents that draw, when drawing helps

Skills now support real HTML output as an option. When used, the document supplements prose with visuals — diagrams where a diagram lands the point better than a paragraph.

- `ce-ideate` outputs HTML by default (ideation is a human-in-the-loop moment)
- Markdown is still the default (most CE usage feeds documents straight to agents)
- HTML is opt-in: `output=html` or "use html format" in prompt
- Set it once: put preferred default format in AGENTS.md/CLAUDE.md or CE config
- Respects DESIGN.md at repo root for visual style guidance

### Additional changes

- **Cross-model adversarial review:** `ce-code-review` gained a cross-model adversarial pass — a second model actively trying to break the first one's work. Also right-sized and routed through one portable path.
- **Smarter PR-feedback resolution:** `ce-resolve-pr-feedback` now judges findings centrally before dispatching fixers, instead of firing off fixes in parallel.
- **`ce-brainstorm` got eyes:** visual feedback during brainstorming — agent spins up a small visual artifact, previews in a small web server, tears down when done. Even works in Codex app.
- **Marketplace + install fixed:** 50% reduction in skill descriptions, installation easier on Pi and OpenCode.

### Key architectural insight

Standalone agent definitions are not a reliable cross-harness denominator. Skills are. Skills can slot into any plugin system; agents require harness-specific support. The migration from agents to skill-local prompt assets unlocks portability without losing specialist behavior.
