---
name: cortex-crystallize
behavior: ["snapshot"]
description: Snapshot session context into .cortex/MEMORY.md — preserves pending tasks, active decisions, and session history so future sessions resume without losing context. Invoke when the user says "save context", "crystallize", "snapshot this", "wrap up", "I'm done for now", or when the session is about to close. Works from any repo, inside or outside the vault.
argument-hint: "[vault-name] [project-name] [next: <focus>]"
---

Begin your response with a short flavor line announcing the skill started, translated to the language of the user's current message (anchor: `Crystallizing memory...`; Spanish: `Cristalizando memoria...`; translate analogously for other languages). Output this literally as the first thing in your response.

Save a session snapshot to `.cortex/MEMORY.md` in the active repo (the nearest `.git`), so any agent can resume without losing context.

## Modes

Behavior depends on where the skill is invoked:

- **Inside the vault** — standard snapshot: update current state, append history entry.
- **Outside the vault** (e.g., `loyalty-platform/`) — cross-vault mode: snapshot the project repo AND update the linked vault page with knowledge applied and recurring issues.

## Steps

1. Detect active repo: find nearest `.git` from CWD. If none, ask.
1a. **Detect invoking agent** — identify yourself primarily via self-knowledge: you know which CLI/agent you are running as, regardless of which one it is. Corroborate with `env` only if it surfaces something more specific (e.g. a model identifier) — read whatever agent-identifying variables are actually present rather than checking a fixed list of hardcoded agent names, since new agents are added to the ecosystem continuously and a hardcoded list goes stale. Append the model, if determinable, in parentheses (e.g. `Claude Code (claude-sonnet-5)`). If truly undetermined, use `Unknown agent` rather than guessing.
   Use the detected identity as `{Agent}` in the history header and in the `agent:` frontmatter field.
2. **Resolve vault** from `~/.cortex-forge/config.yml`. If missing, prompt to run `/cortex-forge-setup` first. Also read `locale:` — see `references/LOCALE-RESOLUTION.md` for the fallback chain.
   - Config format: `vaults: {name: {path, locale}, ...}` + `default: name`
   - If the first argument matches a registered vault name (e.g., `/cortex-crystallize second-brain`) → use that vault; treat the second argument (if any) as the project name override.
   - Otherwise: check if CWD is inside any registered vault (CWD starts with a vault path) → use that vault.
   - If not, use the `default` vault.
   - If no default and multiple vaults → ask the user to pick one.
3. Determine mode:
   - If active repo contains `wiki/` and `AGENTS.md` → **it IS a vault** → standard mode. Same criteria `cortex-forge-setup` uses to validate a vault.
   - Otherwise → cross-vault mode (snapshot project repo + update linked vault page).
4. Create `.cortex/` if it doesn't exist. Add `.cortex/` to `.gitignore` if not already there.
5. Read `.cortex/MEMORY.md` in full if it exists. If the file has malformed YAML frontmatter (parse error on the `---` block), do not stop — read the body as plain text, skip the frontmatter fields, and note the issue in the next `#### Fragile context` entry. Overwrite the frontmatter with correct values in step 6.
5b. **Prune PRAXIS.md working context** — if `.cortex/PRAXIS.md` exists, remove any `### Working context` entries older than 30 days (compare entry date against today). Do not touch `## Permanent`. If nothing to prune, skip silently.
5c. **Rotate History entries older than 30 days to CONSOLIDATED.md** — for each `### {date}` entry under `## History` in `.cortex/MEMORY.md`, compare its date against today. If more than 30 days old:
   1. Append the entry verbatim (unmodified, same template) to `.cortex/CONSOLIDATED.md`, creating the file with a one-line header if it doesn't exist (`# {vault-name} — consolidated history`).
   2. Remove it from `.cortex/MEMORY.md`'s `## History` — MEMORY.md must only ever contain History entries from the last 30 days.
   3. Preserve chronological order (oldest-first, matching History's own append order) — never reorder entries in either file.
   If no entries qualify, skip silently. **Done when:** every History entry older than 30 days has been moved — zero left behind in MEMORY.md.
6. **Update current state** (see limits below). Update `agent:` and `updated:` in the file frontmatter to reflect the current agent and date.
   - If an argument with `next: <focus>` was provided (e.g., `/cortex-crystallize next: PostToolUse hook`), add a `### Suggested skills` entry and tailor `### Pending` toward the declared next focus.
6a. **Consider PRAXIS.md updates** — a deliberate judgment call, not an automatic log entry. PRAXIS is semantic memory: durable knowledge about *how to operate*, distinct from MEMORY.md's working state (what's active now) and its History zone's episodic record (what happened). Ask: did this session surface operational knowledge — an environment workaround, an operator preference, a vault-specific convention, a recurring failure pattern, or similar — that the next agent needs to avoid re-discovering? These are examples, not an exhaustive list; anything of the same shape qualifies. See `references/PRAXIS-FORMAT.md` for the write format.

   **Gate for which zone** (confidence, not category, decides):
   - **Confirmed** — the user stated it explicitly as a standing rule ("always confirm before deleting", "respond in Chilean Spanish"), or it already appears once in `## Working context` from a prior session and has now held true again. In the latter case, promote it: move the entry to `## Permanent` and remove it from `## Working context` — never leave the same fact logged in both zones. → `## Permanent`.
   - **Provisional** — a single-session observation not yet confirmed: a workaround that worked once but wasn't tested for generality, a suspected failure pattern seen for the first time, an inferred convention the user hasn't explicitly confirmed. → `## Working context` (dated; auto-pruned by step 5b after 30 days if never confirmed again).

   If nothing from this session qualifies, skip — do not write to PRAXIS.md by default. **Done when:** every candidate insight from this session has been written to the correct zone or explicitly evaluated and rejected — not silently forgotten.
