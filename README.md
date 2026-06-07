# cortex-forge

A protocol for agent-operated knowledge vaults — five skills, one session layer, any LLM.

## What it is

Cortex Forge is a structured system for turning raw sources into synthesized, queryable knowledge. Agents operate the vault: they ingest, recall, and maintain. You define what matters and when to persist it.

The architecture works with any LLM agent — Claude Code, Codex, Gemini, Cursor — via a shared session file and a set of invocable skills.

## Architecture

Five layers, each with a distinct role:

| Layer | Path | Purpose | Rule |
|-------|------|---------|------|
| **Raw** | `.raw/` | Immutable original sources | Never modify |
| **Wiki** | `wiki/` | Synthesized knowledge | Agent writes and maintains |
| **Hot** | `.hot/` | Per-project session cache | Read on session start |
| **Meta** | `wiki/meta/` | Vault metadata and guides | Agent maintains |
| **Skills** | `skills/` | Invocable agent skills | Extend, don't modify |

## Skills

Five skills that map to how knowledge actually moves through a system:

### `cortex-assimilate` — Ingest

Sources land in `.raw/`: articles, PDFs, transcripts, URLs. The agent processes them and produces structured wiki pages. The brain doesn't store what it perceives — it stores what it processes. Without this step, information enters the system in name only.

### `cortex-crystallize` — Session context

Working memory lasts seconds. `.hot/{project}.md` extends it indefinitely: current state, active decisions, open threads. The agent reads it on session start; you invoke it at the end. Without it, every conversation starts from zero.

### `cortex-imprint` — Permanent archive

What was worth keeping from the session becomes a stable wiki page. A memory trace is what remains after an experience ends. The session closes; the knowledge stays encoded in the vault.

### `cortex-recall` — Query

The agent searches the vault, retrieves relevant pages, and synthesizes a response with citations. It can only return what was imprinted — if it's not in the vault, it doesn't exist for the system.

### `cortex-prune` — Vault hygiene

Detects orphan pages, dead links, contradictory claims, stale information. Forgetting in the brain isn't a failure — it's maintenance. Prune does this deliberately: removes what weakens the network so what remains is more reliable.

## Wiki Taxonomy

| Type | Path | Purpose |
|------|------|---------|
| Concept | `wiki/concepts/` | Ideas, patterns, frameworks |
| Entity | `wiki/entities/` | People, tools, services |
| Source | `wiki/sources/` | Articles, docs, external references |
| Page | `wiki/pages/` | Active projects and decisions (ADRs) |

Each page follows: YAML frontmatter + compiled truth + chronological changelog.

## Hot Cache Protocol

Every AI session starts cold. Without external memory, an agent that worked on your vault yesterday has no idea what it did — it will re-derive context, re-ask questions, and potentially contradict decisions already made.

The Hot Cache Protocol solves this with a single file per project: `.hot/{project}.md`. It lives next to `.git/`, is gitignored (local agent artifact, not versioned content), and has two zones:

```
## Current state     ← mutable — always small, always fresh
  Pending items (max 5)
  Active decisions (max 3)

## History           ← append-only — never modified, just extended
  Session snapshots: what was done, what was discarded, fragile context
```

At session start, the agent reads the file and resumes with full context. At session end, it updates current state and appends a snapshot. The size limits on current state are intentional — a zone that grows without bound degrades into noise.

**Agent-agnostic.** The protocol works with any LLM that can read markdown. Claude Code, Codex, Gemini, Cursor — if the agent reads `AGENTS.md`, it knows to read `.hot/{project}.md`. Manual mode requires no configuration beyond that.

**Cross-project.** `cortex-crystallize` works from any repo, not just the vault. When invoked from a linked project (e.g., a product codebase), it snapshots that project's session and optionally updates the vault's project page with knowledge applied and recurring issues detected.

**Three levels of automation**, each compatible with the others:

| Level | Mechanism | Configuration |
|-------|-----------|---------------|
| Manual | User invokes `/cortex-crystallize` | None — just read `AGENTS.md` |
| Semi-auto | `AGENTS.md` instructions | None — agent follows protocol |
| Automatic | Lifecycle hooks | Required — run `/cortex-forge-setup` |

Automatic mode uses two scripts from `bin/hooks/`: `load-hot-cache.sh` (reads `.hot/` on session start) and `update-hot-cache.sh` (appends a snapshot on session end). `/cortex-forge-setup` installs and wires them for Claude Code and shows instructions for other agents.

See [Hot Cache Protocol spec](docs/hot-cache-protocol.md) for hook compatibility (Claude Code, Codex, Antigravity) and implementation details.

## Usage

Fork this repo and adapt it to your knowledge domain. The `skills/`, `templates/`, and `wiki/` structure is designed to be domain-agnostic — swap out the content, keep the architecture.

See `AGENTS.md` for agent operating rules.
