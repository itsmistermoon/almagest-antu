---
title: Multi-agent analysis pipeline
type: concept
created: 2026-06-08
updated: 2026-06-08
tags: [multi-agent, pipeline, code-analysis, knowledge-graph, parallel]
aliases: [analysis pipeline, agent orchestration]
sources:
  - wiki/sources/understand-anything.md
confidence: high
---

# Multi-agent analysis pipeline

Patrón de orquestación donde un comando único dispara **N agentes especializados** que colaboran para analizar un corpus (código, wiki, documentación) y producir un artefacto estructurado (grafo, índice, reporte). Implementado por Understand Anything en `/understand` con 5-7 agentes.

## Estructura típica

**Comando orquestador** (`/understand`) que:
1. Recibe input (path del proyecto, scope, flags).
2. Pasa al `project-scanner` para descubrir archivos.
3. Distribuye trabajo a `file-analyzer`s **en paralelo** (batches de 20-30 archivos, hasta 5 concurrentes).
4. Consolida resultados en `architecture-analyzer` y `tour-builder`.
5. Valida con `graph-reviewer` (inline por defecto; opt-in para revisión LLM completa).
6. Persiste grafo final en JSON.

**Agentes opcionales según comando:**
- `domain-analyzer` → para `/understand-domain`.
- `article-analyzer` → para `/understand-knowledge` (wikis Karpathy).

## Lo que cada agente tiene

| Propiedad | Valor |
|-----------|-------|
| Rol | Una responsabilidad estrecha y nombrable |
| Input | Output del agente anterior, o subset del corpus |
| Output | Estructura validable (JSON, lista, índice) |
| Estado | Sin estado entre invocaciones (cada agente es stateless) |
| Validación | Heurística rápida inline; revisión LLM completa solo si `--review` |

## Por qué dividir en agentes en vez de un prompt monolítico

**Tres razones técnicas:**

1. **Paralelización real.** File analyzers corren concurrentemente. Un prompt monolítico es secuencial por construcción (la generación es lineal dentro de un context window).
2. **Context window manejable.** Cada agente opera sobre un batch pequeño (20-30 archivos). Un prompt monolítico que cargue todo el codebase revienta el context en proyectos medianos.
3. **Validación por capa.** El `graph-reviewer` puede detectar "este nodo no tiene edges, esta función está duplicada en dos archivos" sin contaminarse del trabajo de generación. Con un prompt monolítico, el validador y el generador compiten por el mismo context.

**Razón de diseño:**

4. **Composable.** Si cambias `file-analyzer` (e.g. para soportar un nuevo lenguaje), el resto del pipeline no se entera. Un prompt monolítico es frágil a cambios.

## Patrón de orquestación

No es un grafo DAG completo ni un loop reactivo. Es una **pipeline lineal con un fan-out** en el paso de file analyzers:

```
project-scanner
       ↓
   file-analyzer (×N paralelo, batches)
       ↓
   architecture-analyzer
       ↓
   tour-builder ←─┐
       ↓          │
   graph-reviewer ┘ (loop si falla validación)
       ↓
   output
```

`graph-reviewer` puede invocar de nuevo un sub-paso si detecta problemas (e.g. "faltan edges en estos 3 archivos" → re-dispara file-analyzer sobre ellos).

## Incremental

Si el corpus ya tiene un grafo previo, el `project-scanner` compara fingerprints (ver [[wiki/concepts/treesitter-llm-hybrid-parsing]]) y solo encola file-analyzer para archivos cuyo fingerprint cambió. Resultado: re-analizar un proyecto de 10k archivos después de editar 3 toma segundos, no horas.

**Trade-off:** el grafo previo debe confiarse como base estructural. Si hubo errores en runs anteriores, persisten. Por eso existe `--review` (re-validación completa) como opt-in.

## Cuándo NO usar este patrón

- **Corpus <100 archivos.** El overhead de orquestación no se amortiza. Un solo agente con buenos prompts funciona.
- **Análisis que requiere contexto global del corpus** (e.g. "explica la arquitectura del sistema entero"). Aquí los agentes especializados pierden el panorama; un solo agente con mucho contexto lo hace mejor.
- **Cuando los roles no se dividen limpiamente.** Si los "agentes" terminarían haciendo trabajo que se solapa, no son agentes — son prompts disfrazados.

## Aplicabilidad en el vault

El vault `cortex-forge` no implementa este patrón (su pipeline es single-agent: la skill `cortex-assimilate` lee → sintetiza → escribe). Podría aplicar a:

- `cortex-prune` si crece: dividir en `orphan-detector`, `link-validator`, `staleness-checker`, ejecutados en paralelo sobre `wiki/`.
- Análisis del vault completo con `/understand-knowledge` (tercer proyecto, vía Understand Anything).

---

- 2026-06-08 [CommandCode]: Página creada — concepto extraído del pipeline `/understand`, con énfasis en las razones técnicas del split (paralelización, context window, validación por capa) y los trade-offs del patrón
