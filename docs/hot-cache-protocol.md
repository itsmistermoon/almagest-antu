# Hot Cache Protocol

The Hot Cache Protocol is cortex-forge's mechanism for session memory and multi-agent coordination. It solves a fundamental problem: AI agents start every session cold, with no knowledge of what previous agents did or where things stand.

## The file

Each project gets a single file: `.hot/MEMORY.md`

- Lives in the working directory (next to `.git/`)
- **Gitignored** — it's a local agent artifact, not versioned content
- Append-only — new snapshots go at the top, older entries remain for reference
- Plain markdown — no binary format, no tool-specific encoding

## Format

```markdown
# {Project} — Hot Cache

## {YYYY-MM-DD HH:MM TZ}
- **Agent:** {Claude Code | Codex | Gemini | etc.}
- **Trigger:** {SessionEnd | PreCompact | manual}

### What was done
- List of files created/modified, decisions made, features built

### Pending
- Unresolved tasks or open questions

### Fragile context
- Exact numbers, commands, paths, URLs, or conventions an agent can't infer from the code
```

Each session appends a new snapshot. The file accumulates history across agents and sessions — that history is intentional, not noise.

---

## Operating modes

### Manual (universal)

Any agent can write a snapshot via the `/cortex-crystallize` skill. No configuration required. The agent summarizes the session and appends it to `.hot/MEMORY.md`.

Activation: invoke `/cortex-crystallize` after completing a milestone, or ask the agent to "save context" / "update the hot cache".

This mode works with **any** agent that can read markdown instructions: if `AGENTS.md` instructs the agent to read `.hot/MEMORY.md` on session start and write on significant milestones, the protocol operates — no hooks, no config.

### Automatic via hooks (optional, recommended)

Agents that expose lifecycle hooks can automate hot cache read/write entirely. The pattern is:

- **Session start**: read `.hot/MEMORY.md`, inject as context
- **Session end**: extract work done from the transcript, write snapshot

Reference implementations are in `bin/hooks/`:

| Script | Event | Purpose |
|--------|-------|---------|
| `load-hot-cache.sh` | Start | Read `.hot/`, inject as context |
| `update-hot-cache.sh` | End | Extract touched files + prompts, write snapshot |

#### Hook compatibility

| Agent | Start event | End event | `cwd` source | Notes |
|-------|-------------|-----------|--------------|-------|
| Claude Code | `SessionStart` | `Stop` / `PreCompact` | `cwd` in payload | Full transcript access |
| Codex | `SessionStart` | `Stop` | `cwd` in payload | No `transcript_path` — snapshot is minimal without it |
| Antigravity | `PreInvocation` (`invocationNum == 0`) | `Stop` (`fullyIdle == true`) | `workspacePaths[0]` | `transcriptPath` available |
| Others | — | — | — | Use manual mode |

Agent-specific configs:

```
~/.claude/settings.json    → Claude Code hooks
~/.codex/hooks.json        → Codex hooks
~/.agents/hooks.json       → Antigravity hooks
```

---

## Multi-agent coordination

The protocol is agent-agnostic by design. Three properties make it work across agents:

**1. Shared filesystem, no shared state in the repo**
`.hot/` is gitignored. Any agent running on the same machine shares the same `.hot/MEMORY.md` and reads each other's session history. There's no sync protocol, no server, no API — just a file.

**2. Self-describing**
An agent that has never seen the project before can read `AGENTS.md`, find the instruction to read `.hot/MEMORY.md`, and bootstrap itself from the accumulated history. No human coordination needed.

**3. Graceful degradation**
The protocol has three levels of automation:

```
Hooks configured  →  fully automatic (read on start, write on end)
Skills available  →  semi-automatic (agent follows AGENTS.md, writes on milestones)
Neither           →  manual (human instructs agent to update cache)
```

All three levels produce compatible `.hot/` files. A session started manually and one started with hooks produce snapshots in the same format — any agent reading the file can't tell the difference.

---

## Setup

1. Add `.hot/` to `.gitignore`
2. Copy `AGENTS.md` to your vault root — it instructs agents to read `.hot/MEMORY.md` on session start
3. Optionally configure hooks from `bin/hooks/` for your agent

That's the full setup. The protocol starts working as soon as an agent reads `AGENTS.md`.
