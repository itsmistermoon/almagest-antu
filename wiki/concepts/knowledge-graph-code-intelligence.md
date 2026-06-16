---
title: Knowledge Graph Code Intelligence
type: concept
created: 2026-06-16
updated: 2026-06-16
tags: [code-intelligence, knowledge-graph, mcp, ai-agents, tree-sitter]
aliases: [code graph, structural code analysis]
sources:
  - wiki/sources/codebase-memory-mcp.md
confidence: high
schema_version: "0.3"
---

# Knowledge Graph Code Intelligence

A structural analysis approach where a codebase is parsed into a persistent property graph — nodes for functions, classes, files, routes; edges for call relationships, imports, inheritance, HTTP links — and AI agents query that graph instead of reading source files directly.

## Core idea

File-by-file exploration (grep → read → grep → read) consumes tokens proportional to the content read. A pre-built graph makes structural questions O(1) queries: "what calls X?" → BFS traversal, not 50 grep/read cycles. codebase-memory-mcp benchmarks show ~3,400 tokens for 5 structural queries vs. ~412,000 via file-by-file — 99.2% reduction.

## Two-layer parsing architecture

Mature implementations use two layers:

1. **Syntactic layer** (tree-sitter) — fast, language-agnostic AST extraction. Covers 158 languages with vendored grammars. Handles naming, structure, call sites.
2. **Semantic layer** (Hybrid LSP) — type-aware resolution on top of the AST. Resolves cross-module types, generics, inheritance chains. Structurally mirrors language server algorithms (pyright, tsserver, gopls, Roslyn, rust-analyzer) but runs embedded in the indexer — no external language server process per project.

Without the semantic layer, `user.profile.display_name()` remains an unresolved call site. With it, it resolves to `Profile.display_name` three modules away.

## Graph data model (codebase-memory-mcp)

**Node labels:** `Project`, `Package`, `Folder`, `File`, `Module`, `Class`, `Function`, `Method`, `Interface`, `Enum`, `Type`, `Route`, `Resource`

**Edge types (selected):**
- `CALLS` / `HTTP_CALLS` / `ASYNC_CALLS` — call relationships
- `IMPORTS` / `IMPLEMENTS` / `INHERITS` — dependency structure
- `EMITS` / `LISTENS_ON` — pub-sub channel detection
- `DATA_FLOWS` — arg-to-param + field access chains
- `SIMILAR_TO` — MinHash + LSH near-clone detection
- `SEMANTICALLY_RELATED` — vector similarity ≥ 0.80

## Team-shared graph artifact

A compressed snapshot (e.g., `.codebase-memory/graph.db.zst`) committed to the repo lets teammates skip the full reindex — incremental indexing fills the local diff on first connection. The artifact uses `merge=ours` in `.gitattributes` to avoid merge conflicts on the binary file.

## Agent integration pattern

Agents don't need to change their interface. A `PreToolUse` hook intercepts `Grep`/`Glob` calls and injects graph query results as `additionalContext` — structured context alongside the normal search results. Critical constraint: never intercept `Read` (breaks the read-before-edit invariant). All hook failure paths exit 0 (non-blocking).

## Relation to graphify

[[wiki/entities/graphify]] uses a similar team-shared artifact concept (`graphify-out/` directory), but targets a different scope. [[wiki/entities/codebase-memory-mcp]] is the MCP-native, multi-language, zero-dependency alternative with 14 querying tools and a Cypher-like query language. The agent integration pattern (hook intercepts search calls, injects graph context) parallels [[wiki/concepts/multi-agent-analysis-pipeline]] at the single-agent level.

---

- 2026-06-16 [Claude Code]: Page created from codebase-memory-mcp README ingestion
