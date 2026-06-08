---
title: Understand Anything
type: source
created: 2026-06-08
updated: 2026-06-08
tags: [codebase-analysis, knowledge-graph, multi-agent, ai-tooling, karpathy-wiki]
aliases: [Understand-Anything, UA, Lum1104/Understand-Anything]
sources:
  - .raw/understand-anything.md
confidence: high
---

# Understand Anything

Plugin multi-plataforma que convierte un codebase, knowledge base o documentación en un **grafo de conocimiento interactivo** explorable, buscable y consultable. Compatible con Claude Code, Codex, Cursor, Copilot, Gemini CLI, OpenCode, Vibe CLI, Trae, Hermes, Cline, KIMI CLI y Antigravity.

**Origen:** [github.com/Lum1104/Understand-Anything](https://github.com/Lum1104/Understand-Anything) — MIT License, Lum1104.
**Ingestado:** 2026-06-08 desde README principal (350 líneas).

## Qué ofrece

- **Grafo estructural** de archivos, funciones, clases y dependencias — navegable, buscable, con resúmenes en lenguaje natural por nodo.
- **Vista de dominio** que mapea código a procesos de negocio (dominios, flujos, pasos).
- **Análisis de knowledge bases tipo Karpathy** — extrae wikilinks, categorías, entidades, claims y relaciones implícitas.
- **Tours guiados** autogenerados, búsqueda fuzzy + semántica, análisis de impacto de diffs, UI adaptativa por persona (junior dev / PM / power user), visualización por capas arquitectónicas, callouts de 12 patrones de programación.

## Comandos principales

| Comando | Función |
|---------|---------|
| `/understand` | Pipeline multi-agente que escanea el proyecto y construye el grafo → `.understand-anything/knowledge-graph.json` |
| `/understand-dashboard` | Abre el dashboard web interactivo |
| `/understand-chat {query}` | Pregunta libre sobre el codebase |
| `/understand-diff` | Impacto de cambios no commiteados |
| `/understand-explain {path}` | Deep-dive en un archivo o función |
| `/understand-onboard` | Genera guía de onboarding para nuevos miembros |
| `/understand-domain` | Extrae conocimiento de dominio de negocio |
| `/understand-knowledge {path}` | Analiza un wiki tipo Karpathy |

Soporta incremental (solo re-analiza archivos cambiados), scoped subdirectory, idioma configurable (`--language zh|ja|ko|ru|...`), y post-commit hook con `--auto-update`.

## Arquitectura interna

**Híbrido tree-sitter + LLM.** El lado determinista (tree-sitter) parsea sintaxis, extrae imports/exports/definiciones/herencia, construye un `importMap` pre-resuelto, y hace fingerprint-based change detection. El lado semántico (LLM) produce resúmenes, tags, asignación de capa arquitectónica, mapeo de dominio de negocio, tours guiados y callouts de conceptos.

**Pipeline multi-agente (5 agentes base + 1 para dominio + 1 para knowledge base):**

| Agente | Rol |
|--------|-----|
| `project-scanner` | Descubrir archivos, detectar lenguajes y frameworks |
| `file-analyzer` | Extraer funciones, clases, imports; producir nodos y edges |
| `architecture-analyzer` | Identificar capas arquitectónicas |
| `tour-builder` | Generar tours guiados de aprendizaje |
| `graph-reviewer` | Validar completitud e integridad referencial (inline por defecto; `--review` para revisión LLM completa) |
| `domain-analyzer` | Extraer dominios, flujos y pasos (usado por `/understand-domain`) |
| `article-analyzer` | Extraer entidades, claims y relaciones implícitas (usado por `/understand-knowledge`) |

File analyzers corren en paralelo (hasta 5 concurrentes, batches de 20-30 archivos).

## Compatibilidad multi-plataforma

| Plataforma | Estado | Instalación |
|------------|--------|-------------|
| Claude Code | Nativo | Plugin marketplace |
| Cursor | Auto-discovery | `.cursor-plugin/plugin.json` |
| VS Code + Copilot | Auto-discovery | `.copilot-plugin/plugin.json` |
| Copilot CLI | Soportado | `copilot plugin install` |
| Codex, OpenCode, Antigravity, Gemini CLI, Pi Agent, Vibe CLI, Hermes, Cline, KIMI CLI, Trae | Soportado | `curl … install.sh \| bash -s <platform>` |

## Modelo de compartición del grafo

El grafo es JSON puro. Se commitea una vez y el equipo lo consume sin re-ejecutar el pipeline. Ignorar `.understand-anything/intermediate/` y `.understand-anything/diff-overlay.json` (scratch local). Para grafos >10 MB usar **git-lfs**.

## Relevance para el vault

Tres áreas de transferencia directa a proyectos del usuario:

1. **Patrón Karpathy wiki** — la skill `cortex-assimilate` produce páginas que podrían alimentar `/understand-knowledge` para graficar el vault completo.
2. **Híbrido tree-sitter + LLM** — patrón replicable para análisis incremental de código.
3. **Matriz de compatibilidad multi-plataforma** — solapa con [[wiki/concepts/agent-hook-compatibility|Agent Hook Compatibility]] (la del vault sobre lifecycle hooks). Ambas mantienen una matriz plataforma × evento, pero esta mide instalación del plugin; la del vault mide hooks de lifecycle.

---

- 2026-06-08 [CommandCode]: Página creada — síntesis del README principal (350 líneas, descargado a `.raw/understand-anything.md`)
