---
title: AI Engineering Workflow — Matt Pocock Framework
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [ai, workflow, engineering-fundamentals, matt-pocock, compiled]
---

# AI Engineering Workflow — Matt Pocock Framework

## Tesis central

Los fundamentos de ingeniería de software importan más que nunca. Las prácticas que funcionan con humanos (PRDs, TDD, code review, módulos profundos) también funcionan con IA. El codebase influye más en el output de la IA que cualquier prompt o AGENTS.md.

## Stack de skills de Matt

| Skill | Categoría | Propósito |
|-------|-----------|-----------|
| **Grill me** | Productivity | Grill session para cualquier cosa *no-codebase* (planes, ideas, decisiones de vida) |
| **Grill with docs** | Engineering | Grill session para codebases. Reemplazó a ubiquitous-language. Genera CONTEXT.md + ADRs |
| **Write PRD** | Engineering | Transforma la sesión de grill en un PRD estructurado |
| **To issues** | Engineering | Trocea el PRD en issues (tracker-agnostic: GitHub, GitLab, local markdown, custom) |
| **To PRD** | Engineering | Convierte contexto de conversación en PRD y lo publica al issue tracker |
| **Triage** | Engineering | State machine para issues entrados por otros. Labels: need-info → maintainer-review → ready-for-afk |
| **TDD** | Engineering | Red-green-refactor para coding agents |
| **Diagnose** | Engineering (experimental) | 4 etapas para bugs complejos: gather info → form hypotheses → test → fix |
| **Improve codebase architecture** | Engineering | Alinea el codebase con el vocabulario de CONTEXT.md y ADRs. Vocabulario: Module, Interface, Implementation, Depth, Seams, Adapters, Leverage, Locality |
| **Setup Matt Pocock skills** | Engineering | Scaffolding per-repo: issue tracker, triage labels, domain docs en CLAUDE.md |
| **Find skills** | Productivity | Descubre skills instalables |
| **Ralph** | (externo) | Loop autónomo no incluido en el skills repo (es un script aparte) |

## Las 7 fases

1. **Idea** — trigger del proceso (bug, feature, refactor)
2. **Research** — cachear conocimiento externo en `research.md` (vive solo lo que dura el sprint)
3. **Prototype** — HITL para imponer taste (UI, arquitectura, servicios externos)
4. **PRD** — documento destino, producto de una grill session
5. **Implementation Plan** — Kanban de issues con relaciones de bloqueo
6. **Execution** — Ralph loop (AFK) o HITL
7. **QA** — agente genera QA plan, humano ejecuta, produce más issues → loop

Las fases 5-6-7 se ciclan hasta llegar a producto terminado.

## Deep modules + gray box architecture

Tomado de *A Philosophy of Software Design* (John Ousterhout): módulos con mucha implementación detrás de una interfaz simple y controlada. La interfaz es el contrato público; el interior lo puede manejar la IA. Tests sólidos amarran el comportamiento. El humano controla el interfaz y el taste; la IA hace la implementación táctica.

## Ralph loop

Un solo prompt que se repite. El agente:
1. Lee el PRD (destino) y el progress file (qué falta)
2. Pesa una tarea del Kanban
3. La implementa
4. Corre tests + types
5. Commitea
6. Repite hasta que no queden tareas → emite `RALPH_DONE` sigil

Progresión: HITL (pair programming con IA) → AFK (autónomo, notificación vía WhatsApp cuando termina).

## Ubiquitous language → CONTEXT.md + ADRs

El viejo `ubiquitous-language.md` está deprecado. Ahora `grill-with-docs` genera:

- **`CONTEXT.md`** — lenguaje compartido del dominio. Soporta múltiples bounded contexts (ej: `ordering/CONTEXT.md`, `billing/CONTEXT.md`).
- **ADRs** (Architectural Decision Records) — se crean cuando: (1) resultado de un trade-off real, (2) no obvio, (3) impacto duradero. Alinean al humano y la IA en decisiones no obvias.

`improve-codebase-architecture` lee CONTEXT.md y ADRs para no sugerir ideas ya descartadas.

## Fuentes

- [[wiki/sources/full-walkthrough-workflow-ai-coding-matt-pocock]] — Workshop práctico de 2 horas
- [[wiki/sources/codebase-not-ready-for-ai-matt-pocock]] — Deep modules para IA
- [[wiki/sources/software-fundamentals-matter-more-than-ever-matt-pocock]] — Keynote: la tesis
- [[wiki/sources/real-world-feature-build-claude-code-matt-pocock]] — Demo real (ghost lessons)
- [[wiki/sources/getting-started-with-ralph]] — Setup de Ralph
- [[wiki/sources/tips-for-ai-coding-with-ralph-wiggum]] — 11 tips para Ralph
- [[wiki/sources/7-phases-ai-driven-development-matt-pocock]] — Las 7 fases
- [[wiki/sources/tdd-red-green-refactor-claude-code-matt-pocock]] — TDD con IA
- [[wiki/sources/skills-changelog-ubiquitous-language-grill-with-docs]] — Changelog Abril 2026: ubiquitous-language → grill-with-docs, ADRs, repo reorganization

---

- 2026-06-02: Página creada compilando 8 fuentes de Matt Pocock
