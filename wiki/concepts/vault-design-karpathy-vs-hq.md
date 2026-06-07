---
title: Vault design — Karpathy LLM Wiki vs. Productive Setups HQ
type: concept
created: 2026-06-06
updated: 2026-06-06
tags: [vault-design, llm, pkm, second-brain, cortex-forge, knowledge-management]
---

# Vault design — Karpathy LLM Wiki vs. Productive Setups HQ

Análisis comparativo de dos referencias de diseño para [[wiki/pages/cortex-forge]], con evaluación del estado actual del vault y gaps accionables.

## Modelos mentales distintos

**Karpathy** asume un yo *epistémico*: el problema no es la adquisición de conocimiento sino su acumulación estructurada. El LLM tiene agencia sobre la estructura — decide qué páginas crear, cómo actualizar entidades, qué contradicciones señalar. Fuera de scope: todo lo relativo a acción (tareas, hábitos, fechas). El wiki es un artefacto de comprensión, no de planificación.

**HQ** asume un yo *ejecutivo*: el problema es la ejecución fallida, no el conocimiento incompleto. HQ acumula información sobre el comportamiento del usuario — qué hizo, cuánto tardó, qué movió la aguja. Fuera de scope: síntesis del mundo exterior, cross-references entre ideas. Un libro en HQ tiene review de 5 estrellas; en Karpathy actualiza páginas de conceptos y entidades.

La diferencia estructural: en Karpathy el LLM tiene agencia sobre la estructura del conocimiento; en HQ el humano tiene agencia total y el LLM no existe. cortex-forge eligió el modelo Karpathy — lo que hace que importar mecánicas de HQ requiera adaptación, no trasplante.

## Estado del vault vs. objetivos de JP

**Objetivo 1 — memoria y contexto caliente para agentes:** bien resuelto en protocolo (`.hot/`, hooks, skill), incompleto en contenido. Falta especificar qué debe contener un buen `.hot/` (qué decisiones, qué pendientes, qué necesita el próximo agente). Falta señal de staleness: contexto de hace 6 semanas se lee como fresco.

**Objetivo 2 — construir conocimiento para proyectos:** parcialmente resuelto. El ingest funciona. Lo que falta: cuando se ingesta algo relevante para loyalty-platform o imaq-news, esa conexión no se materializa en `wiki/pages/{proyecto}.md`. El conocimiento existe pero no fluye hacia donde se necesita operacionalmente.

**Tensión interna:** los dos objetivos tienen cadencias distintas. El hot cache envejece; el wiki no debería envejecer. Lo que falta es una tercera capa: **estado del proyecto** como distinto del conocimiento sobre el dominio. Existe parcialmente en `wiki/pages/` pero sin la estructura operacional que haría esa distinción clara.

## Gaps accionables (de Karpathy)

- **`wiki/meta/log.md` ausente** — registro append-only de operaciones del vault; permite al próximo agente entender el estado sin leer todas las páginas
- **Queries valiosas no se archivan** — las respuestas de análisis deberían terminar como páginas wiki (`cortex-recall` responde y descarta)
- **Provenance en writes ausente** — el frontmatter tiene `updated:` pero no `sources:` ni `confidence:`; crítico con múltiples agentes

## Gaps accionables (de HQ)

- **Bottleneck tracking** — cuando un agente detecta un problema recurrente en un proyecto, no hay mecanismo para generar una entrada de acción en `.hot/` o `wiki/pages/{proyecto}.md`
- **Trazabilidad inversa** — no hay forma de marcar que una página wiki fue usada en una decisión real de un proyecto; sin esa señal es imposible saber qué conocimiento es fértil y qué es archivo muerto

## Deuda de protocolo multi-agente

Ni Karpathy ni HQ modelan un vault asíncrono con múltiples agentes. Karpathy asume un solo LLM; HQ asume un solo humano. Cuando Claude Code, Codex, etc. escriben en el mismo wiki en sesiones independientes, `.hot/` es el único mecanismo anti-conflicto — y está gitignoreado. Deuda a resolver si el proyecto crece.

---

- 2026-06-06: Página creada — síntesis del análisis comparativo de sesión
