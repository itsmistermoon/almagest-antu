---
title: Complexity is Incremental
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, complejidad, deuda-tecnica, ousterhout]
aliases: [complejidad-incremental, deuda-tecnica-incremental, zero-tolerance]
---

# Complexity is Incremental

Principio transversal de *A Philosophy of Software Design*: la complejidad no llega por un desastre catastrófico, sino por cientos de pequeñas decisiones que acumulan dependencias y oscuridades.

## Principio

> Una sola dependencia u oscuridad adicional rara vez afecta significativamente la mantenibilidad. Pero cientos o miles de ellas hacen que cualquier cambio sea afectado por múltiples problemas.

## Por qué es difícil de controlar

- Es fácil auto-convencerse: "esta pequeña complejidad adicional no es problema"
- Si cada desarrollador hace esto en cada cambio, la complejidad se acumula rápidamente
- Una vez acumulada, es difícil de eliminar: arreglar una sola dependencia no hace gran diferencia
- Se requiere una filosofía de **tolerancia cero**

## La fórmula de la complejidad

La complejidad total de un sistema (C) = suma de la complejidad de cada parte (cp) ponderada por la fracción de tiempo que los desarrolladores pasan en esa parte (tp).

Implicación: aislar complejidad en un lugar que casi nunca se toca es casi tan bueno como eliminarla.

## Tres síntomas

1. **Change amplification**: un cambio simple requiere modificar muchos archivos
2. **Cognitive load**: cuánto hay que saber para hacer una tarea
3. **Unknown unknowns**: no sabes qué código modificar ni qué información necesitas. El peor de los tres.

## Dos causas raíz

- **Dependencias**: cuando un código no puede entenderse/modificarse en aislamiento
- **Oscuridad**: cuando información importante no es obvia (nombres genéricos, falta de documentación, inconsistencia)

## Conexiones

- Es la motivación detrás de **strategic programming**: sin inversión constante, la complejidad incremental te come
- Se combate con **deep modules** (aislan complejidad), **information hiding** (reducen dependencias), y **obvious code** (reducen oscuridad)
- Fuente: [[wiki/sources/a-philosophy-of-software-design-john-ousterhout]]

---

- 2026-06-02: Página creada — síntesis de Cap. 2 (The Nature of Complexity)
