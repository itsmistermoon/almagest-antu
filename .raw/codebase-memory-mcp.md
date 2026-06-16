# codebase-memory-mcp — README

**Source:** https://github.com/DeusData/codebase-memory-mcp
**Fetched:** 2026-06-16
**Sanitize findings:** 5 long base64 strings (shields.io badge URLs — benign)

---

**The fastest and most efficient code intelligence engine for AI coding agents.** Full-indexes an average repository in milliseconds, the Linux kernel (28M LOC, 75K files) in 3 minutes. Answers structural queries in under 1ms. Ships as a single static binary for macOS, Linux, and Windows — download, run `install`, done.

High-quality parsing through tree-sitter AST analysis across all 158 languages, enhanced with **Hybrid LSP** semantic type resolution for Python, TypeScript/JavaScript/JSX/TSX, PHP, C#, Go, C, C++, Java, Kotlin, and Rust — producing a persistent knowledge graph of functions, classes, call chains, HTTP routes, and cross-service links. 14 MCP tools. Zero dependencies. Plug and play across 11 coding agents.

> **Research** — arXiv:2603.27277. Evaluated across 31 real-world repositories: 83% answer quality, 10× fewer tokens, 2.1× fewer tool calls vs. file-by-file exploration.

## Why codebase-memory-mcp

