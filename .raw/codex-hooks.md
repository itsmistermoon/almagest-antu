# Hooks – Codex

Source: https://developers.openai.com/codex/hooks

This page documents Codex hooks: lifecycle hooks that let you run commands, emit context, or block/continue behavior at specific points in a Codex session.

## Core ideas

1. Hooks are organized by event, matcher group, and hook handlers.
2. Codex supports review and trust for non-managed hooks before they run.
3. Hook events include session lifecycle, tool use, compaction, prompt submission, subagent stop, and stop/continue control.
4. Managed hooks from system, MDM, cloud, or `requirements.toml` are trusted by policy.
5. Hooks can add context, block actions, or alter continuation behavior by returning structured JSON or exit code `2`.

## Notable events

- `SessionStart`
- `PreToolUse`
- `PostToolUse`
- `PermissionRequest`
- `PreCompact`
- `PostCompact`
- `UserPromptSubmit`
- `SubagentStop`
- `Stop`

## Notes

- Project-local hooks only load when the project `.codex/` layer is trusted.
- Plugin-bundled hooks load with other hook sources and use the same trust-review flow.
- The page is the release behavior reference; the generated schemas in the Codex GitHub repository are the source for exact wire format.