7. **Append snapshot to history** using the format in `references/MEMORY-FORMAT.md` (co-located with this skill).
8. If cross-vault mode: **run cross-vault update** (see section below).

In `#### Fragile context` and any other section, omit tokens, API keys, and credentials (patterns: `sk-*`, `Bearer *`, `ghp_*`, `?token=*`, flags `--password`/`-u user:pass`). If fragile context requires a credential to reproduce, replace it with `<REDACTED>` and note where to obtain it (e.g. `export ANTHROPIC_API_KEY=<REDACTED>  # see .env.local`).

## Cross-vault update

When invoked from outside the vault, after completing the snapshot:

1. Locate `{vault}/wiki/pages/{project-name}.md`. If the file doesn't exist, skip and note it.
2. Ask the user two questions:
   - **Knowledge applied:** "Which vault pages influenced decisions this session? (e.g., `wiki/concepts/deep-modules`) — or 'none'"
   - **Recurring issues:** "Any recurring problems worth tracking? — or 'none'"
3. If the user provides answers, **propose** the exact text to add to `wiki/pages/{project}.md` before writing.
4. On confirmation, append to the relevant sections:
   - `## Knowledge applied` → `- [[{page}]] — {how it was applied} ({date})`
   - `## Recurring issues` → `- {description} (first seen: {date})`
5. Update `updated:` in the project page frontmatter.

Never write to the vault without explicit confirmation.

## Zone 1 — Current state (MUTABLE)

Update on every `/cortex-crystallize`. Use the canonical format in `references/MEMORY-FORMAT.md` (co-located with this skill) — do not reproduce it here.

Hard limits: **max 5 pending items, max 3 active decisions**. When adding an item, evaluate whether an existing one is obsolete and remove it. The size constraint is what makes this zone reliable — if it grows unbounded, it degrades.

**What goes in Current state vs. History:**
- **Current state** — requires action in a future session: tasks to resume, decisions to revisit, incomplete work. If the next agent needs to act on it, it goes here.
- **History** — complete and closed within this session. If nothing is left to do, it belongs only in History.

When in doubt: ask "does the next session need to act on this?" If no → History only. If yes → add to `### Pending` in Current state.

`agent:` identifies who last wrote Current state. Update it on every invocation — when multiple agents operate the same vault, this field shows whose snapshot is active without reading git history.

## Zone 2 — History (APPEND-ONLY)

Append at the end, never modify previous entries. Use the canonical format in `references/MEMORY-FORMAT.md` (co-located with this skill) — do not reproduce it here. Entries older than 30 days are rotated out to `.cortex/CONSOLIDATED.md` by step 5c — `MEMORY.md`'s History always reflects only the last 30 days. `CONSOLIDATED.md` is never read automatically; consult it directly only when a session needs to reference older history.

`#### Imprint candidate` is surfaced manually — when a new session starts and the agent reads `.cortex/MEMORY.md` (per `AGENTS.md` instructions), it should check the most recent history entry for this field and nudge the user to run `/cortex-imprint` if present. Disable globally by setting `imprint_triage: false` in `~/.cortex-forge/config.yml`.

## Output format

After completing the snapshot, confirm:
1. What changed in `### Pending` (items added, removed, or kept)
2. What was appended to `## History` (one-line summary of the new entry)
3. If cross-vault mode ran: which vault page was updated

## Rules

- Language: use the locale resolved in step 2b — do not default to your training language.
- Empty sections: omit entirely — never write `_(none)_` or other placeholders. This applies to `#### Attempted and failed` and `#### Discarded` and `#### Fragile context` equally.
- Pending items live in **Current state**, not in the snapshot — so they don't get buried.
- The history snapshot **has no pending section** — that's Current state's responsibility.
- Don't duplicate content already in ADRs, PRDs, issues, or commits — reference by path.
- `.cortex/` must be in `.gitignore` — it's a local agent artifact, not project content.
