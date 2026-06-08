---
title: Hooks Best Practices - Command Code
type: source
created: 2026-06-08
updated: 2026-06-08
tags: [commandcode, hooks, best-practices, security, debugging]
source_url: https://commandcode.ai/docs/hooks/best-practices
source_date:
source_author: CommandCode
sources:
  - .raw/commandcode-hooks-best-practices.md
confidence: high
---

# Hooks Best Practices - Command Code

**URL:** https://commandcode.ai/docs/hooks/best-practices
**Author:** CommandCode

## Summary

Guía operacional para escribir hooks seguros y eficientes en CommandCode. Cubre seguridad de inputs (nunca `eval`, siempre `jq -r`), límites de performance (10s para hooks síncronos), debugging con `--debug`, y tabla de problemas comunes con sus causas.

## Key ideas

1. **Seguridad de input**: tratar inputs del modelo como no confiables — parsear con `jq -r`, nunca `eval`. Siempre quoting de variables.
2. **Performance**: PreToolUse < 10s; operaciones lentas → PostToolUse o background. Los hooks corren en cada tool call — la latencia se acumula.
3. **Debugging**: `--debug` genera logs detallados con matcher results y payload data. Se puede iterar con mock payloads locales sin levantar CommandCode.
4. **Problemas frecuentes**: script no ejecutable (`chmod +x`), matcher regex incorrecto, hooks deshabilitados en plan mode, JSON malformado en output, timeout excedido.
5. **Guidance al modelo**: `additionalContext` para instruir, `systemMessage` para explicar violaciones de política.

## Connections

- Related concepts: [[wiki/concepts/agent-hook-compatibility]]
- Projects: [[wiki/pages/cortex-forge]]

---

- 2026-06-08 [claude-sonnet-4-6]: Page created
