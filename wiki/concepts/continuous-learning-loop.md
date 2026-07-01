---
title: "Continuous Learning Loop"
type: concept
created: 2026-06-12
updated: 2026-07-01
tags: [memory, skills, hooks, self-improvement]
aliases: [session-to-skill extraction, learned skills]
sources:
  - wiki/sources/claude-code-longform-guide.md
confidence: medium
schema_version: "0.3"
---

# Continuous Learning Loop

Pattern where the agent's sessions are evaluated for non-trivial discoveries — debugging techniques, workarounds, project-specific patterns — and those discoveries are persisted as reusable skills, so the correction never has to be repeated.

## The problem it solves

Users re-issue the same corrective prompts across sessions ("don't do X, I already told you"). Each repetition wastes tokens and trust. The knowledge existed in a past session but had nowhere durable to live.

## The pattern

1. A **Stop hook** evaluates the complete session for extractable patterns and saves them as skill files (e.g. `skills/learned/`), loaded automatically when a similar problem appears.
2. A manual command (`/learn`) extracts a pattern mid-session right after solving something non-trivial, with user confirmation.
3. Variants: a reflection agent distilling user preferences from session logs into a memory file (RLanceMartin's "diary"), or periodic proactive suggestions the user approves/rejects (alexhillman).

Session-end evaluation is deliberately preferred over per-message evaluation (UserPromptSubmit): it sees the complete arc, adds no latency, and runs once. Contrast with [[wiki/concepts/prompt-classification-hook]], which optimizes for *routing* mid-session, not extraction.

## Application in Cortex Forge

`cortex-crystallize` already runs at Stop, but it extracts *state* (pending, decisions, fragile context), not *lessons*. A learning loop would extract the reusable correction — closer to what CommandCode's TASTE does implicitly ([[wiki/concepts/commandcode-taste]]). The output target differs too: skills (executable behavior) rather than wiki pages (knowledge). Security note: skills extracted automatically are supply-chain artifacts — see [[wiki/concepts/memory-as-attack-surface]].

## Implemented examples

- **CommandCode TASTE** — implicit, per-session extraction into taste profiles ([[wiki/concepts/commandcode-taste]])
- **[[wiki/entities/compound-engineering]] `/ce-compound`** — explicit, manual-trigger step in the compound loop; writes to `docs/solutions/` so future `/ce-brainstorm` and `/ce-plan` runs read prior learnings as grounding. The return arrow in the compound loop is the same mechanism as a learning loop: each cycle deposits knowledge that reduces the cost of the next.
- **Cortex Forge `/cortex-imprint`** — manual, session-to-wiki; captures durable insight rather than behavioral corrections. Complementary to `/cortex-crystallize` (state) — together they cover what `/ce-compound` handles in a single step.

## Connections
- Related concepts: [[wiki/concepts/commandcode-taste]], [[wiki/concepts/memory-system]], [[wiki/concepts/prompt-classification-hook]], [[wiki/concepts/handoff-artifact]], [[wiki/concepts/skill-self-improvement-loop]]

---

- 2026-06-12 [Claude Code]: Page created from Longform Guide ingestion
- 2026-07-01 [Claude Code]: Added implemented examples section — CommandCode TASTE, Compound Engineering /ce-compound, Cortex Forge /cortex-imprint
