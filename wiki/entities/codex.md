---
title: Codex CLI
type: entity
created: 2026-06-16
updated: 2026-06-16
tags: [codex, openai, agent, hooks, cli]
aliases: [Codex, OpenAI Codex CLI]
sources:
  - wiki/sources/codex-hooks.md
confidence: high
schema_version: "0.3"
---

# Codex CLI

Codex CLI is OpenAI's terminal-first AI coding agent. Cortex Forge treats Codex as manual-only for session memory — no hooks are installed at all (as of 2026-07-02, cortex-forge removed agent lifecycle hooks across every agent; see [[wiki/concepts/agent-hook-compatibility]]).

## Hook system

- **Events:** `SessionStart`, `SessionEnd`, `PreToolUse`, `PostToolUse`, `SubagentStop`, `Stop`, `PromptSubmit`, `Compaction`
- **Config:** `~/.codex/hooks.json` (global) or `.codex/hooks.json` (project-local, requires trust)
- **Wire format:** hook payload is JSON, but Codex session transcripts are a Codex-specific JSONL event stream under `payload`, not the Claude `.message.content[]` transcript format
- **Trust model:** non-managed hooks require explicit `/hooks` review before first execution; managed (policy-trusted) hooks are not user-disableable
- **Stop event:** does not use `matcher`; expects JSON stdout on exit 0, or exit 2 with continuation reason on stderr
- `transcript_path` available in hook input as a convenience field (format not a stable interface)

## Cortex Forge integration

- **Skills:** global install via `cortex-forge-setup` to `~/.agents/skills/` (Codex reads them per its own skill-resolution convention)
- **Hooks:** none — `AGENTS.md` mandates reading `.cortex/MEMORY.md` before the first response; `/cortex-crystallize` is invoked manually after milestones and at session close, the same as every other agent

## Relationships
- Comparable agents: [[wiki/entities/commandcode]], [[wiki/entities/antigravity-cli]], [[wiki/entities/pi-cli]]
- Concepts: [[wiki/concepts/agent-hook-compatibility]]

---

- 2026-06-16 [Claude Code]: Page created from cortex-prune check 2c — codex-hooks.md had no covering entity page
- 2026-07-02 [Claude Code]: Cortex Forge integration section updated — no-op hook guards removed, replaced by the manual `AGENTS.md`-mandated protocol used by every agent
