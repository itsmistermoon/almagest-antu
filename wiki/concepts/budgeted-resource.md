---
title: Budgeted Resource
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, brooks, gestion, trade-offs]
aliases: [budgeted-resource, recurso-presupuestado, recurso-critico, scarce-resource]
---

# Budgeted Resource

Práctica de diseño identificada por Brooks: para que un diseño (especialmente en equipo) tenga integridad conceptual, hay que **identificar explícitamente, trackear públicamente y controlar férreamente el recurso escaso**.

## Principio

> If a design, particularly a team design, is to have conceptual integrity, one should name the scarce resource explicitly, track it publicly, control it firmly.

Ese recurso cambia según el dominio:
- Arquitectura de edificios: square feet
- Arquitectura de computadores: bits de registro, ancho de banda de memoria, pines, watts
- Supercómputo: "refrigeration is the key" (Cray), capacitancia fuera del chip (Amdahl)
- Diseño industrial: manufacturing cost
- Software: puntos de función, memory, disk accesses

## El recurso puede cambiar en medio del diseño

OS/360 (1965) asumió que el recurso escaso era **memoria** (12K para el kernel en la configuración más chica). Resultó ser **disk accesses** — estaban leyendo chunks tan pequeños que compilaban 5 líneas de Fortran por minuto. Un simulador de performance (Ruthrauff) lo detectó a tiempo y el proyecto pivotó.

## Cómo aplicarlo

1. **Identify explicitly**: después de enumerar objetivos y constraints, identificar el recurso presupuestado. No es un recurso del proceso (skill allocation) sino del diseño mismo.
2. **Track publicly**: cada subequipo debe saber cuántos milliwatts, disk accesses o sq ft tiene presupuestados.
3. **Control firmly**: solo una persona controla el budgeting. Gerry Blaauw manejó los bits del Program Status Word de System/360 con "cautelosa tacañería".
4. **Keep a personal kitty**: el líder mantiene una reserva para asignación tardía, como un general con tropas de reserva.

## Conexiones

- **ETC** (PP): identificar el recurso escaso = decidir qué hace el sistema más fácil de cambiar
- **Decide What Matters** (Ousterhout 2da ed.): el budgeted resource es "lo que importa" — enfatizarlo, minimizar lo demás
- **Constraints Are Friends**: el recurso escaso es una constraint — enfoca el diseño
- Fuente: [[wiki/sources/the-design-of-design-frederick-brooks]] — Cap. 10

---

- 2026-06-02: Página creada — Cap. 10 de The Design of Design
