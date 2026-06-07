---
title: Decide What Matters (Ousterhout 2da ed.)
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, priorizacion, leverage, ousterhout]
aliases: [decide-what-matters, good-taste, leverage-en-diseno]
---

# Decide What Matters

Capítulo nuevo de la 2da edición de *A Philosophy of Software Design* (2021). Propone que un elemento central del buen diseño es separar lo que importa de lo que no, y estructurar el sistema alrededor de lo que importa.

## Principio

> Structure software systems around the things that matter. For the things that don't matter as much, try to minimize their impact on the rest of the system.

Es una meta-regla que unifica muchos conceptos del libro:
- **Abstracción**: la interfaz refleja lo que importa a los usuarios; lo que no importa se oculta en la implementación.
- **Nombres**: elegir palabras que transmitan la máxima información sobre la variable.
- **Performance**: diseñar alrededor del critical path, minimizar special cases.

## Cómo decidir qué importa

Buscar **leverage**: puntos donde resolver un problema también resuelve otros. Ej: una interfaz general-purpose (como `insert/delete` del text class) resuelve muchos problemas, mientras que `backspace` resuelve solo uno.

Los **invariants** son otro punto de leverage: conocer una propiedad que siempre se cumple permite predecir comportamiento en muchas situaciones.

Si no sabes qué importa, haz una hipótesis, comprométete, construye, y aprende del resultado.

## Minimizar lo que importa

Cuantas menos cosas importen, más simple es el sistema:
- Minimizar parámetros de construcción (usar defaults)
- Ocultar información dentro de módulos
- Manejar excepciones en el nivel más bajo posible
- Calcular automáticamente configuraciones en lugar de exponerlas

## Enfatizar lo que importa

Tres formas de dar énfasis:
1. **Prominencia**: que aparezca en lugares visibles (interfaz docs, nombres, parámetros de métodos muy usados)
2. **Repetición**: ideas clave aparecen una y otra vez
3. **Centralidad**: en el corazón del sistema, determinando la estructura de lo que los rodea (ej: device driver interface en OS)

Lo que no importa debe ocultarse, no encontrarse frecuentemente, y no impactar la estructura.

## Dos errores posibles

1. **Tratar demasiadas cosas como importantes**: clutter, shallow classes, Java I/O forzando awareness de buffering.
2. **No reconocer algo importante**: información oculta, funcionalidad no disponible, unknown unknowns.

## Good Taste

> La capacidad de distinguir lo importante de lo que no.

Ousterhout lo plantea como una filosofía de vida: identifica las pocas cosas que más te importan y gasta la mayor parte de tu energía en ellas.

## Conexiones

- Es la meta-regla que unifica **deep modules**, **information hiding**, **strategic programming**, **obvious code**, **define-errors**
- Se relaciona con **design it twice**: tener múltiples opciones ayuda a identificar qué importa
- Fuente: [[wiki/sources/a-philosophy-of-software-design-john-ousterhout]] (2da edición, Cap. 21)

---

- 2026-06-02: Página creada — síntesis del Cap. 21 de la 2da edición (2021)
