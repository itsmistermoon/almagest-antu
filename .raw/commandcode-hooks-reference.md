# CommandCode Hooks Reference

**URL:** https://commandcode.ai/docs/hooks/reference
**Fetched:** 2026-06-08

## Core Structure

CommandCode hooks are configured in `settings.json` under a `hooks` key. The system uses a two-level nesting pattern: **HookDefinition** objects specify which tools apply via matchers, while **HookEntry** handlers define what executes.

## HookDefinition Fields

- `matcher` (optional): Tool selector like `"shell"` or `"write|edit"`. Omitting matches all tools.
- `hooks` (required): Array of HookEntry handler objects.

## HookEntry Fields

- `type` (required): Currently supports `"command"` only.
- `command` (required): Shell command to execute.
- `timeout` (optional): 30-second default, 600-second maximum.

## Event Types

Three hook events exist:

1. **PreToolUse**: Runs before tool execution; can block via `permissionDecision: "deny"` or exit code `2`.
2. **PostToolUse**: Runs after tool completion; can signal advisory retry via `decision: "block"`.
3. **Stop**: Fires when the assistant produces final response; can retry the turn.

## Input/Output Format

Hooks receive JSON on stdin containing session context, tool details, and environment info. They return JSON to stdout with optional fields controlling behavior:

- `continue` — whether execution proceeds
- `systemMessage` — message injected into the model's context (policy explanations)
- `permissionDecision` — for PreToolUse: `"allow"` or `"deny"`
- `decision` — for PostToolUse: `"block"` triggers advisory retry
- `additionalContext` — context injected for the model without blocking

## Exit Codes

- `0`: Parsed as JSON; behavior determined by output fields.
- `2`: PreToolUse blocks tool; PostToolUse signals retry; Stop retries the turn.
- Other: Tool proceeds with non-blocking error logged.

## Execution Model

- **PreToolUse**: Sequential execution; stops on first denial.
- **PostToolUse & Stop**: Parallel execution.
- Each hook receives isolated stdin and cannot communicate with others.
