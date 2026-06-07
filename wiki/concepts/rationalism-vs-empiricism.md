---
title: Rationalism vs. Empiricism in Design
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, brooks, filosofia, metodologia]
aliases: [rationalism-vs-empiricism, racionalismo-vs-empirismo, brooks-empiricist]
---

# Rationalism vs. Empiricism in Design

Brooks plantea una pregunta fundamental: **¿puedo, solo con pensamiento suficiente, diseñar un objeto complejo correctamente?** Los racionalistas (Descartes, Dijkstra) creen que sí. Los empiricistas (Locke, Brooks) creen que no.

## Principio

> Rationalists believe I can [design correctly by thought alone]; empiricists believe I cannot.

- **Racionalismo**: el hombre es inherentemente sólido, perfectible por educación. Con pensamiento suficientemente cuidadoso, un diseñador puede hacer un diseño impecable. La tarea de la metodología es aprender a razonar un diseño hasta la impecabilidad.
- **Empiricismo**: el hombre es inherentemente falible. Todo lo que haga tendrá fallas. La tarea de la metodología es aprender a determinar las fallas mediante experimentación e iteración.

## Brooks: "Dyed-in-the-Wool Empiricist"

Brooks se declara empiricista convencido. Solo dos veces en su vida escribió un programa que funcionó perfecto la primera vez. Una de esas fue su programa de tesis en Harvard (1953) — 1,500 líneas, revisadas a mano con un compañero durante semanas. Insostenible como práctica regular.

## Aplicación al software

Dijkstra argumentaba que un programa es un objeto matemático y puede diseñarse correctamente con pensamiento cuidadoso + proof. Brooks contraargumenta:

- Formal proof tiene valor para kernels de sistemas seguros (seL4), pero es tan caro como construir el programa
- Ninguna proof demuestra que los objetivos originales fueran correctos
- La técnica de **Cleanroom** (Mills): escrutinio grupal intenso del diseño — un balance práctico entre proof formal y nada

## En otros dominios

Ningún otro dominio de diseño (puentes, edificios, chips) intenta proof de corrección formal. Usan simulación, análisis, walk-throughs. Pero ninguna de estas técnicas address la validez de los goals o assumptions.

## Conexiones

- **Empiricist approach** = prototyping, iteración, testing (alineado con **Tracer Bullets**, **Co-Evolution Model**)
- **Rationalist approach** = diseño upfront, waterfall, proof-based correctness
- **Define errors out of existence** (Ousterhout): enfoque empiricista — el error existe, se maneja diseñando mejor
- **Strategic Programming** (Ousterhout): la inversión estratégica es empiricista (prueba y refina), no racionalista (diseña todo upfront)
- Fuente: [[wiki/sources/the-design-of-design-frederick-brooks]] — Cap. 8

---

- 2026-06-02: Página creada — Cap. 8 de The Design of Design
