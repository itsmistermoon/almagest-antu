---
title: Progressive Disclosure via Hooks
type: concept
created: 2026-06-08
updated: 2026-06-08
tags: [hooks, skills, context-management, token-efficiency]
aliases: [just-in-time context, lazy context loading]
sources:
  - wiki/sources/gemini-cli-hooks-video.md
confidence: medium
---

# Progressive Disclosure via Hooks

Patrón de carga de contexto que evita inyectar todo al inicio de sesión y en cambio carga información solo cuando es relevante para la tarea actual.

## El problema que resuelve

Cargar todo el contexto disponible al iniciar una sesión tiene dos costos:
- **Tokens consumidos** antes de que el usuario haga su primera pregunta
- **Ruido en el contexto**: información irrelevante compite con la información relevante

## El patrón

En lugar de un archivo de instrucciones monolítico que se carga siempre completo, se distribuye el contexto entre hooks y skills:

- **Hooks (SessionStart)**: cargan solo el estado mínimo necesario — pendientes, decisiones activas, contexto frágil (hot cache)
- **Skills**: cargan expertise específico cuando se activan para una tarea concreta; permanecen inactivas (sin consumir contexto) hasta que se necesitan

## Aplicación en Cortex Forge

La separación entre hot cache y wiki es una instancia de este patrón:
- El hot cache (`## Current state` únicamente) se inyecta al inicio — es el mínimo viable
- El contenido de `wiki/` se carga bajo demanda vía `cortex-recall` cuando el usuario consulta sobre un tema
- La History del hot cache **no** se inyecta (fue el fix del 2026-06-08 a `load-hot-cache.sh`)

## Tensión con visibilidad

En Codex, el contexto inyectado por hooks es visible en el chat (`hook context:`). El patrón de progressive disclosure reduce el impacto de esta visibilidad al minimizar el volumen inyectado — menos ruido visible, menos tokens consumidos.

## Connections
- Related concepts: [[wiki/concepts/agent-hook-compatibility]], [[wiki/concepts/antigravity-hooks]]

---

- 2026-06-08 [Claude Code]: Página creada — concepto extraído del video de Gemini CLI hooks; instanciado en el fix de History del hot cache
