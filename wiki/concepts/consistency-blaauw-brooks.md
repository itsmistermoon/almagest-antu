---
title: Consistency in Design (Blaauw & Brooks)
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, brooks, arquitectura, consistencia]
aliases: [consistency-in-design, blaauw-brooks, orthogonality-propriety-generality]
---

# Consistency in Design (Blaauw & Brooks)

Marco de calidad arquitectónica desarrollado por Gerry Blaauw y Brooks en *Computer Architecture* (1997). Definen qué hace que un diseño técnico sea "clean" o "elegante". El principio unificador es la **consistencia**: dada una comprensión parcial del sistema, se puede predecir el resto.

## Principio

> Consistency underlies all principles of quality. A good architecture is consistent in the sense that, given a partial knowledge of the system, one can predict the remainder.

## Tres principios derivados

### Orthogonality: Do Not Link What Is Independent

Un cambio en una función ortogonal no tiene efecto observable en ninguna otra. En un despertador, la luz de la carátula y la alarma deben ser ortogonales — no que la alarma solo funcione con la luz prendida. En software: la BD debe ser ortogonal a la UI.

### Propriety: Do Not Introduce What Is Immaterial

Una función es "proper" si satisface un requisito esencial. Lo opuesto es lo extraneous — algo que está ahí por la implementación, no por necesidad del diseño. Ej: el cambio de marchas en un auto es extraneous al propósito de conducir. En computación: la representación única del cero en complemento a 2 es proper; el cero con signo en magnitud con signo es extraneous.

### Generality: Do Not Restrict What Is Inherent

El diseñador debe asumir que los usuarios serán más inventivos de lo que imagina. Cuando no sabes, concede libertad. Ej: el Restart del Intel 8080A fue diseñado para restart después de interrupción, pero se usa más para return de subrutina. La generalidad se logra con open-endedness, completitud de conjuntos de funciones, descomposición ortogonal, y composabilidad.

## Más virtudes de la consistencia

- **Auto-enseñanza**: el diseño consistente confirma y refuerza expectativas, así que el usuario aprende más rápido
- **Resuelve el conflicto facilidad-de-aprender vs. facilidad-de-usar**: si el fixed-point es un subset del floating-point, el aprendizaje puede crecer naturalmente

## Conexiones

- **Orthogonality** (PP): Brooks formaliza como principio de diseño arquitectónico
- **Decide What Matters** (Ousterhout): consistency = lo que importa se repite y es central
- **Obvious Code** (Ousterhout): un sistema consistente es obvio — puedes predecir
- **Information Hiding** (Ousterhout): la propriety (no exponer lo extraneous) es information hiding
- Fuente: [[wiki/sources/the-design-of-design-frederick-brooks]] — Cap. 12

---

- 2026-06-02: Página creada — Cap. 12 de The Design of Design (basado en Blaauw & Brooks 1997)
