# CommandCode Hooks Examples

**URL:** https://commandcode.ai/docs/hooks/examples
**Fetched:** 2026-06-08

CommandCode provides four working hook examples that developers can adapt:

## 1. Block Dangerous Bash Commands (PreToolUse)

Prevents the model from executing harmful commands. Matches the model's shell command against a short list of dangerous patterns (e.g., `rm -rf /`, `curl | sh`, fork bombs, `sudo rm`). When triggered, the model receives feedback explaining why execution was denied via `permissionDecision: "deny"`.

## 2. Warn on Sensitive File Reads (PreToolUse — context injection)

Allows all file reads but injects warnings when paths appear sensitive. Always returns `permissionDecision: "allow"` while sending `additionalContext` to the model about redacting keys or tokens from `.ssh/`, `.env`, `.pem`, or `id_rsa` files. Non-blocking but informative.

## 3. Audit Tool Calls (PreToolUse or PostToolUse — observe-only)

Logging mechanism for tracking tool usage. Can fire at `PreToolUse` (logging attempted commands) or `PostToolUse` (logging completed writes). Appends tab-separated entries to local log files with timestamps and session IDs. Exits `0` without modifying behavior.

## 4. Quality Gate (Stop Hook)

Prevents task completion while `DO NOT SHIP` markers remain in code. Exits `2` when it finds one, sending the assistant back for another pass with feedback about offending lines. Supports up to 3 automatic retries.

## Key Requirement

All hook scripts must be executable (`chmod +x`) before CommandCode activates them.
