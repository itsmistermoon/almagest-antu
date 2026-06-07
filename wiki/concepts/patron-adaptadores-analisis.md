---
title: Patrón de Adaptadores para Análisis
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [arquitectura, patrones, python, sqlite, mcp]
aliases: [adapter-pattern-analytics, imaq-insights-arch]
---

# Patrón de Adaptadores para Análisis

Arquitectura del proyecto [[wiki/pages/imaq-insights|imaq-insights]] donde cada fuente de datos tiene su propio conector que transforma datos al schema normalizado. El análisis downstream es agnóstico de la fuente.

## Principio

> Cada fuente (Instagram CSV, Windsor.ai, loyalty-platform) implementa una interfaz común de ingesta. Agregar una fuente nueva es escribir un adaptador nuevo, no modificar el pipeline.

## Implementación

```
Fuente externa → adapter → SQLite ← MCP server ← Claude Code
                              ↓
                         reporte HTML mensual
```

El **MCP server** expone la base de datos SQLite a Claude Code mediante el protocolo Model Context Protocol. Claude ejecuta consultas SQL internamente en respuesta a preguntas en lenguaje natural.

## Schema normalizado (SQLite)

- **`posts`** — fuente agnóstica (id, source, published_at, format, caption, category)
- **`post_metrics`** — métricas por post
- **`import_batches`** — tracking de importaciones
- **`taxonomy`** — categorías definidas por usuario

## Ventajas

- Cada fuente se integra sin tocar el pipeline de análisis
- El schema es estable; los adaptadores son los que cambian
- Claude Code puede consultar todo con el mismo MCP server independientemente de la fuente

---

- 2026-06-02: Página creada — síntesis de PRD.md y arquitectura de imaq-insights
