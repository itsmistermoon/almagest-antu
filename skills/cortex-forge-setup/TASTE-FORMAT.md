# TASTE rule — Cortex Forge Skills

Used by `/cortex-forge-setup` step 7 to seed CommandCode's TASTE file.
Two variants depending on scope chosen during setup.

---

## Per-project scope

File: `{vault}/.commandcode/taste/taste.md`
Applies only when working in this vault directory.
Includes `cortex-prune` (vault-local skill).

```markdown
## Cortex Forge Skills
- When answering questions about project decisions, architecture, or history, invoke /cortex-recall first. Confidence: 0.85
- When referencing vault knowledge (wiki pages, concepts, entities), use /cortex-recall to retrieve accurate, cited content. Confidence: 0.85
- When the user provides a URL or file to add to the vault, use /cortex-assimilate. Confidence: 0.85
- When a valuable insight, decision, or synthesis emerges from a session, archive it with /cortex-imprint. Confidence: 0.85
- At the end of a working session, snapshot context to memory with /cortex-crystallize. Confidence: 0.85
- When the vault accumulates stale or redundant pages, use /cortex-prune to clean up. Confidence: 0.85
```

---

## Global scope

File: `~/.commandcode/taste/taste.md`
Applies in every project on this machine.
`cortex-prune` scoped to vault directories only.

```markdown
## Cortex Forge Skills
- When answering questions about project decisions, architecture, or history, invoke /cortex-recall first. Confidence: 0.85
- When referencing vault knowledge (wiki pages, concepts, entities), use /cortex-recall to retrieve accurate, cited content. Confidence: 0.85
- When the user provides a URL or file to add to the vault, use /cortex-assimilate. Confidence: 0.85
- When a valuable insight, decision, or synthesis emerges from a session, archive it with /cortex-imprint. Confidence: 0.85
- At the end of a working session, snapshot context to memory with /cortex-crystallize. Confidence: 0.85
- When working inside a Cortex Forge vault and it accumulates stale or redundant pages, use /cortex-prune to clean up. Confidence: 0.85
```

---

Note: confidence scores are seed values — `taste-1` adjusts them over time based on observed usage.
Idempotency marker: skip if file already contains `## Cortex Forge Skills`.
