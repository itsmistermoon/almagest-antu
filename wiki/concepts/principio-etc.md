---
title: ETC — Easier to Change
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, pragmatismo, principios, hunt-thomas]
aliases: [etc, easier-to-change, principio-etc]
---

# ETC — Easier to Change

Principio unificador de diseño de *The Pragmatic Programmer*. Toda decisión de diseño, toda herramienta, toda práctica debe evaluarse con la pregunta: **¿esto hace el sistema más fácil de cambiar?**

## Principio

> A thing is well designed if it adapts to the people who use it. For code, that means it must adapt by changing. So we believe in the ETC principle: Easier to Change.

## ETC como valor, no como regla

Los valores ayudan a tomar decisiones: "¿debería hacer esto o aquello?" ETC es una brújula que te guía, no un checklist. Debe flotar justo detrás de tu consciencia, empujándote sutilmente en la dirección correcta.

Para internalizarlo: durante una semana, pregúntate deliberadamente "lo que acabo de hacer, ¿hizo el sistema más fácil o más difícil de cambiar?" Al guardar un archivo, al escribir un test, al arreglar un bug.

## ¿Por qué todo principio de diseño es ETC?

- **Decoupling**: porque aislar concerns hace cada uno más fácil de cambiar
- **Single Responsibility Principle**: porque un cambio en requirements se refleja en un solo módulo
- **Good names**: porque leer el código es necesario para cambiarlo
- **DRY**: porque si cambias conocimiento en un solo lugar, cambiar es más fácil
- **Orthogonality**: porque cambios en un área no afectan otras

## Cómo aplicarlo cuando no sabes qué cambiará

1. **Haz todo reemplazable**: desacoplar, mantener cohesión. Si algo cambia, este chunk no será un bloqueo.
2. **Trátalo como desarrollo de instinto**: anota la situación en tu daybook, las opciones, y tus conjeturas. Cuando el código cambie, revisa si acertaste.

## Conexiones

- **Unifica** todos los otros principios de PP (DRY, orthogonality, decoupling, reversibility) y de Ousterhout (deep modules, information hiding, strategic programming)
- PP dice el "por qué" (ETC), Ousterhout dice el "cómo concreto"
- Fuente: [[wiki/sources/the-pragmatic-programmer-2nd-edition]] — Topic 8

---

- 2026-06-02: Página creada — Topic 8 de The Pragmatic Programmer
