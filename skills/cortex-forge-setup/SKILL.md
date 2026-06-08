---
name: cortex-forge-setup
description: One-time setup for the Cortex Forge protocol. Configures the vault path, installs global skills, and optionally configures lifecycle hooks for automatic session memory.
argument-hint: "Vault path (optional, prompted if omitted)"
---

Initial setup for Cortex Forge. Run once after cloning the repo or when the vault location changes.

## Steps

1. **Check for existing config** — read `~/.cortex-forge/config.yml` if it exists and display current values.

2. **Set vault path** — if no config exists or the user wants to update it:
   - Ask: "Where is your vault? (directory containing wiki/, AGENTS.md, and .git)"
   - Validate the path has: `.git/`, `wiki/`, `AGENTS.md`, `skills/`
   - If validation fails, report what's missing and stop

3. **Write config**:
   Create `~/.cortex-forge/config.yml`:
   ```yaml
   vault: {validated-path}
   ```

4. **Install global skills** — copy to the agent's skill directory:
   - `{vault}/skills/cortex-crystallize/` → `~/.agents/skills/cortex-crystallize/`
   - `{vault}/skills/cortex-forge-setup/` → `~/.agents/skills/cortex-forge-setup/`
   - `{vault}/skills/cortex-recall/` → `~/.agents/skills/cortex-recall/`
   - Overwrite if they already exist (update in place)

5. **Claude Code symlinks** — if `~/.claude/` exists (Claude Code is installed):
   - Create `~/.claude/skills/` if it doesn't exist
   - Create symlinks (not copies) pointing to the installed skills:
     - `~/.claude/skills/cortex-crystallize` → `~/.agents/skills/cortex-crystallize`
     - `~/.claude/skills/cortex-forge-setup` → `~/.agents/skills/cortex-forge-setup`
     - `~/.claude/skills/cortex-recall` → `~/.agents/skills/cortex-recall`
   - If a symlink already exists and points to the right target, skip silently
   - If a symlink exists but points elsewhere, overwrite it

6. **Configure lifecycle hooks** — ask: "Set up automatic session memory hooks? (recommended)"
   If yes:
   - **Claude Code** (`~/.claude/` exists):
     - Copy hook scripts from `{vault}/bin/hooks/` to `~/.claude/hooks/` (create dir if needed)
     - Read `~/.claude/settings.json` (or create it if missing)
     - Add the following hooks if not already present:
       ```json
       "SessionStart": [{ "type": "command", "command": "~/.claude/hooks/load-hot-cache.sh" }]
       "PreCompact":   [{ "type": "command", "command": "~/.claude/hooks/update-hot-cache.sh" }]
       ```
     - Merge carefully — do not overwrite existing hooks, only append to the arrays
   - **Other agents** — display manual instructions:
     ```
     Codex (~/.codex/hooks.json):
       SessionStart → bash {vault}/bin/hooks/load-hot-cache.sh
       Stop         → bash {vault}/bin/hooks/update-hot-cache.sh

     Antigravity (~/.agents/hooks.json):
       PreInvocation (invocationNum == 0) → bash {vault}/bin/hooks/load-hot-cache.sh
       Stop (fullyIdle == true)           → bash {vault}/bin/hooks/update-hot-cache.sh
     ```

7. **Confirm result**:
   - Vault configured at: `{path}`
   - Skills installed: `cortex-crystallize`, `cortex-forge-setup`, `cortex-recall`
   - Claude Code symlinks: created / up to date / skipped
   - Hooks: configured / skipped / manual instructions shown
   - Next step: invoke `/cortex-crystallize` at the end of any project session

## Hook behavior

The hooks provide automatic (no-invoke) session memory:
- **SessionStart** (`load-hot-cache.sh`) — reads `.hot/{project}.md` and injects it as context
- **PreCompact / Stop** (`update-hot-cache.sh`) — appends a snapshot to `.hot/{project}.md`

The hook writes a minimal snapshot (files touched, external actions). For a full snapshot with Current state updated, invoke `/cortex-crystallize` manually — hooks and manual invocation are compatible and complementary.

## Rules

- Do not modify any vault files during setup — read only for validation
- Create `~/.agents/skills/` if it doesn't exist
- If config already exists, show it and ask before overwriting
- Symlinks in `~/.claude/skills/`, not copies — updates propagate automatically
- When merging into `settings.json`, preserve all existing hooks
