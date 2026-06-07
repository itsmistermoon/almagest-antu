---
title: Information Hiding (Ousterhout)
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, modularidad, abstraccion, ousterhout]
aliases: [information-hiding, informacion-oculta, parnas]
---

# Information Hiding

Técnica fundamental de diseño de software, formalizada por David Parnas (1972) y central en la filosofía de Ousterhout. Cada módulo debe encapsular piezas de conocimiento (decisiones de diseño) que no aparecen en su interfaz.

## Principio

> El conocimiento embebido en la implementación de un módulo debe ser invisible para otros módulos.

Esto reduce complejidad de dos formas:
1. **Simplifica la interfaz** — reduce carga cognitiva de quienes usan el módulo
2. **Facilita evolución** — cambiar una decisión oculta solo afecta a un módulo

## Information Leakage (anti-patrón)

Ocurre cuando el mismo conocimiento se refleja en múltiples módulos. Es **el red flag más importante** en diseño de software.

Ejemplo: dos clases que entienden el formato de un mismo archivo (una lo lee, otra lo escribe). Si el formato cambia, ambas deben modificarse.

**Solución**: combinar las clases en una sola que encapsule el conocimiento del formato, o extraerlo a una nueva clase con interfaz simple.

## Temporal Decomposition (causa común de leakage)

Estructurar el código según el orden temporal de ejecución. Ej: una clase para leer HTTP request y otra para parsearlo — ambas necesitan entender la estructura del request.

**Solución**: fusionar en una clase que maneje todo el ciclo de lectura+parsing.

## Lo que NO es information hiding

Declarar métodos/variables `private` no es suficiente. Si getters/setters exponen la naturaleza de los datos internos, el "hiding" es ilusorio. La mejor forma es cuando la información es **totalmente invisible** para quien usa el módulo.

## Red Flags

- **Information Leakage**: mismo conocimiento en múltiples módulos
- **Temporal Decomposition**: estructura basada en orden, no en conocimiento
- **Overexposure**: API expone representaciones internas (ej: getParams() devuelve el Map interno)

## Conexiones

- Es la técnica principal para lograr **deep modules**
- Se potencia con módulos **general-purpose**
- Parnas, "On the Criteria to be Used in Decomposing Systems into Modules" (1972) — paper fundacional
- Fuente: [[wiki/sources/a-philosophy-of-software-design-john-ousterhout]]

---

- 2026-06-02: Página creada — síntesis de Cap. 5 (Information Hiding and Leakage)
