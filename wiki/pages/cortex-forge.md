---
title: cortex-forge
type: project
created: 2026-06-08
updated: 2026-06-08
tags: [vault, multi-agent, hot-cache, hooks, knowledge-management]
status: active
repo: /Users/itsmistermoon/proyectos/cortex-forge
domains: [agent-orchestration, knowledge-management, multi-agent-protocols]
sources:
  - wiki/sources/commandcode-hooks-configuration.md
  - wiki/sources/codex-hooks.md
  - wiki/sources/antigravity-hooks.md
confidence: high
---

# cortex-forge

**Status:** active
**Repo:** /Users/itsmistermoon/proyectos/cortex-forge

## Goal

Vault con protocolo de hot cache que sincroniza contexto entre múltiples agentes (Claude Code, Codex, Antigravity, CommandCode) sin token bloat al inicio de sesión. El conocimiento sintetizado vive en `wiki/`; el contexto efímero por proyecto vive en `.hot/{project}.md`; los originales en `.raw/`.

## Stack / Technologies
- 5 capas: `.raw/`, `wiki/`, `.hot/`, `wiki/meta/`, `skills/`
- 4 tipos de página wiki: concepts, entities, sources, projects
- 6 skills de vault: assimilate, recall, prune, imprint, crystallize, forge-setup
- Hooks nativos (Stop/SessionStart) + fallback `AGENTS.md` (Capa 1) para agentes sin hook de inicio
- Scripts bash portables: `load-hot-cache*.sh` (input) y `update-hot-cache*.sh` (output)

## Key decisions

- **Capa 1 (AGENTS.md) + Capa 2 (hooks nativos)** son complementarias, no excluyentes. Capa 1 cubre agentes sin hook de inicio (CommandCode); Capa 2 es más confiable.
- **Hot cache corta en `## History`** — solo se inyecta `## Current state` al contexto. Decisión tomada 2026-06-08 tras observar que History llenaba tokens sin valor operativo.
- **Wire format oficial de CommandCode es anidado** (`hooks: [{ matcher, hooks: [{ type, command, timeout? }] }]`), distinto del plano de Claude Code/Codex. Scripts de hot cache no son drop-in entre agentes.
- **Project pages solo para proyectos del usuario** — entidades third-party (Understand Anything, Antigravity) van a `entities/`, no a `pages/`.
- **No retroescribir `.raw/`** — es inmutable. Cualquier corrección va en la página wiki que la referencia.

## Next steps

- [ ] Re-probar Antigravity CLI con Capa 2 verificada en sesión real
- [ ] Re-probar CommandCode como experimento de control post-Capa 1
- [ ] Probar `/understand-knowledge` sobre el vault propio (grafo de `wiki/`)
- [ ] Resolver pendientes de Fase 1 del ROADMAP.md para cada agente
- [ ] MOCs por área temática (Fase 3)

## Knowledge applied

- [[wiki/concepts/agent-hook-compatibility]] — Matriz de lifecycle hooks por agente
- [[wiki/concepts/progressive-disclosure-hooks]] — Carga just-in-time de contexto
- [[wiki/concepts/antigravity-hooks]] — Configuración específica de Antigravity
- [[wiki/concepts/karpathy-wiki-pattern]] — Wikis optimizados para consumo por LLM
- [[wiki/concepts/treesitter-llm-hybrid-parsing]] — Parser determinista + LLM para interpretaciones
- [[wiki/concepts/multi-agent-analysis-pipeline]] — Orquestación de N agentes especializados

## Recurring issues

- `cortex-recall` falla en todos los agentes probados durante sesión — caen en búsqueda manual pese a MANDATORY en `AGENTS.md`. Pendiente diagnosticar causa raíz común.
- Codex hooks apuntan a `~/.claude/hooks/` por convención pendiente; funcional pero no idiomático.
- Capa 2 de Antigravity instalada pero no verificada en sesión real.

## Sources

- [[wiki/sources/commandcode-hooks-configuration]] — Wire format y scopes de CommandCode
- [[wiki/sources/codex-hooks]] — Lifecycle y trust de Codex
- [[wiki/sources/antigravity-hooks]] — Configuración de Antigravity/Gemini CLI
- [[wiki/sources/gemini-cli-hooks-video]] — Video oficial hooks & skills
- [[wiki/sources/understand-anything]] — Patrón de grafos de conocimiento

---

- 2026-06-08 [CommandCode / MiniMax-M3]: Page created retroactively — vault ya activo desde 2026-06-07 pero sin project page; consolidado para habilitar project linking futuro
