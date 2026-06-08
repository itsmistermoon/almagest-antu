# CommandCode Hooks Best Practices

**URL:** https://commandcode.ai/docs/hooks/best-practices
**Fetched:** 2026-06-08

## When to Use Hooks

Hooks excel at "deterministic, out-of-model enforcement": blocking destructive actions, auditing tool calls, injecting required context, and halting sessions on specific signals. They are not for logic that belongs in the model's reasoning.

## Writing Safe Hooks

- **Input handling**: Parse stdin with `jq -r`, never `eval` — tool inputs originate from the model and should be treated as untrusted.
- **Variable safety**: Always quote variables before passing to shell. Use `grep -qE` on quoted `printf` statements rather than eval operations.
- **Performance**: Keep timeouts tight — 10 seconds maximum for synchronous (PreToolUse) hooks to prevent UI lag.
- **Model guidance**: Prefer `additionalContext` for instructing the model; use `systemMessage` for explaining policy violations.

## Testing and Debugging

- Iterate on hooks locally by piping mock payloads via environment variables — no need to run the full CommandCode application.
- The `--debug` flag generates detailed logs showing hook evaluation decisions, matcher results, and payload data.

## Common Issues

| Issue | Cause |
|-------|-------|
| Hook not executing | Matcher regex mismatch |
| Hook not executing | Script not executable (`chmod +x`) |
| Hook not executing | Running in plan mode (hooks disabled in plan mode) |
| Unexpected behavior | Malformed JSON output |
| UI lag | Timeout violation in synchronous hook |

## Performance Considerations

Since hooks execute on every matching tool call, latency accumulates quickly. Recommendations:
- Keep PreToolUse hooks fast (<10s).
- Defer slow operations to `PostToolUse` events or background processes.
- Avoid blocking on external API calls in synchronous hooks.
