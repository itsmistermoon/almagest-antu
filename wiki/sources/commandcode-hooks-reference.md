---
title: Hooks Reference - Command Code
type: source
created: 2026-06-08
updated: 2026-06-08
tags: [commandcode, hooks, reference, wire-format, exit-codes]
source_url: https://commandcode.ai/docs/hooks/reference
source_date:
source_author: CommandCode
sources:
  - .raw/commandcode-hooks-reference.md
confidence: high
---

# Hooks Reference - Command Code

**URL:** https://commandcode.ai/docs/hooks/reference
**Author:** CommandCode

## Summary

Referencia técnica completa del sistema de hooks de CommandCode. Define la estructura de datos HookDefinition/HookEntry, los tres tipos de eventos (PreToolUse, PostToolUse, Stop), el wire format de entrada/salida (JSON en stdin/stdout), los campos de control de comportamiento y la semántica de exit codes.

## Key ideas

1. Wire format de entrada: JSON en stdin con session context, tool details y environment info. Salida: JSON en stdout con campos opcionales `continue`, `systemMessage`, `permissionDecision`, `decision`, `additionalContext`.
2. Exit codes: `0` → ejecutar JSON output; `2` → bloquear (PreToolUse) / reintentar (PostToolUse/Stop); otros → error no bloqueante.
3. Tres eventos: `PreToolUse` (secuencial, puede bloquear), `PostToolUse` (paralelo, puede reintentar), `Stop` (paralelo, puede reintentar la respuesta).
4. `permissionDecision: "deny"` en PreToolUse bloquea la tool con feedback al modelo. `additionalContext` inyecta contexto sin bloquear.
5. Cada hook recibe stdin aislado — los hooks no pueden comunicarse entre sí dentro del mismo evento.

## Connections

- Related concepts: [[wiki/concepts/agent-hook-compatibility]]
- Projects: [[wiki/pages/cortex-forge]]

---

- 2026-06-08 [claude-sonnet-4-6]: Page created
