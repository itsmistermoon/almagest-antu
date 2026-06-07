---
title: DRY — Don't Repeat Yourself
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, pragmatismo, principios, hunt-thomas]
aliases: [dry, don-t-repeat-yourself, no-te-repitas]
---

# DRY — Don't Repeat Yourself

Uno de los principios más famosos (y malentendidos) de *The Pragmatic Programmer*. DRY no es sobre código duplicado — es sobre **duplicación de conocimiento**.

## Principio

> Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.

DRY opera al nivel del **conocimiento**, no al nivel del código. El acid test: cuando un aspecto del código cambia, ¿tienes que hacer ese cambio en múltiples lugares y formatos distintos? Si sí, tu código no es DRY.

## Lo que NO es DRY

En la 1ra edición, los autores hicieron una mala pega explicándolo, y muchos lo tomaron como "no copies y pegues código". Esa es la parte *trivial* y *pequeña* de DRY. El verdadero DRY abarca:

- **Código**: sí, no copiar y pegar lógica
- **Documentación**: si documentas un comportamiento y el código cambia, ahora tienes dos verdades
- **Esquemas de BD**: si defines la misma info en SQL y en structures de código
- **Procesos**: scripts manuales vs. documentación vs. conocimiento tácito del equipo
- **Datos**: que la misma información esté calculable desde otra en lugar de almacenarse redundante

## Cómo lograrlo

1. **Código**: extraer funciones, DRY es trivial en código
2. **Documentación**: generar docs desde código (Doxygen, Javadoc), o mantenerlas pegadas al código (cap. 16 de Ousterhout)
3. **Entre developers**: comunicación activa (standups, Slack, code reviews). Nombrar un *project librarian*.
4. **Make It Easy to Reuse**: si es más fácil reusar que escribir de nuevo, la gente va a reusar.

## Conexiones

- **ETC** es el principio que unifica DRY: si no repites conocimiento, cambiar es más fácil
- **Ousterhout**: DRY se relaciona con **information leakage** y **strategic programming** (invertir en estructuras que no requieran duplicación)
- **No confundir** con `WET` (Write Everything Twice — el anti-patrón)
- Fuente: [[wiki/sources/the-pragmatic-programmer-2nd-edition]] — Topic 9

---

- 2026-06-02: Página creada — Topic 9 de The Pragmatic Programmer
