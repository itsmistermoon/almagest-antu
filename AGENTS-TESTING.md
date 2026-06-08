---
title: "AGENTS-TESTING — protocolo de pruebas multi-agente"
type: project
created: 2026-06-08
updated: 2026-06-08
tags: [testing, protocol, agent-agnosticism]
status: active
repo: .
domains: [agent-compatibility, session-memory]
sources: []
confidence: high
---

# AGENTS-TESTING — protocolo de pruebas multi-agente

**Status:** active
**Repo:** cortex-forge

## Contexto y origen

Este documento nace de una sesión de testing en la que el usuario (Juan Pablo Armstrong, mantenedor del vault) buscaba verificar si el protocolo **Cortex Forge** cumple su promesa de **agente-agnosticismo**. La prueba consistió en abrir una sesión nueva con un agente diferente (CommandCode / MiniMax-M3) y observar si respetaba la instrucción declarativa de `AGENTS.md`:

> "`.hot/{project}.md` stores session context per project for multi-agent coordination. **Read it on session start.**"

**Resultado de la prueba:** el agente **no leyó** `.hot/cortex-forge.md` al inicio de la sesión. Solo lo hizo cuando el usuario lo pidió explícitamente. El usuario pidió documentar los hallazgos y proponer soluciones evaluables.

### Autoría

- **Redactor de esta entrada:** CommandCode (modelo MiniMax-M3), sesión del 2026-06-08.
- **Contexto de redacción:** investigación sobre por qué falló la carga del hot cache, realizada en respuesta a la pregunta del usuario.
- **Estructura:** sigue el template de `cortex-crystallize` (Current state mutable + History append-only), extendido con una sección de **Evaluación comparativa de soluciones** que es el aporte central de este documento.

### Idioma y registro

- Idioma: español (matching `AGENTS.md` y la conversación de origen).
- Registro: neutro. El usuario aclaró que es chileno; se evita el voseo rioplatense en futuras sesiones.

---

## Current state

### Pending
- [ ] Decidir cuál de las 3 soluciones propuestas (prompt / wrapper / skill) implementar primero — `AGENTS-TESTING.md §Soluciones propuestas`
- [ ] Aplicar la solución de Capa 1 (modificar `AGENTS.md` con imperativo fuerte) como experimento controlado — `AGENTS-TESTING.md §Capa 1`
- [ ] Esperar resultados de las pruebas de Fase 1 con Claude Code, Codex y Antigravity (sesiones paralelas) — `ROADMAP.md Fase 1`

### Active decisions
- El hot cache **no se carga por defecto** en agentes sin hook `SessionStart` nativo (CommandCode, Codex, etc.); la instrucción "read on session start" en `AGENTS.md` es aspiracional, no ejecutable — debe resolverse en la capa de plataforma o en el prompt, no en el archivo
- La instrucción correcta para CommandCode debe usar verbos imperativos + framing de "precondición" + señalar que `.hot/{project}.md` contiene "Pending tasks" para activar la heurística de atención del modelo

---

## El problema observado

### Comportamiento esperado (según `AGENTS.md`)
> "`.hot/{project}.md` ... Read it on session start."

### Comportamiento real
- El agente recibió `AGENTS.md` como parte de su system prompt.
- La instrucción fue **informativa**, no ejecutada.
- El usuario tuvo que pedir explícitamente la lectura.

### Por qué falló (causas técnicas)

1. **AGENTS.md es un recordatorio declarativo, no un disparador de acciones.** El wrapper (CommandCode) carga el archivo como texto al system prompt. No hay un mecanismo que fuerce al modelo a ejecutar un `read` específico antes de responder.

2. **No existe hook de SessionStart en CommandCode.** En Claude Code, los hooks `SessionStart: [load-hot-cache.sh]` ejecutan el script automáticamente. CommandCode no tiene esa ranura — el `read` debe ser una decisión del modelo.

3. **La instrucción compite con otras prioridades del system prompt.** El prompt contiene decenas de directrices. Sin marcadores de alta prioridad (MANDATORY, must, "before first response"), la instrucción se diluye.

4. **Falta de señal de continuidad.** El primer mensaje del usuario fue una pregunta de comportamiento, no un saludo de retomar trabajo. Sin esa señal, el modelo asume "sesión nueva limpia".

