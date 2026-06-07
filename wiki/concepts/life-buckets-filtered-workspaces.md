---
title: Life Buckets (Workspaces Filtrados)
type: concept
created: 2026-06-07
updated: 2026-06-07
tags: [productivity, pkm, second-brain, notion, workspace-design, productive-setups]
aliases: [life-buckets, filtered-workspaces, context-views]
---

# Life Buckets (Workspaces Filtrados)

## Principio

Un **Life Bucket** es un dominio de la vida (Job, Relationships, Family, Study, Fitness, etc.) que tiene su propia página-workspace. Lo crítico: **el workspace no es una copia** de tus datos — es un **filtered view** de las mismas bases de datos globales (Tasks, Notes, Projects), filtrado por la propiedad `bucket`.

Resultado: una sola fuente de verdad, múltiples lentes contextuales.

## Cómo funciona

```
[Tasks DB]  ← propiedad: bucket
   ├─ filter bucket=Job        → "Job HQ" page
   ├─ filter bucket=Study      → "Study HQ" page
   ├─ filter bucket=Fitness    → "Fitness HQ" page
   └─ filter bucket=Relationships → "Relationships HQ" page
```

Cada HQ page muestra:
- Tareas pendientes del bucket
- Proyectos activos del bucket
- Notas recientes del bucket
- (A veces) calendar view time-blocked

## Por qué importa

- **Reducción de contexto mental**: cuando estás en "modo trabajo", no quieres ver "tennis a las 18:00" mezclado con tus reports — solo lo relevante al bucket activo
- **Single source of truth**: si editas una task en el Job HQ, se actualiza globalmente (no hay desincronización)
- **Mobile + Desktop diferenciados**: el mobile HQ puede ser una vista simplificada sin time-blocking para captura rápida
- **Onboarding de dominios nuevos**: agregar un bucket = agregar una propiedad + crear un nuevo HQ view. La estructura no cambia

## Variantes del patrón

| Variante | Cuándo usar |
|----------|-------------|
| **Life Buckets** (estilo Productive Setups) | Productividad personal, separar por dominio de vida |
| **Projects as Buckets** | Equipos, separar por cliente/iniciativa |
| **Clients as Buckets** | Freelance/agencia, separar por cliente |
| **Time-based Buckets** (Daily/Weekly) | Views temporales, no por dominio |

## Diferencia con subcarpetas / sub-wikis

| Subcarpeta | Life Bucket (filtered view) |
|-----------|----------------------------|
| Datos duplicados / movidos | Datos compartidos, vista filtrada |
| Difícil de agregar propiedad | Fácil de re-clasificar cambiando el tag |
| Requiere sync manual | Sync automático (es la misma fila) |
| Estructura rígida | Flexible, multi-tag |

## Aplicabilidad a un vault markdown/Obsidian

En Obsidian, el equivalente son los **frontmatter properties** + Dataview queries:

```dataview
LIST
FROM "wiki"
WHERE bucket = "loyalty-platform" AND status = "active"
```

O los [[tags]] transversales. La diferencia: el wiki actual no tiene una propiedad `bucket` sistemática — usa tags, proyectos en `wiki/pages/`, y entidades. La estructura es **proyecto-céntrica**, no **bucket-céntrica** como Headquarters.

## Cuándo usar Life Buckets
- Productividad personal con dominios bien separados (trabajo / vida personal / estudio)
- Sistemas donde el **contexto** (no el proyecto) define lo que necesitas ver
- Cuando un "Project HQ" se siente demasiado granular y necesitas un nivel superior

## Cuándo NO usar
- Sistemas donde todo está bajo un mismo dominio (proyectos de software de un mismo equipo)
- Cuando los proyectos cruzan buckets (un side-project toca Study + Job + Fitness)
- Vaults pequeños donde el filtrado no aporta valor

## Conexiones
- [[wiki/sources/notion-second-brain-template-productive-setups]] — fuente canónica (versión 2025)
- [[wiki/sources/notion-second-brain-template-original-productive-setups]] — versión 2024 que introduce el matiz de "Today's Context"
- [[wiki/entities/productive-setups]] — autor del framework
- [[wiki/pages/second-brain]] — el vault actual es proyecto-céntrico, no bucket-céntrico; vale la pena notar la diferencia arquitectónica
- [[wiki/concepts/patron-adaptadores-analisis]] — paralelo: misma idea de vista filtrada de una fuente canónica
