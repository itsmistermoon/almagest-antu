---
title: Obvious Code (Código Obvio)
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, legibilidad, complejidad, ousterhout]
aliases: [codigo-obvio, obviedad, legibilidad-estructural]
---

# Obvious Code

Estado ideal del código: alguien puede leerlo rápidamente y su primera impresión sobre el comportamiento será correcta. Lo opuesto a cognitive load y unknown unknowns.

## Principio

> Si código es obvio, un desarrollador puede hacer una suposición rápida sobre qué hacer, sin pensar mucho, y confiar en que es correcta.

## Lo que hace el código obvio

1. **Buenos nombres** (Cap. 14): precisos, crean una imagen mental. No genéricos.
2. **Consistencia** (Cap. 17): cosas similares se hacen de forma similar.
3. **Whitespace**: separar bloques lógicos, formatear documentación de parámetros.
4. **Comentarios estratégicos**: solo donde el código no es suficiente.
5. **Reducir información necesaria**: abstracción, eliminar special cases.

## Lo que hace el código NO obvio

- **Event-driven programming**: el flujo de control es imposible de seguir
- **Generic containers** (Pair, Tuple): `result.getKey()` no dice nada sobre el significado
- **Different types for declaration/allocation**: declarar `List` pero asignar `ArrayList`
- **Código que viola expectativas**: ej, un constructor que crea threads y el main sigue ejecutando

## Regla general

> El software debe diseñarse para facilidad de lectura, no para facilidad de escritura.

Los contenedores genéricos son expeditos para quien escribe código, pero confunden a todos los lectores que vienen después.

## Red Flags

- **Nonobvious Code**: requiere mucho esfuerzo entenderlo
- **Vague Name**: no comunica significado
- **Hard to Pick Name**: señal de que el diseño es confuso
- **Comment Repeats Code**: no agrega información más allá de lo que ya dice el código

## Conexiones

- Es el resultado de aplicar **deep modules**, **information hiding**, **consistency**, y **buenos nombres**
- La **obviedad** es la solución directa a unknown unknowns (Cap. 2)
- Fuente: [[wiki/sources/a-philosophy-of-software-design-john-ousterhout]]

---

- 2026-06-02: Página creada — síntesis de Cap. 18 (Code Should Be Obvious)
