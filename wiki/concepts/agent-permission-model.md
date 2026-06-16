---
title: Agent Permission Model
type: concept
created: 2026-06-16
updated: 2026-06-16
tags: [permissions, security, headless, hooks, cross-agent]
aliases: [permission model, agent permissions, permission surface]
sources:
  - wiki/sources/commandcode-security.md
  - wiki/sources/commandcode-headless.md
  - wiki/sources/antigravity-cli-permissions.md
confidence: high
schema_version: "0.3"
---

# Agent Permission Model

Each AI coding agent exposes a permission surface that controls what actions it can take — file writes, shell commands, network requests, MCP tool calls. The models differ enough across agents that cortex-forge hook scripts must be aware of the target agent's defaults.

## Cross-agent permission matrix

| Agent | Default mode | Write files | Shell commands | Headless write | Override flag |
|-------|-------------|-------------|----------------|----------------|---------------|
| Claude Code | Auto-accept | ✅ | ✅ | ✅ | `--dangerously-skip-permissions` (already skipped) |
| CommandCode | Interactive | ❌ (requires approval) | ❌ (requires approval) | ❌ **blocked** | `--yolo` / `--dangerously-skip-permissions` |
| Antigravity CLI | Sandbox | Per action type | Per action type | Sandbox controls | `--sandbox-mode off` |
| Codex | Controlled | Controlled by mode | Controlled by mode | Controlled by mode | `--full-auto` |

## Critical: CommandCode headless writes

CommandCode's `cmd -p` (headless/print mode) blocks all writes and shell commands by default. This means crystallize hooks that call `cmd -p` without `--yolo` will appear to run successfully but silently fail to write `.hot/MEMORY.md`.

The `cortex-crystallize-commandcode.sh` hook uses `cmd -p --yolo` for this reason. This is the most common silent failure when porting Claude Code hook scripts to CommandCode. See [[wiki/concepts/headless-agent-mode]] for the full headless surface.

## CommandCode permission modes

| Mode | Flag | Writes | Shell | Use case |
|------|------|--------|-------|----------|
| Default | (none) | Requires approval | Requires approval | Interactive sessions |
| Plan | `--plan` | ❌ blocked | ❌ blocked | Read-only analysis |
| Auto-Accept | `--yolo` / `--dangerously-skip-permissions` | ✅ | ✅ | Hooks, CI, headless synthesis |
| Trusted tools | `--trust-tool <name>` | Per tool | Per tool | Selective auto-approve |

## Antigravity permission surface

Antigravity uses per-action-type permissions (not a global mode toggle):

- `read_file`, `write_file`, `command`, `network`, `browser_*` — each individually configurable
- Three preset modes: `default` (ask), `trusted` (allow most), `yolo` (allow all)
- OS-level sandbox enforced independently of permission mode (nsjail on Linux, sandbox-exec on macOS)
- Sandbox and permission model are orthogonal: sandbox can block actions that permission model allows

## MCP security surface

MCP servers expand the permission surface beyond what the agent itself controls:

- MCP tools run with the user's local permissions — an MCP server can write files, execute code, or make network calls without the agent's approval pipeline
- Untrusted MCP servers are an attack surface: a server returning crafted tool outputs can attempt to influence subsequent tool calls (see [[wiki/concepts/memory-as-attack-surface]])
- CommandCode allows per-MCP trust level: `--trust-mcp <server>` auto-approves all calls to that server

## Implication for cortex-forge hooks

Hook scripts that invoke an agent headlessly must:
1. Explicitly set the permission mode required for the operation (writes need auto-accept)
2. Use the correct flag for the target agent (`--yolo` for CommandCode, not needed for Claude Code)
3. Not assume that a successful exit code means the write succeeded — verify the file was written

See [[wiki/concepts/headless-agent-mode]] for the full headless execution surface and flag reference.

## Relationships
- Concept: [[wiki/concepts/headless-agent-mode]] (headless write permissions)
- Concept: [[wiki/concepts/agent-hook-compatibility]] (hook matrix per agent)
- Concept: [[wiki/concepts/memory-as-attack-surface]] (MCP injection vectors)
- Project: [[wiki/pages/cortex-forge]] (hook design decisions)

---

- 2026-06-16 [Claude Code]: Page created from commandcode-security.md + commandcode-headless.md — permission model is cross-agent and distinct from memory injection concern
