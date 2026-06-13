# graphify — README (v8, full)

**URL:** https://github.com/safishamsi/graphify
**Fetched:** 2026-06-12

Type `/graphify` in your AI coding assistant and it maps your entire project — code, docs, PDFs, images, videos — into a knowledge graph you can query instead of grepping through files.

Works in Claude Code, Codex, OpenCode, Kilo Code, Cursor, Gemini CLI, GitHub Copilot CLI, VS Code Copilot Chat, Aider, Amp, OpenClaw, Factory Droid, Trae, Hermes, Kimi Code, Kiro, Pi, Devin CLI, and Google Antigravity.

66.3k stars, YC S26, 733 commits on v8 branch, 134 releases. MIT license.

## Multi-agent install paths (explicit from docs)

Claude Code (Linux/Mac): `graphify install` → writes skill file to `~/.claude/skills/` or project-scoped to `.claude/skills/graphify/SKILL.md` + references sidecar
CodeBuddy: `graphify install --platform codebuddy` → `CODEBUDDY.md` + PreToolUse hooks in `.codebuddy/settings.json`
Codex: `graphify install --platform codex` → `AGENTS.md` + PreToolUse hook in `.codex/hooks.json`. Also needs `multi_agent = true` under `[features]` in `~/.codex/config.toml`
OpenCode: `graphify install --platform opencode` → `AGENTS.md` + tool.execute.before plugin
Kilo Code: `graphify install --platform kilo` → `~/.config/kilo/skills/graphify/SKILL.md` + `~/.config/kilo/command/graphify.md` + `.kilo/plugins/graphify.js` + `.kilo/kilo.json` + AGENTS.md
Cursor: `graphify cursor install` → `.cursor/rules/graphify.mdc` with `alwaysApply: true`
Gemini CLI: `graphify install --platform gemini` → `GEMINI.md` + BeforeTool hook
Antigravity: `graphify antigravity install` → `.agents/rules` + `.agents/workflows`
Trae: `graphify install --platform trae` → `AGENTS.md`. Does NOT support PreToolUse hooks — AGENTS.md is the always-on mechanism.
Aider/OpenClaw/Factory Droid: `AGENTS.md` (sequential extraction, parallel agent support early)
Hermes: `AGENTS.md` + `~/.hermes/skills/`
Kiro IDE/CLI: `.kiro/skills/` + `.kiro/steering/graphify.md`
Devin CLI: skill file + `.windsurf/rules/graphify.md`
Copilot CLI: skill file
Amp: `graphify amp install` → skill file
Pi: skill file
Project-scoped flag: `--project` writes to `.claude/skills/` or `.agents/skills/` under CWD

## Hook mechanisms (explicit)
- Claude Code: PreToolUse hooks fire before search-style tool calls and before reading source files via Read/Glob. Payload-bearing.
- CodeBuddy: Same PreToolUse hooks as Claude Code (`.codebuddy/settings.json`), fire before Bash search and file reads.
- Codex: PreToolUse hook in `.codex/hooks.json`, fires before every Bash tool call.
- Gemini CLI: BeforeTool hook fires automatically before search-style tool calls.
- Kilo Code: Native `tool.execute.before` plugin (`.kilo/plugins/graphify.js`)
- Cursor: `alwaysApply: true` — included in every conversation automatically, no hook needed.
- Trae: Does NOT support PreToolUse hooks. AGENTS.md is the fallback.

Notable: CommandCode is NOT in the supported list.
