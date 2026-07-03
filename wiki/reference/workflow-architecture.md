---
title: Workflow Architecture
type: concept
created: 2026-06-13
updated: 2026-07-02
tags: [cortex-forge, architecture, workflow, skills, scripts, agents]
sources:
  - wiki/concepts/agent-hook-compatibility.md
confidence: high
schema_version: "0.3"
aliases: []
---

# Workflow Architecture

Cómo opera cortex-forge a través de agentes: qué instruye `AGENTS.md` en cada fase de una sesión, qué skills usar en medio, y qué scripts siguen corriendo por fuera del ciclo de vida del agente (git hooks).

Cortex Forge no usa hooks de ciclo de vida del agente (`SessionStart`, `PreCompact`, `SessionEnd`, `Stop`, `PreToolUse`) — el soporte era demasiado desigual entre Claude Code, Codex, Antigravity y CommandCode para construir el sistema sobre esa base. Ver [[wiki/concepts/agent-hook-compatibility]] para los hallazgos concretos que motivaron esa decisión (2026-07-02).

---

## Las dos fases de una sesión

Cada sesión de un agente pasa por dos fases: **During** y **End**. La carga de contexto al inicio no es una "fase" separada con mecanismo propio — es simplemente la primera instrucción que `AGENTS.md` mandata cumplir antes de la primera respuesta.

```
Start ── AGENTS.md instruye: leer .cortex/MEMORY.md antes de la primera respuesta
          (idéntico en todo agente — sin hook, sin inyección automática)

During ── Skills invocados por el agente:
            /cortex-assimilate, /cortex-recall, /cortex-prune,
            /cortex-imprint, /cortex-crystallize

End ────── /cortex-crystallize invocado manualmente
            (al cerrar un hito, o antes de terminar la sesión)
```

---

## Fase 1: Session Start — Cargar contexto

El agente necesita saber qué pasó antes. `AGENTS.md` (sección "Crystallize protocol — MANDATORY") lo obliga a leer `.cortex/MEMORY.md` completo antes de su primera respuesta, en cualquier agente:

1. Leer `.cortex/MEMORY.md` en full.
2. Si existe, leer `.cortex/PRAXIS.md`.
3. Si existe, leer `wiki/meta/vault-report.json` y surfacear issues.
4. Si `MEMORY.md` tiene `### Pending` items, reconocerlos.
5. Revisar la última entrada de `## History` por un `#### Imprint candidate` y proponer `/cortex-imprint` si está presente.

Este mecanismo es idéntico en Claude Code, Codex, Antigravity y CommandCode — no hay tabla de "qué hook usa cada agente" porque ningún agente usa hooks para esto. La confiabilidad depende de que el agente respete `AGENTS.md`, no de un evento del harness.

---

## Fase 2: During Session — Skills

Skills se invocan manualmente durante la sesión. No tienen hooks — el agente (o el usuario) elige cuándo usarlos.

| Skill | Cuándo invocar | Qué hace | Dónde vive |
|-------|---------------|----------|-----------|
| `/cortex-recall` | Cuando el usuario pregunta sobre algo que el vault pueda cubrir | Busca en `wiki/` y responde con citas + confidence. **Protocolo obligatorio** — no usar grep/find como reemplazo | `skills/cortex-recall/SKILL.md` |
| `/cortex-assimilate` | Cuando llega una URL o archivo nuevo para ingerir | Descarga → SPA detection → guarda en `.raw/` → sintetiza páginas wiki → actualiza índice. **Protocolo obligatorio** | `skills/cortex-assimilate/SKILL.md` |
| `/cortex-crystallize` | Al cerrar un hito, o cuando el usuario pide "guardar contexto", o antes de cerrar la sesión | Snapshot del estado actual de la sesión en `.cortex/MEMORY.md` | `skills/cortex-crystallize/SKILL.md` |
| `/cortex-prune` | Periódicamente, o cuando el vault-report muestra issues | Health check: detecta dead links, raw huérfanos, páginas sin frontmatter, confidence faltante | `skills/cortex-prune/SKILL.md` |
| `/cortex-imprint` | Cuando la sesión produjo análisis o síntesis que vale la pena persistir | Archiva el hallazgo como página permanente en `wiki/` | `skills/cortex-imprint/SKILL.md` |

**TASTE rules** (CommandCode) en `.commandcode/taste/taste.md` recuerdan al agente qué skills usar y cuándo. En otros agentes, el equivalente es `AGENTS.md`.

---

## Fase 3: Session End — Guardar snapshot

Al cerrar la sesión, el agente necesita escribir qué se hizo, qué se descartó, y qué contexto es frágil. No hay hook que capture esto automáticamente en ningún agente — `/cortex-crystallize` se invoca manualmente, siempre, del mismo modo en todo agente.

