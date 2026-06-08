---
title: Karpathy-pattern LLM wiki
type: concept
created: 2026-06-08
updated: 2026-06-08
tags: [wiki, knowledge-base, llm, second-brain, karpathy]
aliases: [Karpathy wiki, LLM-readable wiki, vault-as-llm-context]
sources:
  - wiki/sources/understand-anything.md
confidence: high
---

# Karpathy-pattern LLM wiki

Patrón de diseño de wikis/knowledge bases optimizados para ser **leídos y consultados por LLMs**, no solo por humanos. Formalizado informalmente por Andrej Karpathy en [gist #442a6bf555914893e9891c11519de94f](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

## Estructura canónica

- **`index.md`** como punto de entrada — el LLM lo lee primero para orientarse.
- **Wikilinks explícitos** `[[page-name]]` entre documentos — el parser determinista los extrae como edges del grafo.
- **Categorías/tags** declarados en frontmatter — el parser los extrae como metadatos.
- **Carpetas por tipo** (concept, entity, source, project) — navegación predecible.

## Qué lo distingue de un wiki tradicional

Un wiki humano (MediaWiki, Notion, Obsidian publish) optimiza para **lectura humana**: sidebar de navegación, búsqueda full-text, breadcrumbs. Un wiki Karpathy optimiza para **consumo por LLM**:

- Frontmatter estructurado (no HTML装飾).
- Títulos en H1 únicos por archivo (no múltiples H1).
- Compiled truth en prosa, no bullets decorativos.
- Changelog al pie para que un agente sepa qué ha cambiado.
- Wikilinks en texto plano, no en campos de metadata separados.

## El parser determinista

Un wiki Karpathy es **parseable sin LLM** por un script pequeño. La pipeline de Understand Anything lo hace así:

1. **Parser determinista** lee `index.md` + archivos en `wiki/`, extrae:
   - Wikilinks `[[...]]` → edges del grafo.
   - Categorías del frontmatter → tags visuales en el grafo.
   - Estructura de carpetas → clusters.

2. **LLM agent** complementa con:
   - Entidades no explícitamente linkeadas.
   - Claims implícitos entre páginas.
   - Resúmenes semánticos por nodo.

El resultado: **grafo navegable con base estructural reproducible** (los wikilinks son hechos objetivos) y **capa semántica subjetiva** (las inferencias del LLM son hipótesis etiquetables).

## Aplicabilidad directa

El vault `cortex-forge` ya implementa este patrón (ver [[wiki/index]]): index.md como entry point, frontmatter por página, `templates/` para tipo de página, categorías `wiki/concepts/`, `wiki/entities/`, `wiki/sources/`, `wiki/pages/`. Faltaría:

- Adoptar `[[wikilinks]]` explícitos (hoy hay pocos).
- Validar que el parser determinista puede extraer el grafo desde el filesystem actual.
- Evaluar `/understand-knowledge` para graficar el vault completo.

## Por qué funciona

**Trade-off fundamental:** un wiki humano premia la presentación (CSS, imágenes, navegación). Un wiki Karpathy premia la **recuperabilidad por máquina**. Para un vault cuyo consumidor principal es un agente, el segundo es estrictamente superior. El coste: la presentación es más austera, los wikilinks rompen en wikis grandes, y el diseño de la página está limitado por lo que un parser puede extraer.

## Lección transferible

> Si el consumidor primario del vault es un agente, optimiza el vault para el agente, no para el humano. La presentación es un subproducto de la estructura.

---

- 2026-06-08 [CommandCode]: Página creada — concepto extraído de la fuente Understand Anything, con contraste explícito entre el patrón Karpathy y wikis humanos tradicionales