5. **El framing "read it on session start" no activa heurísticas de preflight.** Modelos tienden a tratar esa frase como "contexto informativo". Lo que sí funciona: "before responding to the user", "MANDATORY preflight", "protocol violation".

---

## Soluciones propuestas

### Capa 1 — Reforzar el prompt de `AGENTS.md` (cero código)

**Cambio:** reemplazar el texto actual de la sección "Hot Cache protocol" por una versión imperativa con marcadores de alta prioridad.

**Texto propuesto:**

```markdown
## Hot Cache protocol — MANDATORY

`.hot/{project}.md` exists in this vault. It contains `## Pending` tasks
and `## Fragile context` that must inform every session.

**Before your first response to the user, in any session that starts in
this vault, you MUST:**

1. Detect the project name = `basename` of your current working directory.
2. Read `.hot/{project}.md` in full.
3. Treat the loaded content as required context — not optional background.
4. If the file contains `### Pending` items, acknowledge them in your
   first message or surface them before starting new work.

**Failure to load hot cache before first response is a protocol
violation**, equivalent to ignoring `CLAUDE.md` in Claude Code.

**After milestones**, invoke `/cortex-crystallize` to snapshot progress
back into `.hot/{project}.md`.
```

**Esfuerzo:** 5 minutos, edición de un archivo.
**Riesgo:** bajo. Si no funciona, revertir es trivial.
**Dependencia:** ninguna.
**Probabilidad de éxito:** media-alta para CommandCode (modelos dóciles responden a MANDATORY + verbos imperativos). Baja para modelos que ignoran instrucciones declarativas.

---

### Capa 2 — Modificar el wrapper CommandCode (requiere PR)

**Cambio:** agregar código en `/opt/homebrew/lib/node_modules/command-code/dist/index.mjs` que lea `.hot/{basename}.md` y lo inyecte al system prompt antes del primer tool call.

**Borrador de implementación:**

```javascript
// Después de cargar AGENTS.md, antes del primer tool call
import fs from 'fs';
import path from 'path';

const projectName = path.basename(process.cwd());
const hotCachePath = path.join(process.cwd(), '.hot', `${projectName}.md`);

if (fs.existsSync(hotCachePath)) {
  const hotCache = fs.readFileSync(hotCachePath, 'utf-8');
  systemPrompt += `\n\n## Hot cache (auto-loaded from .hot/${projectName}.md)\n\n${hotCache}\n\n`;
}
```

**Esfuerzo:** PR a CommandCode, requiere coordinación con el mantenedor.
**Riesgo:** medio. Cambia el comportamiento por defecto para todos los usuarios, no solo Cortex Forge.
**Dependencia:** cooperación del equipo de CommandCode.
**Probabilidad de éxito:** alta (es la única solución que no depende de la obediencia del modelo).

**Limitación:** la ruta debe validarse para no romper a usuarios que no usen Cortex Forge. Una heurística razonable: leer `.hot/{project}.md` solo si AGENTS.md contiene la marca `# AGENTS.md — ` (convención de Cortex Forge).

---

### Capa 3 — Skill de preflight como red de seguridad (código nuevo)

**Cambio:** crear `~/.agents/skills/cortex-preflight/SKILL.md` con invocación automática al inicio de sesión.

**Borrador:**

