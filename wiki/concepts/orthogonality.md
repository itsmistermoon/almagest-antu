---
title: Orthogonality
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, pragmatismo, principios, hunt-thomas]
aliases: [ortogonalidad, independencia, decoupling]
---

# Orthogonality

Principio de diseño del *The Pragmatic Programmer*: dos o más cosas son ortogonales si **cambios en una no afectan a las otras**.

## Principio

> Eliminate effects between unrelated things.

Tomado de la geometría: dos líneas son ortogonales si se encuentran en ángulo recto, como los ejes de un gráfico. Se mueven independientemente. En software, la base de datos debe ser ortogonal a la UI: puedes cambiar la interfaz sin afectar la BD, y cambiar de BD sin tocar la interfaz.

## Anti-ejemplo: helicóptero

Un helicóptero tiene 4 controles (cyclic, collective, throttle, pedales). Pero cada input afecta a todos los demás inputs — bajar el collective hace que el nose baje, que requiere compensar con el cyclic y los pedales. Un sistema no-ortogonal donde cada cambio impacta todo.

## Beneficios

1. **Productividad**: cambios localizados → menos tiempo de desarrollo y testing. Componentes sencillos se diseñan, codean, testean y olvidan.
2. **Reuso**: componentes con responsabilidades bien definidas se combinan de formas no anticipadas.
3. **Menos riesgo**: módulos enfermos están aislados. El sistema es menos frágil.
4. **Mejor testing**: más fácil diseñar y ejecutar tests por componente.
5. **Independencia de vendor/producto**: interfaces a terceros aisladas en partes pequeñas.

## Test de ortogonalidad

> Si cambio dramáticamente los requirements detrás de una función particular, ¿cuántos módulos se ven afectados? En un sistema ortogonal, la respuesta debería ser "uno."

Mover un botón en la UI no debería requerir cambios en el esquema de BD. Agregar ayuda contextual no debería cambiar el subsistema de billing.

## Cómo lograrla

- **Diseño por capas**: cada capa usa solo las abstracciones de las capas inferiores
- **Módulos autónomos**: single well-defined purpose (cohesion)
- **Ocultar decisiones de implementación**: information hiding (Ousterhout)
- **Evitar dependencies ocultas**: el helicopter es el warning

## Conexiones

- **ETC**: la ortogonalidad es un caso concreto de "hacer fácil de cambiar"
- **Ousterhout**: information hiding + deep modules son la implementación concreta de la ortogonalidad a nivel de módulo
- **No confundir** con acoplamiento (coupling). Ortogonalidad ≠ no comunicarse — los ejes del gráfico se comunican via sus valores, pero son independientes
- Fuente: [[wiki/sources/the-pragmatic-programmer-2nd-edition]] — Topic 10

---

- 2026-06-02: Página creada — Topic 10 de The Pragmatic Programmer
