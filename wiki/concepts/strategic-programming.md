---
title: Strategic Programming (Programación Estratégica)
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, mentalidad, inversion, ousterhout]
aliases: [strategic-programming, inversion-en-diseno, tactical-tornado]
---

# Strategic Programming

Mentalidad fundacional de *A Philosophy of Software Design*. Se contrapone a la **programación táctica** y propone que el objetivo principal de un desarrollador no es "código que funcione", sino **producir un gran diseño que además funciona**.

## Programación Táctica (lo que no hay que hacer)

- Prioridad: terminar la tarea lo más rápido posible
- Se aceptan pequeñas deudas técnicas ("es solo un parche")
- Cada tarea agrega un poco de complejidad
- Se acumula hasta que el sistema es inmantenible
- **Tactical tornado**: programador prolifico que produce código rápido pero deja una estela de destrucción

## Programación Estratégica (lo que hay que hacer)

- **Investment mindset**: dedicar tiempo a mejorar el diseño del sistema
- Inversiones proactivas: explorar alternativas de diseño, elegir la más limpia
- Inversiones reactivas: refactorizar al detectar problemas de diseño
- El código existente se extiende constantemente — tu trabajo más importante es facilitar esas futuras extensiones

## ¿Cuánto invertir?

Ousterhout sugiere ~10-20% del tiempo en mejoras de diseño. No es una receta exacta, pero el principio es que **las inversiones en diseño se pagan solas** al acelerar el desarrollo futuro.

## Startups y presión táctica

Las startups son particularmente propensas a la programación táctica por la presión de entregar rápido. Ousterhout advierte que esto es una trampa: la deuda técnica se acumula más rápido en equipos pequeños y la velocidad disminuye drásticamente con el tiempo. Recomienda mantener inversiones estratégicas incluso bajo presión.

## Conexiones

- Es la base para lograr **deep modules** — sin mentalidad estratégica, nadie se toma el tiempo de diseñar bien
- Se relaciona con **consistency** (otra inversión que paga dividendos)
- Se relaciona con **design it twice** (Cap. 11)
- Fuente: [[wiki/sources/a-philosophy-of-software-design-john-ousterhout]]

---

- 2026-06-02: Página creada — síntesis de Cap. 3 (Working Code Isn't Enough)
