---
title: Constraints Are Friends
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, brooks, creatividad, restricciones]
aliases: [constraints-are-friends, restricciones, limitaciones-en-diseno]
---

# Constraints Are Friends

Principio de *The Design of Design*: las restricciones reducen el espacio de búsqueda del diseñador, enfocan y aceleran el diseño.

## Principio

> Constraints shrink the designer's search space. By so doing, they focus and speed design.

Bach prefería trabajar dentro de marcos establecidos. Michelangelo esculpió su David de un bloque de mármol "abandonado" por otros 25 años por inutilizable. Las 50 iglesias de Wren tenían orientación fija (altar al este) — forzó soluciones distintas y brillantes para cada sitio.

## Tipos de constraints

1. **Reales**: leyes de la física, presupuesto, plazo inamovible
2. **Desactualizadas**: constraints que ya no aplican por cambio tecnológico (ej: "10 pounds in a 5-pound sack" de memoria — crucial en 1965, irrelevante en 1975)
3. **Malpercibidas**: el puzzle de los 9 puntos donde la solución requiere salir del cuadrado imaginario. Multiplicación de matrices 2x2 en 7 pasos (Strassen) requiere descartar la restricción percibida de usar operaciones vectoriales.
4. **Artificiales intencionales**: uno mismo se las impone para forzar creatividad

## Hasta cierto punto

Las constraints pueden empujar al diseñador a un "empty corner" donde ningún diseño funciona. El arte está en distinguir los tipos.

## Anti-patrón: FAA 9020

El caso del IBM 9020 para la FAA: los arquitectos de MITRE especificaron una topología de configuración como constraint, cuando lo que necesitaban era *función y confiabilidad*. La solución propuesta por IBM (usando el mismo modelo de computadora) cumplía todos los requisitos funcionales y de confiabilidad *mejor* que la topología especificada. Fue rechazada por no cumplir la topología. La solución entregada (con más componentes, más conectores, menos confiable) cumplía la letra pero no el espíritu.

> When you specify something to be designed, tell what properties you need, not how they are to be achieved.

## Conexiones

- **Define errors out of existence** (Ousterhout): cambiar constraints (redefinir la semántica) para eliminar errores
- **Co-Evolution Model**: las constraints cambian durante el diseño — a veces desaparecen
- **Pragmatic Philosophy** (PP): "misperceived constraints" = broken windows que te acostumbras a ignorar
- Fuente: [[wiki/sources/the-design-of-design-frederick-brooks]] — Cap. 11

---

- 2026-06-02: Página creada — Cap. 11 de The Design of Design
