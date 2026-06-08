---
title: Tree-sitter + LLM hybrid parsing
type: concept
created: 2026-06-08
updated: 2026-06-08
tags: [parsing, code-analysis, hybrid, ast, llm, fingerprint]
aliases: [hybrid parsing, deterministic + semantic parsing]
sources:
  - wiki/sources/understand-anything.md
confidence: high
---

# Tree-sitter + LLM hybrid parsing

Patrón de análisis de código que divide el trabajo entre un **parser determinista** (tree-sitter) y un **LLM semántico** según lo que cada uno hace mejor. Aplicado por Understand Anything en su pipeline `/understand`.

## El split

**Tree-sitter (determinista)** — produce los **hechos objetivos** del código:

- Árbol de sintaxis concreta (CST).
- Imports, exports, definiciones de funciones/clases.
- Call sites, herencia, type signatures.
- `importMap` pre-resuelto.
- Fingerprints estructurales para change detection incremental.

**Misma entrada → misma salida, siempre.** Reproducible por construcción.

**LLM (semántico)** — produce las **interpretaciones** que el parser no puede:

- Resúmenes en lenguaje natural de qué hace cada función.
- Tags semánticos (e.g. "auth-handler", "payment-flow").
- Asignación de capa arquitectónica (API, Service, Data, UI, Utility).
- Mapeo a dominio de negocio.
- Tours guiados de aprendizaje.
- Callouts de conceptos de programación en contexto.

**Misma entrada → salidas que pueden variar** entre runs (depende del modelo, temperatura, prompt).

## Por qué el split es importante

Si delegas todo al LLM:
- Pierdes reproducibilidad estructural (mismas funciones podrían mapearse a nodos distintos entre runs).
- Gastas tokens re-derivando hechos que el parser ya conoce.
- No puedes hacer incremental fiable (¿qué cambió?).

Si delegas todo al parser:
- No tienes resúmenes.
- No puedes inferir intención.
- No hay mapping a dominio de negocio.

**El split da:**
- Reproducibilidad estructural (los edges son hechos).
- Semántica variable pero etiquetable (los resúmenes son hipótesis).
- Incremental fiable vía fingerprinting estructural (solo re-analiza archivos cuyo CST cambió).

## Pre-resolución de imports

Detalle clave del diseño: tree-sitter **no solo** extrae `import x from y` — **resuelve** `x` contra el `importMap` del proyecto completo y pasa el mapa pre-resuelto a los file analyzers. Resultado: el LLM no re-deriva dependencias; consume un grafo de imports ya materializado.

**Trade-off:** coste upfront del scan completo del proyecto. Beneficio: ahorro de tokens en cada archivo analizado (lo cual escala mal sin esto).

## Fingerprinting para incremental

Tree-sitter produce un hash estructural del CST (no del texto fuente). Si el código se reformatea sin cambios semánticos (e.g. prettier), el fingerprint **no cambia** y no se re-analiza. Si se cambia un `import`, el fingerprint cambia y se re-analiza solo el archivo afectado.

**Lección:** hashear la **forma semántica**, no el texto crudo. El texto es presentación; la forma es lo que importa para el análisis.

## Aplicabilidad transferible

El patrón es replicable en cualquier sistema que analice código + documentación:

- **Documentación:** parser markdown (remark/markdown-it) extrae estructura, LLM extrae intención.
- **Wikis:** parser de wikilinks + frontmatter (ver [[wiki/concepts/karpathy-wiki-pattern]]) extrae edges, LLM extrae claims implícitos.
- **Logs/queries:** parser regex/AST extrae hechos, LLM extrae causalidad.

**Regla:** el parser maneja **lo que es verificable**; el LLM maneja **lo que requiere interpretación**. Mezclar las dos responsabilidades en una sola capa (todo al LLM, o todo a regex) es la causa más común de pipelines de análisis que no escalan.

---

- 2026-06-08 [CommandCode]: Página creada — concepto extraído de la arquitectura interna de Understand Anything, con énfasis en las decisiones de diseño (pre-resolución, fingerprinting estructural) que lo hacen eficiente
