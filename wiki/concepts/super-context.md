---
title: Super Context
type: concept
created: 2026-06-26
updated: 2026-06-26
tags: [session-start, context-injection, harness, cold-start]
aliases: [supercontext, super-context, context-scout]
sources:
  - wiki/sources/openhuman-super-context.md
confidence: high
schema_version: "0.3"
---

# Super Context

A harness-level pattern that eliminates agent cold starts by deterministically preparing context before the model reads the user's first message, rather than relying on the model to decide whether and when to fetch context.

## The problem

Most agents start every session blank. If context retrieval is exposed as a tool, the model must decide to call it — adding a round-trip, spending tokens on the decision, and depending on the model choosing correctly. Even when the model decides well, the first reply is already partially uninformed.

## The pattern

On the first turn of a new thread:

1. A read-only **context scout** sub-agent (spawned by the harness, not the model) sweeps available memory: notes, workspace files, connected data sources.
2. The scout assembles a bounded **context bundle** tagged with an envelope (`[context_bundle]…[/context_bundle]`).
3. The bundle is validated. If well-formed, it is prepended to the user's message before the orchestrator model sees the turn.
4. The orchestrator model answers already grounded in context.

Key properties:
- **Deterministic** — the harness always runs this; the model cannot skip it.
- **Read-only scout** — prevents injection or side effects at bootstrap.
- **Graceful degradation** — malformed, empty, or absent bundle → cold start, not garbage injection.
- **Dedup suppression** — the `agent_prepare_context` tool is suppressed for that turn to avoid repeating the work.

## Cortex Forge equivalent

Cortex Forge implements the same guarantee via a different mechanism: the `SessionStart` hook (OS-level script executed by the agent runtime) reads `.hot/MEMORY.md` and injects it into the session before the agent reads the user's prompt. The functional result is identical — the agent is never cold — but the execution layer differs:

| | OpenHuman SuperContext | Cortex Forge |
|---|---|---|
| **Execution layer** | Harness-internal (Python/Rust app) | OS-level hook script (bash) |
| **Context source** | Memory Tree (auto-fetched from integrations) | `.hot/MEMORY.md` (agent-synthesized from wiki) |
| **Scout** | Dedicated read-only sub-agent | Not applicable — file read is direct |
| **Portability** | OpenHuman-only | Any agent with a SessionStart hook |
| **Content origin** | Automatic (integrations pull data) | Manual / agent-synthesized (cortex-crystallize) |

## When to use this pattern

Any agent system where:
- Sessions are stateless by default
- The relevant context is known in advance (not discovered mid-conversation)
- Token budget at session start is more constrained than mid-session
- Model reliability in calling "prepare context" tools is below acceptable threshold

## See also

- [[wiki/concepts/progressive-disclosure-hooks]] — complementary: loads context just-in-time for specific queries rather than upfront
- [[wiki/concepts/handoff-artifact]] — `.hot/MEMORY.md` as the Cortex Forge instance of the context bundle
- [[wiki/concepts/memory-system]] — broader pattern of which super-context is a session-start component
- [[wiki/entities/openhuman]] — origin of the term and reference implementation

---

- 2026-06-26 [Claude Code]: Concept created from OpenHuman SuperContext feature article; Cortex Forge equivalence mapped
