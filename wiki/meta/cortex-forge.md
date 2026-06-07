---
title: Cortex-Forge — Protocolo de publicación pública
type: meta
updated: 2026-06-06
---

## Qué es cortex-forge

`cortex-forge` (`github.com/itsmistermoon/cortex-forge`) es la versión pública de este vault. Es un repo de solo-lectura para agentes externos y la comunidad — **nunca se trabaja directamente en él**.

Todo cambio ocurre en `second-brain`. El sync es unidireccional y automático.

---

## Cómo publicar

Hacer push a `main` en `second-brain` es suficiente. El workflow `.github/workflows/sync-public.yml` se dispara automáticamente y copia el contenido público a `cortex-forge`.

No hay paso manual de publicación.

---

## Qué se sincroniza

| Capa | Ruta | ¿Se sincroniza? |
|------|------|-----------------|
| Skills | `skills/` | Sí |
| Templates | `templates/` | Sí |
| Scripts | `bin/` | Sí |
| Documentación protocolo | `docs/` | Sí |
| Vistas Obsidian Bases | `bases/` | Sí |
| Wiki — conceptos | `wiki/concepts/` | Sí |
| Wiki — meta | `wiki/meta/` | Sí |
| Wiki — índice | `wiki/index.md` | Sí |
| README público | `README.public.md` → `README.md` | Sí |
| AGENTS.md | `AGENTS.md` | Sí |
| Wiki — fuentes | `wiki/sources/` | No — contenido personal |
| Wiki — entidades | `wiki/entities/` | No — contenido personal |
| Wiki — páginas | `wiki/pages/` | No — proyectos y decisiones privadas |
| Raw | `.raw/` | No — fuentes originales inmutables |
| Hot cache | `.hot/` | No — artefacto local de agente |

---

## Reglas para agentes

- **No editar cortex-forge directamente.** Cualquier cambio manual en archivos sincronizados será destruido en el próximo push a `second-brain`.
- Si quieres propagar un cambio a cortex-forge, editarlo en `second-brain` y hacer push.
- El README de cortex-forge se edita en `README.public.md` — nunca en `README.md`.
- Los archivos en `wiki/meta/` (incluido este) son públicos — no escribir información personal aquí.

---

## Infraestructura

- **Workflow:** `.github/workflows/sync-public.yml`
- **Secret:** `CORTEX_FORGE_TOKEN` en `second-brain` — PAT fine-grained con `Contents: write` solo sobre `cortex-forge`
- **Branch:** `main` → `main`
