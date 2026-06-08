---
name: cortex-prune
description: Health check del vault — detecta dead links, páginas huérfanas, provenance faltante y fuentes no procesadas. Vault-local.
argument-hint: "No arguments — vault detected from CWD"
---

Health check del vault activo. Ejecuta `bin/cortex-prune.sh` y reporta hallazgos por severidad.

## Steps

1. **Detect vault** — find nearest `.git` from CWD. Confirm it contains `wiki/` and `bin/cortex-prune.sh`.
2. **Run** `bash {vault}/bin/cortex-prune.sh {vault}` and capture output.
3. **Report** findings grouped by severity. For each finding include: path, problem, suggested action.
4. **Ask** whether to proceed with corrections:
   - **Auto-correctable** (propose and apply on confirmation):
     - Add missing `confidence:` to source pages
     - Add entry to `wiki/index.md` for unindexed pages
     - Add `wiki/meta/log.md` entry: `## [YYYY-MM-DD] prune | {N} findings`
   - **Requires discussion** (never auto-apply):
     - Delete orphan pages
     - Create missing entity/concept pages (requires knowing the content)
     - Mark claims as `[!stale]`

## Detection criteria (implemented in bin/cortex-prune.sh)

| Severity | Check |
|---|---|
| HIGH | Dead `[[wikilinks]]` pointing to non-existent pages |
| HIGH | `.raw/` files with no corresponding `wiki/sources/` page |
| HIGH | Pages without YAML frontmatter (excl. `index.md`, `log.md`) |
| MEDIUM | Orphan pages — no incoming wikilinks from any other vault page |
| MEDIUM | Concepts/entities without `sources:` or `confidence:` frontmatter |
| MEDIUM | Source pages without `confidence:` frontmatter |
| LOW | Source pages without `tags:` (or `tags: []`) |

## Rules

- Always run the script — never reproduce its logic ad-hoc
- `index.md` and `log.md` without frontmatter is expected, not a finding
- Source pages use `source:` (URL) and `raw:` for provenance — `sources:` (wiki links) is for concepts and entities only
- Orphan sources are normal if freshly ingested and not yet linked from concepts/entities
- Never delete pages without explicit confirmation
