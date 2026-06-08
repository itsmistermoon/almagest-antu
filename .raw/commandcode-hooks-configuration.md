# Hooks Configuration | Command Code Docs

**URL:** https://commandcode.ai/docs/hooks/configuration
**Fetched:** 2026-06-08

## Configuration

Hooks are configured under the `hooks` key in a `settings.json` file. Command Code looks for settings.json in the following paths:

| Scope | Config file | Applies to | Committed to git? |
|-------|-------------|------------|-------------------|
| User | `~/.commandcode/settings.json` | Across all projects | No |
| Project | `.commandcode/settings.json` | Anyone using the project | Yes |

**Precedence: project > user.**

When the exact same command string appears in multiple scopes, the higher-priority source wins.

## Ordering

Within the same event, hooks fire in the order they appear in `settings.json` (project first, then user).

For example, `PreToolUse` hooks run **sequentially**. As soon as one blocks the tool, the remaining `PreToolUse` hooks are skipped. `PostToolUse` hooks run in **parallel** because the tool has already finished.

You can wire multiple hooks under a single matcher. They run in listed order:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "shell",
        "hooks": [
          { "type": "command", "command": "./.commandcode/hooks/guard-bash.sh", "timeout": 5 },
          { "type": "command", "command": "./.commandcode/hooks/log-shell.sh" }
        ]
      }
    ]
  }
}
```

Here `guard-bash.sh` runs first. If it denies, `log-shell.sh` is skipped.

For a complete `settings.json` wiring multiple matchers across both events, see Hooks Reference: Example `settings.json`.

## Next steps

- Hooks overview: the mental model and a quickstart
- Examples: see configuration put to work
- Best Practices: write safe hooks and debug common issues
- Hooks Reference: full schema for settings, input, and output
