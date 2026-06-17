# Notas de resiliencia

Mejoras potenciales identificadas en revisión externa (2026-06-17). No son trabajo comprometido — cada ítem requiere validar si el problema se manifiesta en uso real antes de implementar.

---

## 1. Fragilidad del SessionEnd

**Problema:** Si la sesión no termina limpiamente (pestaña cerrada, crash, terminal abandonada), el crystallize no se ejecuta y el contexto se pierde silenciosamente.

**Opciones a evaluar:**

- **Modo degradado con `PENDING_CRYSTALLIZE`** _(bajo costo, alta prioridad)_  
  Si el Stop hook falla o no se ejecuta, dejar un archivo `.hot/PENDING_CRYSTALLIZE` con timestamp. El reactivate hook lo detecta en la sesión siguiente y avisa: "La sesión anterior no se crystallizó. ¿Quieres hacerlo ahora?" Convierte fallo silencioso en fallo recuperable.

- **Crystallize oportunista en respuestas largas**  
  Cuando el agente entrega una respuesta sustancial (fin de una fase de trabajo), hacer un micro-crystallize incremental. Añadir flag `--opportunistic` al script que solo escribe si el diff de contexto es significativo. Requiere criterio claro de "fin de fase" para no crystallizar en cada turno.

- **Checkpoint periódico vía cron**  
  Crystallize incremental cada N minutos mientras la sesión está activa. El SessionEnd se vuelve el checkpoint final, no el único. Más complejo de implementar correctamente (evitar writes concurrentes).

---

## 2. Tentación de saltarse el protocolo

**Problema:** El overhead percibido del protocolo (leer hot cache + invocar recall) puede llevar al usuario a bypasear el flujo cuando tiene prisa, rompiendo la integridad del vault silenciosamente.

**Opciones a evaluar:**

- **Modo turbo documentado como opt-in explícito**  
  Definir en `AGENTS.md` qué pasos son omitibles y bajo qué condición. Ejemplo: "preguntas de código puro sin entidades del vault → no requieren `/cortex-recall`". El bypass consciente y documentado no rompe integridad; el bypass por descuido sí.

- **Hot cache más denso como primera línea**  
  Si `.hot/MEMORY.md` contiene el 95% de lo relevante para el día a día, el protocolo de inicio se reduce a "leer 1 archivo" y la wiki queda como referencia de largo plazo. La latencia percibida baja sin cambiar la arquitectura. Trade-off: el crystallize tiene que ser más selectivo sobre qué promueve al hot cache.

- **Criterio de invocación de recall en CLAUDE.md**  
  Añadir regla explícita: invoke `/cortex-recall` solo cuando la pregunta menciona entidades nombradas del vault, decisiones pasadas, o el contenido de páginas wiki específicas. Preguntas de código puro no lo activan. Esto ya es el comportamiento esperado — solo falta escribirlo como contrato.

---

## 3. Lock-in a Claude Code CLI

**Problema:** El setup completo (symlinks, global skills) solo funciona nativamente en Claude Code CLI. Cursor y otros requieren configuración manual.

**Opciones a evaluar:**

- **Clasificar tiers en el README** _(sin costo de implementación)_  
  Documentar honestamente: "Tier 1 (full): Claude Code CLI", "Tier 2 (partial): Cursor/Codex con setup manual", "Tier 3 (read-only): cualquier LLM con acceso al vault". Gestiona expectativas sin intentar ser universal.

- **Export a `.cursor/rules` desde `cortex-forge-setup`**  
  Modo `--export-rules cursor` que genera archivos `.mdc` a partir de `CLAUDE.md` y `AGENTS.md` del vault. No es sincronización en tiempo real — es un snapshot exportable cuando el usuario quiere usar Cursor. Reduce la fricción de "¿cómo configuro esto?" a un comando.

- **Separar núcleo de delivery en la documentación**  
  Dejar claro que las skills son delivery (calidad de vida) y el vault es el núcleo (funciona sin skills). Un usuario de Cursor sin skills instaladas puede aún usar el vault — solo pierde los shortcuts. Esta distinción ya existe en el diseño pero no está documentada.

---

## Prioridad sugerida

1. `PENDING_CRYSTALLIZE` — bajo costo, convierte fallo silencioso en recuperable, implementable en una sesión.
2. Criterio de recall en `CLAUDE.md` — es escribir texto, no código; resuelve el problema 2 sin complejidad.
3. Tiers en README — sin costo, mejora adopción externa.
4. El resto: evaluar solo si el problema se manifiesta con frecuencia en uso real.