- **Extreme indexing speed** — Linux kernel (28M LOC, 75K files) in 3 minutes. RAM-first pipeline: LZ4 compression, in-memory SQLite, fused Aho-Corasick pattern matching.
- **Plug and play** — single static binary. No Docker, no runtime dependencies, no API keys.
- **158 languages** — vendored tree-sitter grammars compiled into the binary.
- **120x fewer tokens** — 5 structural queries: ~3,400 tokens vs ~412,000 via file-by-file search.
- **11 agents, one command** — `install` auto-detects Claude Code, Codex CLI, Gemini CLI, Zed, OpenCode, Antigravity, Aider, KiloCode, VS Code, OpenClaw, and Kiro.
- **Built-in graph visualization** — 3D interactive UI at `localhost:9749`.
- **14 MCP tools** — search, trace, architecture, impact analysis, Cypher queries, dead code detection, cross-service HTTP linking, ADR management.

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash
```

```bash
codebase-memory-mcp update
```

```bash
codebase-memory-mcp uninstall
```

## Features

### Graph & analysis
- Architecture overview: `get_architecture` — languages, packages, entry points, routes, hotspots, boundaries, layers, clusters
- Architecture Decision Records: `manage_adr`
- Louvain community detection
- Git diff impact mapping: `detect_changes` with risk classification
- Call graph across files and packages (import-aware, type-inferred)
- Dead code detection
- Cypher-like queries: `MATCH (f:Function)-[:CALLS]->(g) WHERE f.name = 'main' RETURN g.name`

### Search
- **Semantic search** (`semantic_query`): vector search with bundled Nomic `nomic-embed-code` embeddings (40K tokens, 768d int8) compiled into binary — no API key, no Ollama. 11-signal combined scoring.
- **BM25 full-text search** via SQLite FTS5 with `cbm_camel_split` tokenizer (camelCase/snake_case aware)
- **Structural search** (`search_graph`): regex name patterns, label filters, min/max degree, file scoping
- **Code search** (`search_code`): graph-augmented grep

### Cross-service linking
- HTTP route ↔ call-site matching with confidence scoring
- gRPC, GraphQL, tRPC service detection
- Channel detection (EMITS/LISTENS_ON) for Socket.IO, EventEmitter, pub-sub across 8 languages

### Edge types (selected)
- `CALLS`, `IMPORTS`, `DEFINES`, `IMPLEMENTS`, `INHERITS`
- `HTTP_CALLS`, `ASYNC_CALLS` (cross-service)
- `EMITS`, `LISTENS_ON` (channels)
- `DATA_FLOWS` with arg-to-param mapping + field access chains
- `SIMILAR_TO` (MinHash + LSH near-clone detection, Jaccard scored)
- `SEMANTICALLY_RELATED` (score ≥ 0.80)

## Graph Data Model

### Node Labels
`Project`, `Package`, `Folder`, `File`, `Module`, `Class`, `Function`, `Method`, `Interface`, `Enum`, `Type`, `Route`, `Resource`

### Edge Types
`CONTAINS_PACKAGE`, `CONTAINS_FOLDER`, `CONTAINS_FILE`, `DEFINES`, `DEFINES_METHOD`, `IMPORTS`, `CALLS`, `HTTP_CALLS`, `ASYNC_CALLS`, `IMPLEMENTS`, `HANDLES`, `USAGE`, `CONFIGURES`, `WRITES`, `MEMBER_OF`, `TESTS`, `USES_TYPE`, `FILE_CHANGES_WITH`

### Supported Cypher (openCypher read subset)
- Clauses: `MATCH`, `OPTIONAL MATCH`, `WHERE`, `WITH`, `RETURN`, `ORDER BY`, `SKIP`, `LIMIT`, `DISTINCT`, `UNWIND`, `UNION`/`UNION ALL`, `CASE`
- Aggregates: `count`, `sum`, `avg`, `min`, `max`, `collect`
- Read-only. Write/MERGE/CALL clauses unsupported.

## MCP Tools

### Indexing
| Tool | Description |
|------|-------------|
| `index_repository` | Index a repository into the graph |
| `list_projects` | List all indexed projects with node/edge counts |
| `delete_project` | Remove a project and all its graph data |
| `index_status` | Check indexing status of a project |

### Querying
| Tool | Description |
|------|-------------|
| `search_graph` | Structured search by label, name pattern, file pattern, degree |
| `trace_path` | BFS traversal — who calls a function and what it calls (depth 1-5) |
| `detect_changes` | Map git diff to affected symbols + blast radius with risk classification |
| `query_graph` | Execute Cypher-like graph queries (read-only) |
| `get_graph_schema` | Node/edge counts, relationship patterns, property definitions per label |
| `get_code_snippet` | Read source code for a function by qualified name |
| `get_architecture` | Codebase overview: languages, packages, routes, hotspots, clusters, ADR |
| `search_code` | Grep-like text search within indexed project files |
| `manage_adr` | CRUD for Architecture Decision Records |
| `ingest_traces` | Ingest runtime traces to validate HTTP_CALLS edges |

## Team-Shared Graph Artifact

`.codebase-memory/graph.db.zst` — zstd-compressed snapshot committed to the repo. Teammates skip full reindex; incremental indexing fills local diff on first connection.

- Best tier: `zstd -9` + index strip + `VACUUM INTO` — written on explicit `index_repository`
- Fast tier: `zstd -3` — written by watcher for low-latency incremental updates
- `.gitattributes` `merge=ours` auto-created to avoid merge conflicts on binary artifact

## Hybrid LSP

Tree-sitter alone gives a syntactic AST; it can't resolve cross-module types. codebase-memory-mcp ships a lightweight C implementation of language type-resolution algorithms (inspired by tsserver, pyright, gopls, Roslyn, Eclipse JDT, rust-analyzer) embedded in the static binary. No language server process, no per-project setup.

**Two-layer architecture:**
1. Tree-sitter pass — syntactic, runs for all 158 languages
2. Hybrid LSP pass — type-aware, refines call edges using import graph + cross-file definition registry

Languages: Python, TypeScript/JS/JSX/TSX, PHP, C#, Go, C/C++, Java, Kotlin, Rust.

## Performance

| Operation | Time | Notes |
|-----------|------|-------|
| Linux kernel full index | 3 min | 28M LOC, 75K files → 4.81M nodes, 7.72M edges |
| Django full index | ~6s | 49K nodes, 196K edges |
| Cypher query | <1ms | |
| Name search (regex) | <10ms | |
| Dead code detection | ~150ms | Full graph scan |
| Trace call path (depth=5) | <10ms | BFS |

Token efficiency: ~3,400 tokens vs ~412,000 via file-by-file (99.2% reduction).

## Configuration

```bash
codebase-memory-mcp config set auto_index true
codebase-memory-mcp config set auto_index_limit 50000
```

### Environment Variables
| Variable | Default | Description |
|----------|---------|-------------|
| `CBM_CACHE_DIR` | `~/.cache/codebase-memory-mcp` | Database storage directory |
| `CBM_DIAGNOSTICS` | `false` | Enable diagnostics output |
| `CBM_LOG_LEVEL` | `info` | `debug`/`info`/`warn`/`error`/`none` |
| `CBM_WORKERS` | detected | Override parallel-indexing worker count |

## Installation

One-line (macOS/Linux):
```bash
curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash
```

Available on: npm, PyPI, Homebrew, Scoop, Winget, Chocolatey, AUR, `go install`.

Manual MCP config (`~/.claude/.mcp.json`):
```json
{
  "mcpServers": {
    "codebase-memory-mcp": {
      "command": "/path/to/codebase-memory-mcp",
      "args": []
    }
  }
}
```

## Multi-Agent Support

| Agent | MCP Config | Instructions | Hooks |
|-------|-----------|-------------|-------|
| Claude Code | `.claude/.mcp.json` | 4 Skills | PreToolUse (Grep/Glob graph augment, non-blocking) |
| Codex CLI | `.codex/config.toml` | `.codex/AGENTS.md` | SessionStart reminder |
| Gemini CLI | `.gemini/settings.json` | `.gemini/GEMINI.md` | BeforeTool + SessionStart reminder |
| Zed | `settings.json` | — | — |
| OpenCode | `opencode.json` | `AGENTS.md` | — |
| Aider | — | `CONVENTIONS.md` | — |
| KiloCode | `mcp_settings.json` | `~/.kilocode/rules/` | — |

Hooks are structurally non-blocking (exit code 0, every failure path). PreToolUse for Claude Code intercepts Grep/Glob (never Read — gating Read breaks read-before-edit invariant) and injects structured context via `search_graph` as `additionalContext`.

## Security

- VirusTotal scan (70+ AV engines) per release
- SLSA Level 3 cryptographic build provenance
- Sigstore cosign keyless signatures
- SHA-256 checksums
- CodeQL SAST
- Zero runtime dependencies — all libraries vendored at compile time

## Architecture

```
src/
  main.c           Entry point (MCP stdio server + CLI + install/update/config)
  mcp/             MCP server (14 tools, JSON-RPC 2.0, session detection, auto-index)
  cli/             Install/uninstall/update/config (10 agents, hooks, instructions)
  store/           SQLite graph storage (nodes, edges, traversal, search, Louvain)
  pipeline/        Multi-pass indexing
  cypher/          Cypher query lexer, parser, planner, executor
  watcher/         Background auto-sync (git polling, adaptive intervals)
  ui/              Embedded HTTP server + 3D graph visualization
internal/cbm/      Vendored tree-sitter grammars (158 languages) + AST extraction
```

## License
MIT
