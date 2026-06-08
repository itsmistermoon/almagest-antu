---
title: Hooks Examples - Command Code
type: source
created: 2026-06-08
updated: 2026-06-08
tags: [commandcode, hooks, examples, enforcement, quality-gate]
source_url: https://commandcode.ai/docs/hooks/examples
source_date:
source_author: CommandCode
sources:
  - .raw/commandcode-hooks-examples.md
confidence: high
---

# Hooks Examples - Command Code

**URL:** https://commandcode.ai/docs/hooks/examples
**Author:** CommandCode

## Summary

Cuatro ejemplos de hooks listos para adaptar, que cubren los patrones de uso más comunes: enforcement de seguridad (bloqueo de comandos peligrosos), context injection condicional (advertencia en lecturas sensibles), observabilidad (auditoría de tool calls), y quality gate de cierre (Stop hook que fuerza un re-pass).

## Key ideas

1. **Block Dangerous Bash Commands** (PreToolUse): matcher en shell, `permissionDecision: "deny"` + `systemMessage` explicativo. Patrón de enforcement de seguridad.
2. **Warn on Sensitive File Reads** (PreToolUse): siempre `permissionDecision: "allow"` + `additionalContext`. Patrón de context injection no bloqueante.
3. **Audit Tool Calls** (PreToolUse o PostToolUse): exit `0` sin modificar comportamiento; escribe a log local. Patrón de observabilidad pura.
4. **Quality Gate** (Stop): exit `2` si encuentra marcadores `DO NOT SHIP`; el agente reintenta hasta 3 veces. Patrón de completion gate.
5. Todos los scripts deben ser ejecutables (`chmod +x`) para que CommandCode los active.

## Connections

- Related concepts: [[wiki/concepts/agent-hook-compatibility]]
- Projects: [[wiki/pages/cortex-forge]]

---

- 2026-06-08 [claude-sonnet-4-6]: Page created
