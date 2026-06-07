---
title: Single Database, Multiple Views
type: concept
created: 2026-06-07
updated: 2026-06-07
tags: [productivity, notion, architecture, pkm, second-brain, productive-setups, hq-framework]
aliases: [single-source-of-truth, multi-view-database, one-database-many-views]
---

# Single Database, Multiple Views

## Principio

Una **segunda base de datos es una invitación a la fragmentación**. El patrón opuesto: **una sola database por dominio** (tasks, projects, notes, resources) y **múltiples vistas filtradas/ordenadas** sobre esa misma database. En Notion esto se materializa con `+ → Table view → select existing database` o `/linked database`.

El usuario percibe N herramientas ("My day today", "Week's tasks", "My month", "Order", "By bucket", "No date") pero en realidad interactúa con **1 sola database** reorganizada.

## Por qué funciona

- **Una sola fuente de verdad**: agregar un task en cualquier vista lo hace aparecer en todas las demás (filtradas). No hay sync entre databases.
- **Cero drag-and-drop entre lugares**: si filtraste mal, corriges el filter, no mueves el task a otra database
- **Filter/sort vive en la vista, no en el dato**: cambias el sort de "Order" → reordena 50 tasks instantáneamente
- **El "schema" se vuelve diseño de UI**: agregar una propiedad nueva (ej. `state of mind`) crea tabs nuevas automáticamente

## El antipatrón que evita

> "You're not spreading your information across a billion different databases. It's going to be too much to handle, too much to organize and it will become a clutter."

Versión infierno: `Tasks` (database 1) + `Daily Tasks` (database 2) + `This Week` (database 3) + `Quick Tasks` (database 4). Cada vez que agregas una task, tienes que decidir **en cuál** — y luego mantenerlas sincronizadas. El sistema te obliga a una decisión que el schema no puede resolver.

## Ejemplos concretos del framework HQ

Vistas del mismo database `Tasks` en Headquarters:

| Vista | Filter | Sort | Propósito |
|---|---|---|---|
| My day today | `date = today` | time, then importance | Vista de ejecución |
| Week's tasks | `date esta semana, unchecked` | importance, urgency | Vista de planificación |
| All this week | `date esta semana` | date | Vista histórica |
| My month | `date este mes` | date | Vista mensual |
| Order | `unchecked` | urgency asc, importance asc, date desc | Vista de priorización (Eisenhower) |
| Quick | `state = quick` | — | Triage para huecos cortos |
| Flow | `state = flow` | — | Triage para bloques de foco |
| Easy | `state = easy` | — | Triage para huecos medianos |
| Personal | `state = personal` | — | Triage personal-only |
| No date | `date is empty` | created | Captura sin compromiso |
| By bucket | `unchecked` | group by bucket | Anti-context-switching |

11 vistas, 1 database. La complejidad de gestión es O(1), no O(N).

## Cuándo NO aplicar

- Cuando los **schemas son genuinamente diferentes** (ej. `Books` vs `Movies` vs `Podcasts` — diferentes propiedades, no se pueden reusar)
- Cuando **el modelo relacional es complejo** y una sola table se vuelve inmanejable (ej. multi-tenant con permisos por fila)
- Cuando la **frecuencia de uso es muy diferente** (consultar 1 vez al año ≠ consultar 20 veces al día — pueden vivir separados)

## Conexiones

- [[wiki/concepts/ai-engineering-workflow-matt-pocock]] — paralelo: un solo sistema que sirve a múltiples workflows
- [[wiki/concepts/life-buckets-filtered-workspaces]] — caso de uso: vistas filtradas por bucket son instancias de este patrón
- [[wiki/concepts/energy-budget-flow-tasks]] — la vista "Flow" / "Quick" / "Easy" es este patrón
- [[wiki/concepts/dynamic-journaling]] — el journal auto-carga tasks vía filter sobre la database única
- [[wiki/sources/notion-second-brain-template-framework-5-techniques-productive-setups]] — primera formulación explícita
- [[wiki/sources/notion-second-brain-template-v1-2023-productive-setups]] — tour completo
- [[wiki/sources/notion-second-brain-template-v2-walkthrough-productive-setups]] — caso de uso real
