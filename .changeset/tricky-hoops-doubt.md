---
"cortex-forge": patch
---

`wiki/meta/log.md` entries now use `**[YYYY-MM-DD] type**` (bold) instead of `## [YYYY-MM-DD] type` (H2 heading) — the heading rendered every log line as a giant title in Obsidian and cluttered the document outline. Updated `cortex-imprint`, `cortex-prune`, and `cortex-recall` to write the new format going forward. Added `bin/tags-audit.py`, a standalone (non-wired) tag-usage audit script.