`AGENTS.md` instruye invocar `/cortex-crystallize` "después de hitos" y antes de cerrar la sesión. El skill detecta el agente invocador (`env` — `CLAUDECODE=1`, `AI_AGENT`, etc., ver `cortex-crystallize/SKILL.md` paso 1a) para completar el campo `agent:` del snapshot, pero la invocación siempre es manual.

---

## Scripts: referencia completa

### Scripts standalone (solo en el repo fuente)

Estos scripts solo existen en el repo `moon-cortexforge`. Los vaults consumidores no los tienen.

| Script | Propósito | Uso |
|--------|-----------|-----|
| `cortex-prune.sh` | Health check estructural del vault | Manual (invocado por `/cortex-prune`) o via post-commit git hook |
| `cortex-sanitize.sh` | Escaneo de seguridad antes de ingerir a .raw/ | Manual, paso intermedio de `/cortex-assimilate` |
| `setup-vault.sh` | Crear estructura de directorios + config Obsidian | Una vez, al crear el vault |
| `cortex-index.py` / `cortex-search.py` / `embeddings.py` | Indexación y búsqueda semántica del vault | Manual (`/cortex-forge-setup`, `/cortex-recall`) o via post-commit reindex git hook |

### El único hook que sigue en pie: post-commit git hook

`~/.cortex-forge/bin/hooks/` (runtime global) hoy solo contiene `cortex-reindex-post-commit.sh` — un **git hook**, no un hook de ciclo de vida del agente. La distinción importa: un git hook se dispara por un evento de git (`post-commit`), corre igual sin importar qué agente (o humano) hizo el commit, y no depende de que ningún harness de agente lo soporte.

| Bloque instalado en `<vault>/.git/hooks/post-commit` | Script invocado | Qué hace | Condición |
|--------|----------------|----------|-----------|
| `cortex-forge prune` | `bin/cortex-prune.sh` (del vault) | Refresca `wiki/meta/vault-report.json`; log en `.git/cortex-prune.log` | Siempre (backgrounded, fail-open) |
| `cortex-forge reindex` | `~/.cortex-forge/bin/hooks/cortex-reindex-post-commit.sh` | Re-indexa embeddings cuando el commit tocó archivos `wiki/` | Solo si `.cortex/db/vault.db` existe Y el commit incluyó cambios en `wiki/` |

**Flujo del reindex:** el script detecta cuántos archivos `wiki/` cambiaron en el commit (`git diff-tree`), y solo entonces invoca `bin/cortex-index.py` sobre la raíz del vault. Si la DB no existe o no hay archivos wiki modificados, sale silenciosamente (`exit 0`). El bloque usa `|| true` para ser fail-open — nunca bloquea un commit.

**Instalación:** ambos bloques se instalan opcionalmente en `<vault>/.git/hooks/post-commit` durante `/cortex-forge-setup` (pasos 6b/6c) o `install.sh`.

**Nota de rendimiento:** el reindex es full (no incremental) — recorre todos los archivos wiki/ en cada commit que los toque. Aceptable con < 200 páginas; en vaults grandes puede requerir estrategia incremental (indexar solo los paths del diff).

---

## Ubicación de scripts

`~/.cortex-forge/bin/hooks/` es la ubicación global única para scripts que corren fuera del proceso principal del agente. Los vaults consumidores no tienen `bin/` propio — solo el repo fuente (`moon-cortexforge`) lo tiene como directorio de desarrollo.

---

- 2026-06-13 [CommandCode]: Page created — comprehensive workflow architecture reference covering 3-phase flow, hooks per agent, skills, scripts, degraded modes, and config files
- 2026-06-27 [Claude Code]: Added `.git/hooks/` section — post-commit hook blocks (prune + reindex), reindex trigger conditions, performance note on full vs incremental strategy
- 2026-06-28 [Claude Code]: Corrected script location throughout — all scripts live in `~/.cortex-forge/bin/hooks/` (global), never in consumer vault `bin/`; added reindex script to hook table; clarified standalone scripts are repo-only
- 2026-07-02 [Claude Code]: Full rewrite — agent lifecycle hooks (SessionStart, PreCompact, SessionEnd, Stop, PreToolUse) were removed from cortex-forge entirely; replaced the 3-phase hook/no-hook table and per-agent hook wiring reference with the manual, `AGENTS.md`-mandated protocol used identically on every agent. Only the post-commit git hooks (prune, reindex) remain — kept and documented unchanged, since they're git-triggered, not agent-triggered. See [[wiki/concepts/agent-hook-compatibility]] for why hooks were dropped.
