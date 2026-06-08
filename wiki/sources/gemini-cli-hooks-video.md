---
title: "Gemini CLI Hooks & Skills — Google Cloud Live"
type: source
created: 2026-06-08
updated: 2026-06-08
tags: [gemini-cli, hooks, skills, lifecycle, configuration]
source_url: https://www.youtube.com/watch?v=ZXYuiEMm21s
source_date: 2026-06-08
source_author: Google Cloud Live — Jack Weatherspoon (Gemini CLI team)
sources:
  - .raw/gemini-cli-hooks-video.md
confidence: medium
---

# Gemini CLI Hooks & Skills — Google Cloud Live

**URL:** https://www.youtube.com/watch?v=ZXYuiEMm21s
**Autor:** Jack Weatherspoon, Gemini CLI team — Google Cloud Live
**Formato:** transcript de video (auto-subtítulos, calidad media)

## Summary

Video de demostración avanzada de Gemini CLI con foco en hooks, skills y plan mode. El presentador (Jack Weatherspoon, del equipo de Gemini CLI) construye una aplicación en vivo para ilustrar cada feature.

Relevante para Cortex Forge porque Antigravity CLI hereda del ecosistema Gemini CLI — su sistema de hooks y skills tiene el mismo origen y convenciones base.

## Key Ideas

1. **Hooks se configuran en `settings.json`**: la configuración de hooks va dentro del bloque `hooks:` de `settings.json`, el archivo central de configuración de Gemini CLI. No en un `hooks.json` separado.
2. **Scripts pueden vivir en cualquier ruta**: "wherever you want" — no hay ruta de scripts impuesta por la plataforma. Solo el path en `settings.json` tiene que ser correcto.
3. **Context injection vía stdout**: los hooks envían contexto a Gemini CLI mediante stdout. El contenido se inyecta en el turno actual antes de que el modelo responda.
4. **Session start hook para cargar contexto**: caso de uso explícito — cargar los últimos 5 commits de git, cargar contexto de sesión anterior, etc. Es el equivalente exacto del hot cache protocol de Cortex Forge.
5. **Dos scopes**: user-scope (disponible en todos los proyectos, vive en `~/.gemini/`) y workspace-scope (específico del proyecto, vive en `.gemini/` local o `.agents/`).
6. **Skills standardized folder**: `.agents/skills` es la carpeta estandarizada agnóstica de proveedor. Gemini CLI también lee desde `.gemini/skills`. El estándar multi-agente es `.agents/`.
7. **Progressive disclosure**: patrón central de hooks y skills — en lugar de cargar todo el contexto al inicio, se carga solo cuando se necesita. Ver [[wiki/concepts/progressive-disclosure-hooks]].

## Connections
- Related concepts: [[wiki/concepts/antigravity-hooks]], [[wiki/concepts/agent-hook-compatibility]], [[wiki/concepts/progressive-disclosure-hooks]]
- Entities: [[wiki/entities/google-antigravity]]

---

- 2026-06-08 [Claude Code]: Página creada — transcript de video descargado con yt-dlp; relevancia: Antigravity hereda convenciones de Gemini CLI