```markdown
---
name: cortex-preflight
description: MANDATORY preflight for sessions starting in a Cortex Forge vault. Auto-invoked at session start, before any other action, when CWD contains .hot/. Loads .hot/{project}.md and surfaces Pending tasks before first user response.
---

## When invoked
At the start of every session, before responding to the user, if the
current working directory contains `.hot/`.

## Steps
1. Determine project name = `basename` of CWD.
2. Read `.hot/{project}.md` in full.
3. Extract `## Pending` section if present.
4. Extract `## Fragile context` if present.
5. Use both as priors for the first response.
6. If `## Pending` contains items, mention them in your first message.
```

**Esfuerzo:** 30 minutos, crear un archivo de skill.
**Riesgo:** bajo. Es opt-in (se instala solo si el usuario quiere la red de seguridad).
**Dependencia:** ninguna.
**Probabilidad de éxito:** media. La auto-invocación desde `description` funciona en muchos modelos, pero no está garantizada en todos.

---

## Evaluación comparativa

Esta sección es la respuesta a la intención del usuario: que cada agente redacte sus hallazgos y al final evalúe las soluciones.

| Criterio | Capa 1 (prompt) | Capa 2 (wrapper) | Capa 3 (skill) |
|---|---|---|---|
| **Esfuerzo** | 5 min | PR + revisión | 30 min |
| **Riesgo de regresión** | Muy bajo | Medio (afecta a todos los usuarios) | Bajo |
| **Dependencia externa** | Ninguna | Equipo CommandCode | Ninguna |
| **Probabilidad de éxito (CommandCode)** | Media-alta | Alta | Media |
| **Probabilidad de éxito (Codex)** | Baja-media | Alta | Media |
| **Probabilidad de éxito (Claude Code)** | Alta (ya hay hook) | Alta | Alta |
| **Cumple promesa "agente-agnóstico"** | No | Sí (con heurística) | No del todo |
| **Reversible** | Sí | Sí (rollback de PR) | Sí |
| **Coste de mantenimiento** | Cero | Bajo | Bajo |

### Recomendación del agente (CommandCode, sesión 2026-06-08)

**Corto plazo (hoy):** implementar Capa 1. Es la única acción que no requiere coordinación externa y se puede probar de inmediato. El experimento controlado sería: editar `AGENTS.md`, abrir una nueva sesión, observar si la próxima vez se carga el hot cache sin pedirlo.

**Mediano plazo (esta semana):** crear Capa 3 como respaldo. Si la Capa 1 falla para algún modelo, la skill cubre el hueco.

**Largo plazo (mes):** proponer Capa 2 al equipo de CommandCode vía PR. Es la única solución que **de verdad** cumple la promesa de agente-agnosticismo — porque no depende de la obediencia del modelo, sino de la plataforma.

### Trade-off honesto

Ninguna de las tres capas es mutuamente excluyente. El sistema más robusto usa las tres:

1. Capa 2 garantiza carga automática cuando la plataforma lo permite.
2. Capa 1 cubre los casos donde Capa 2 no está disponible (Codex, otros).
3. Capa 3 es red de seguridad para modelos que ignoran ambas.

Pero si hay que elegir **una sola** y la plataforma no es modificable, **Capa 1 es la de mejor ratio esfuerzo/resultado**.

---

## Capa 1 — Implementación (2026-06-07, Claude Code / claude-sonnet-4-6)

### Diagnóstico adicional post-sesión

Análisis de Claude Code identificó un **segundo fallo** que `AGENTS-TESTING.md` no capturó: `cortex-recall` tampoco fue invocado proactivamente durante la consulta de vault — el agente usó búsqueda manual. El patrón de fallo es el mismo: instrucciones declarativas no disparan acciones. Afecta hot cache y skills por igual.

Además, se identificó un **flaw en la Capa 3**: una skill de preflight que depende de auto-invocación desde su `description:` tiene exactamente la misma limitación que el problema que intenta resolver. Si el modelo no ejecuta "Read it on session start", tampoco auto-invocará una skill. La Capa 3 queda descartada en su diseño actual o requiere rediseño fundamental.

### Cambios aplicados a `AGENTS.md`

**Sección Hot Cache protocol** — reemplazada completamente:
- Título: `Hot Cache protocol` → `Hot Cache protocol — MANDATORY`
- Contenido: texto declarativo ("Read it on session start") → 4 pasos numerados con verbos imperativos, framing de "protocol violation", y "not optional background"

**Sección Ingest protocol** — extendida:
- Título: `Ingest protocol` → `Ingest protocol — MANDATORY`
- Agregada instrucción explícita para `cortex-recall`: **"When the user asks about vault content [...] you MUST invoke `cortex-recall` before searching manually. Manual search is a protocol violation when the vault has synthesized knowledge on the topic."**

**Tabla de arquitectura** — celda Hot actualizada:
- Antes: "Read on session start, write via /cortex-crystallize"
- Después: "**MANDATORY**: read before first response, write via /cortex-crystallize"

### Experimento de control

La validación de Capa 1 requiere:
1. Abrir sesión nueva en CommandCode en este vault.
2. No dar ningún contexto previo ni mencionar el hot cache.
3. Observar si el agente lee `.hot/cortex-forge.md` de forma autónoma antes de responder.
4. En una consulta sobre vault, observar si usa `cortex-recall` sin instrucción explícita.

**Resultado esperado si Capa 1 funciona:** agente menciona Pending del hot cache en primer mensaje.
**Resultado si falla:** repetir el patrón de la sesión anterior. Escalar a Capa 2.

---

## Lecciones transferibles (para wiki/concepts/)

Estas observaciones probablemente valen como concepto general del vault:

- **Las instrucciones declarativas en archivos no son ejecutables por agentes sin hook nativo.** Es una limitación de diseño de los frameworks actuales.
- **El framing "MANDATORY preflight" + "before first response"** es el patrón que mejor funciona para forzar lectura de contexto en modelos actuales.
- **Agente-agnosticismo real = resolver en la capa de plataforma, no en el prompt.** Los archivos de instrucciones son sugerencias, no contratos.
- **Cargar contexto por defecto requiere acción del wrapper, no del modelo.** El modelo no sabe que tiene que hacerlo; la plataforma tiene que inyectarlo.

---

## History

### 2026-06-08 — Antigravity (Experimento de control de Capa 1)

**Nota:** Antigravity se quedó sin tokens antes de completar su informe. Esta entrada fue reconstruida por Claude Code desde la conversación copiada por el usuario.

#### What was done
- **Validación de Capa 1**: Éxito parcial. Antigravity leyó `.hot/cortex-forge.md` con `view_file` en su primer turno de ejecución, **antes de generar su primera respuesta**, obedeciendo el MANDATORY de `AGENTS.md`. Confirmó explícitamente: "lo acabo de leer en este momento en mi primer turno [...] antes de generar esta respuesta".
- **Distinción semántica importante**: Antigravity aclaró que la lectura no ocurrió "automáticamente al iniciar la sesión" — ocurrió reactivamente al recibir el primer mensaje del usuario. El agente no está activo entre sesiones; el primer mensaje del usuario lo despierta y recién ahí ejecuta el preflight. Esta es la misma arquitectura reactiva que todos los LLMs actuales.
- **`cortex-assimilate` y `cortex-recall`**: funcionaron sin problemas en la misma sesión, sin instrucción explícita adicional.

#### Discarded
- _(ninguno)_

#### Fragile context
- **[CORREGIDO]** El modelo afirmó no tener hooks nativos — eso era incorrecto. Antigravity hereda el sistema de hooks de Gemini CLI: `PreInvocation` (equivale a SessionStart) y `Stop`, configurados en `~/.gemini/config/hooks.json`. Ver `wiki/concepts/antigravity-hooks.md`.
- La Capa 1 fue efectiva en esta sesión porque los hooks aún no estaban configurados. Con Capa 2 activa (hooks instalados en sesión posterior), el preflight ya no depende de obediencia del modelo.
- **Bug conocido en agy-cli (issue #49)**: el CLI escribe hooks en `~/.gemini/antigravity-cli/hooks.json` pero los lee desde `~/.gemini/config/hooks.json`. Solución: edición manual + symlink (ya aplicado).
- El modelo no especificó su versión exacta durante la sesión.

### 2026-06-08 — Codex / o3 (Experimento de control — Capa 2 nativa)

**Nota de reformateo:** Codex no creó su propia sección; sus notas quedaron dentro de la sección Antigravity. Extraídas y reorganizadas por Claude Code en sesión posterior.

#### What was done
- `.raw/codex-hooks.md`: descargado — documentación oficial de hooks de Codex (OpenAI)
- `wiki/sources/codex-hooks.md`: creado — type: source, confidence: high
- **Validación de Capa 2 (hook nativo)**: Éxito funcional con dos problemas de comportamiento (ver Fragile context)

#### Discarded
- _(ninguno)_

#### Fragile context
- **Codex SÍ tiene `SessionStart` nativo** — confirmado en ejecución real. El hook se ejecutó, leyó `.hot/cortex-forge.md` y cargó el contexto antes de que el modelo generara su primera respuesta. La Capa 2 funciona en Codex sin depender de obediencia del modelo.
- **Comportamiento 1 — hook context visible en el chat**: Codex usa el **mismo wire format** que Claude Code (`{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":...}}`), confirmado en documentación oficial. El script es compatible sin modificaciones. La diferencia es de UI: Codex muestra el `hook context:` al usuario como transparencia por diseño — el contexto llega correctamente al modelo, el ruido visual es intencional, no un error de parsing.
- **Comportamiento 2 — SessionStart se disparó dos veces**: esperado por diseño. `SessionStart` tiene un campo `source` con tres valores posibles: `startup`, `resume`, `clear`. Cada uno dispara el hook de forma independiente. El segundo disparo fue probablemente un `resume` o `clear` de contexto dentro de la misma sesión. Se puede filtrar por `source` en el matcher si se quiere limitar a `startup` únicamente.
- **Sin solución para visibilidad**: `suppressOutput` existe en el schema de Codex pero está marcado "Reserved for future use". No hay mecanismo disponible hoy para inyectar `additionalContext` de forma silenciosa — el `hook context:` en el chat es permanente en la UI actual. El workaround sugerido en la documentación (`UserPromptSubmit` en lugar de `SessionStart`) tampoco elimina la visibilidad.
- **Issue de rutas de hooks**: los scripts apuntan a `~/.claude/hooks/load-hot-cache-codex.sh` y `~/.claude/hooks/update-hot-cache-codex.sh`. El directorio `.claude/` es de Claude Code — debería moverse a `~/.codex/hooks/` o a una ruta neutral como `~/.cortex-forge/hooks/`. Esto es un bug de `cortex-forge-setup`.
- **Trust review en primera ejecución**: Codex muestra `New hook - review required` y pide aprobación manual. Comportamiento esperado por diseño de seguridad de Codex, no un fallo.

#### Addendum — lectura posterior de la compatibilidad de hooks
- La fuente canónica en el vault para Antigravity es la matriz de compatibilidad: `PreInvocation (invocationNum==0)` como equivalente de inicio y `Stop (fullyIdle==true)` como equivalente de cierre.
- Para el cierre de sesión, el hook relevante es `Stop`, no `SessionStart`; eso es lo que soporta el flujo de snapshot de la hot cache en Antigravity.
- El bloque operativo recomendado en `~/.agents/hooks.json` queda alineado con esa matriz: `PreInvocation` para cargar `.hot/` y `Stop` para persistir al cierre.
- No quedó validación en vivo de un cierre real de sesión en esta conversación; lo confirmado aquí es la compatibilidad documental y la interpretación del cierre correcto.
- Tampoco se validó el uso obligatorio de `/cortex-recall` en Antigravity para consultas sobre la vault: en esta sesión se respondió con búsqueda manual, así que el fallo de obediencia sigue abierto.

#### Addendum — skills y sospecha de inyección visible
- `cortex-assimilate` mostró ser más fiable para trabajo de entrada: la petición de ingesta de una fuente nueva sí disparó el flujo esperado de incorporación.
- `cortex-recall` quedó como la skill más sensible a obediencia de protocolo: cuando había que consultar conocimiento ya sintetizado, el agente terminó usando búsqueda manual en lugar de invocarla de forma obligatoria.
- La diferencia práctica no es de capacidad, sino de activación: `assimilate` se usó bajo una orden explícita de ingesta; `recall` falló precisamente donde el protocolo exigía preferirla a la búsqueda manual.
- Sobre la inyección de contexto visible en la conversación, la sospecha más fuerte es un hook de arranque o un preflight equivalente, no `Stop`.
- La hipótesis más probable sigue siendo `PreInvocation (invocationNum==0)` o alguna capa superior del wrapper que entrega contexto al turno inicial, pero de momento eso es una inferencia, no una observación directa.
- Si ese contexto debería llegar internamente y no en el chat visible, entonces hay un problema de encapsulación en la capa que prepara la sesión, no en el hook de cierre.

---

### 2026-06-08 — CommandCode (MiniMax-M3) (prueba manual solicitada por usuario)

#### What was done
- `AGENTS-TESTING.md`: creado desde cero con hallazgos, 3 soluciones propuestas y evaluación comparativa
- `AGENTS.md`: revisado en sesión para identificar el punto exacto de falla (sección "Hot Cache protocol")
- `.hot/cortex-forge.md`: leído bajo instrucción explícita del usuario (confirmó que contenía Pending tasks que el agente no había cargado)

#### Discarded
- _(ninguna)_

#### Fragile context
- Sesión de CommandCode + MiniMAX-M3 (no Claude Code); el modelo responde a MANDATORY + verbos imperativos pero no ejecuta acciones declarativas por iniciativa propia
- Comando de prueba: `ls -la /Users/itsmistermoon/proyectos/cortex-forge/.hot/` confirmó existencia de `cortex-forge.md` (2781 bytes, actualizado 2026-06-07)
- Usuario es chileno; registro debe evitar voseo rioplatense (registrado como active decision)
- Estructura del documento: extiende el template de `cortex-crystallize` con sección de evaluación comparativa — esta extensión puede ser valiosa como nuevo template si se replica en futuras sesiones de testing

---

### 2026-06-08 — Claude Code (claude-sonnet-4-6) (sesión de revisión Codex)

#### What was done
- `AGENTS-TESTING.md`: sección Codex extraída de Antigravity y reformateada como entrada propia; hallazgos de hook output visible y doble disparo documentados; causa raíz del output visible identificada (protocolo JSON de Claude Code no reconocido por Codex)

#### Discarded
- _(ninguno)_

#### Fragile context
- **Fallo de `cortex-recall` confirmado en Claude Code**: al recibir "Está documentado en el vault", el agente usó `find` y `grep` en lugar de `cortex-recall`. El hook `SessionStart` funcionó y el contexto se cargó — el fallo no es de carga inicial sino de comportamiento durante la sesión. La instrucción MANDATORY en `AGENTS.md` no es suficiente para garantizar la invocación de skills en el flujo de trabajo. Mismo patrón que Antigravity y CommandCode.

---

### 2026-06-08 — CommandCode (MiniMax-M3) (segunda sesión: ingesta + experimento cortex-recall)

#### What was done
- Ingesta de `commandcode.ai/docs/hooks/configuration` (curl → `.raw/commandcode-hooks-configuration.md` 2.4KB)
- `wiki/sources/commandcode-hooks-configuration.md`: creado (confidence: high)
- `wiki/concepts/agent-hook-compatibility.md` §CommandCode: ampliada con scopes (user/project), precedencia, orden `PreToolUse` (secuencial, cortocircuito) vs `PostToolUse` (paralelo), wire format anidado
- `wiki/pages/cortex-forge.md`: creado retroactivamente como project page del vault
- `wiki/index.md`, `wiki/meta/log.md`: actualizados
- `.hot/cortex-forge.md`: crystallize final con pending consolidado y active decisions al límite
- **`cortex-recall` ejecutado correctamente en consulta posterior** — diferencia de comportamiento documentada abajo

#### Discarded
- Crear concept nuevo para "wire format anidado de CommandCode" — descartado: nota operacional, no concepto reusable; el detalle vive en `agent-hook-compatibility`
- Crear entity "CommandCode" — descartado: ya está implícito en la matriz; el source es `commandcode.ai/docs/...`, no la herramienta
- Project linking inmediato — `wiki/pages/` solo tenía `.gitkeep` al inicio de la sesión; project page se creó retroactivo

#### Fragile context
- **Hallazgo principal — wire format anidado de CommandCode**: `hooks: [{ matcher, hooks: [{ type: "command", command, timeout? }] }]`, distinto del plano de Claude Code/Codex. **Implicación operativa**: los scripts `load-hot-cache*.sh` y `update-hot-cache*.sh` NO son drop-in para CommandCode. Si en el futuro se decide habilitar Capa 2 también en CommandCode, hay que escribir un `load-hot-cache-commandcode.sh` con el shape anidado, o re-envolver los handlers existentes en sub-arrays `hooks` por matcher.
- **Capa 1 validada en este turno** (lectura de `.hot/cortex-forge.md` antes de primera respuesta útil, respuesta en español por taste) — pero el usuario eligió opción C en el flujo del control, por lo que el pendiente "Re-probar CommandCode" NO se cierra con esta evidencia; queda para sesión CMD dedicada sin contaminar con otra tarea.
- **`cortex-recall` se ejecutó correctamente cuando se invocó explícitamente**, con respuesta de mayor fidelidad que `grep`:
  - `grep`: 12 archivos, incluyendo notas de sesión y roadmap con información menos curada
  - `cortex-recall` (siguiendo la skill): 2 páginas wiki sintetizadas — `wiki/sources/commandcode-hooks-configuration` y `wiki/concepts/agent-hook-compatibility` §CommandCode, con citas explícitas y contraste con `ROADMAP.md` (donde el roadmap dice "el archivo de hooks" sin nombre)
  - **Diferencia práctica**: la skill filtra conocimiento sintetizado en `wiki/`, no memoria cruda. La consulta se resuelve con menos ruido y mayor autoridad.
- **Fallo de obediencia confirmado en este modelo también** — usé `grep` antes de que el usuario me corrigiera. El patrón de fallo de `cortex-recall` se confirma para CommandCode/MiniMax-M3, sumándose a Claude Code, Codex y Antigravity. Cuatro agentes, mismo patrón.
- **Discusión sobre TASTE**: el usuario propuso agregar la regla de usar `cortex-recall` a `~/.commandcode/taste/taste.md` para que CommandCode la respete por la vía nativa del wrapper (`get_self_knowledge`) en vez de por AGENTS.md. Decisión: TASTE se poblará de forma orgánica; no se escribe manualmente. El usuario plantea que `cortex-forge-setup` podría, al detectar `.commandcode/`, redactar una preferencia sobre el uso de skills de cortex-forge. Duda abierta: scope global (`~/.commandcode/taste/`) vs per-project (`.commandcode/taste/{project}.md`).
- **Restricción del sistema**: el agente NO puede escribir en `.commandcode/taste/` ni en `~/.commandcode/taste/` (regla "NEVER EDIT OR WRITE TO TASTE FILES"). Solo el usuario o el sistema de aprendizaje automático puebla TASTE. Esto cierra la posibilidad de auto-corregir el fallo de obediencia desde dentro del agente.
- **Implicación para el ROADMAP**: la Fase 4 "Carga progresiva en `cortex-recall`" (ROADMAP.md) sigue siendo el siguiente nivel después de TASTE. La jerarquía propuesta: Capa 2 hook nativo > TASTE rule > AGENTS.md MANDATORY > búsqueda manual.

### 2026-06-08 — Claude Code (claude-sonnet-4-6) (corrección reporte CommandCode + TASTE)

#### What was done
- `.hot/cortex-forge.md`: experimento de control de CommandCode marcado como completado; active decision de TASTE actualizado con los tres mecanismos disponibles
- `AGENTS-TESTING.md`: esta entrada — corrección del reporte de "sesión contaminada" y clarificación del modelo de escritura de TASTE

#### Discarded
- _(ninguno)_

#### Fragile context
- **Capa 1 confirmada para CommandCode**: el reporte de CMD sobre "sesión contaminada" fue incorrecto según el usuario — el agente leyó `.hot/cortex-forge.md` en el primer turno y respondió con contexto de proyecto de inmediato. El experimento de control se cierra aquí; no se necesita sesión dedicada adicional.
- **TASTE — clarificación de autoría**: la restricción de escritura sobre `.commandcode/taste/` es específica de CommandCode (system policy propia del wrapper). Otros agentes (Claude Code, Codex, Antigravity) no tienen esa restricción y pueden escribir el archivo. Por tanto, `cortex-forge-setup` ejecutado desde Claude Code podría escribir la preferencia directamente. Tres vías disponibles: (1) otro agente escribe el archivo; (2) la skill pre-redacta la instrucción y el usuario la pega a mano; (3) desarrollo orgánico con el uso normal de CommandCode.

---

### 2026-06-07 — Claude Code (claude-sonnet-4-6) (análisis + implementación Capa 1)

#### What was done
- `AGENTS-TESTING.md`: documentado segundo fallo (skills no invocadas), flaw de Capa 3, e implementación completa de Capa 1 con experimento de control
- `AGENTS.md`: Capa 1 aplicada — Hot Cache protocol y Ingest protocol reescritos con MANDATORY + pasos imperativos; `cortex-recall` agregado con instrucción explícita

#### Discarded
- Capa 3 (preflight skill) — descartada: mismo mecanismo de auto-invocación que falló en el problema original

#### Fragile context
- _(ninguno)_
