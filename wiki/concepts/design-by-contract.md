---
title: Design by Contract (DBC)
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, pragmatismo, correccion, hunt-thomas]
aliases: [dbc, design-by-contract, diseno-por-contrato]
---

# Design by Contract (DBC)

Técnica formalizada por Bertrand Meyer (lenguaje Eiffel) y adoptada por *The Pragmatic Programmer* como parte de la **Pragmatic Paranoia**: no confiar ni siquiera en uno mismo.

## Principio

Toda función o método tiene un **contrato** con sus llamantes:
- **Precondiciones**: lo que debe ser verdad para que la rutina sea llamada. Responsabilidad del llamante.
- **Postcondiciones**: lo que la rutina garantiza al terminar. Implica que la rutina concluye (sin loops infinitos).
- **Invariants de clase**: condición que siempre es verdad desde la perspectiva del llamante.

> If all preconditions are met, the routine shall guarantee that all postconditions and invariants will be true when it completes.

## Violación = Bug

Si el contrato se rompe, es un bug — no algo que deba ocurrir. Las precondiciones **no deben usarse para validación de input de usuario**. La validación de input es otro tema; DBC es sobre corrupción interna.

## Implementación en lenguajes

- **Clojure**: soporte nativo con `:pre` y `:post` conditions
- **Eiffel**: el lenguaje que originó DBC
- **Python**: PEP 316 (proposal), o usar `assert` + decorators
- **Java/C#**: librerías como contract4j, Code Contracts
- **TypeScript**: `zod` o validación runtime con tipos — no es DBC puro pero se acerca

## DBC vs. Programación Defensiva

DBC no es programación defensiva. En DBC, si el llamante viola una precondición, es su culpa — el programa puede crashear o lanzar excepción. En programación defensiva, tratas de manejar cualquier input. DBC es mejor porque detecta bugs temprano y documenta explícitamente los contratos.

## Red Flags

- Usar precondiciones para validar input de usuario (eso es manejo de errores, no DBC)
- No documentar pre/post conditions porque "el código se explica solo"
- Tratar de manejar internamente violaciones de precondiciones

## Conexiones

- **Dead Programs Tell No Lies**: si el contrato se rompe, mejor terminar que propagar estado corrupto
- **Assertive Programming**: assert things that "can't happen" — es una forma de DBC
- **Ousterhout**: define errors out of existence — a veces el contrato se puede redefinir para que el error no exista
- Fuente: [[wiki/sources/the-pragmatic-programmer-2nd-edition]] — Topic 23

---

- 2026-06-02: Página creada — Topic 23 de The Pragmatic Programmer
