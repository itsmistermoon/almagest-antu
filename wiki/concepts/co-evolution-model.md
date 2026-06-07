---
title: Co-Evolution Model of Design
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, brooks, proceso, iteracion]
aliases: [co-evolution-model, coevolucion-problema-solucion, maher-poon-boulanger]
---

# Co-Evolution Model of Design

Modelo formal de Maher, Poon y Boulanger (1996) que Brooks adopta como mejor alternativa al Rational Model (waterfall). Propone que el **problema** y la **solución** co-evolucionan durante el diseño.

## Principio

> Creative design is not a matter of first fixing the problem and then searching for a satisfactory solution concept. Instead, it seems more to be a matter of developing and refining together both the formulation of a problem and ideas for its solution.

Evolución se usa laxamente: tanto el entendimiento del problema como el desarrollo de la solución se generan y evalúan incrementalmente.

## Implicaciones

- **No hay requirements upfront**: "un servicio principal del diseñador es ayudar a los clientes a descubrir lo que quieren diseñar"
- **Prototyping es indispensable**: sin un prototipo, el cliente no sabe lo que quiere, y el diseñador no sabe lo que el cliente necesita
- **Goal iteration**: a medida que el diseño avanza, la situación "talk back" (Schön), y el diseñador responde refinando tanto el problema como la solución
- **Los desiderata cambian**: en la remodelación de su casa, una pregunta tardía "¿dónde pondrán los abrigos los invitados?" movió el dormitorio principal de un extremo a otro

## Co-Evolution vs. otros modelos

| Modelo | Problema | Solución |
|--------|----------|----------|
| Waterfall | Fijo upfront | Diseñada de una vez |
| Spiral (Boehm) | Se refina iterativamente | Se construye incrementalmente |
| Co-Evolution | Co-evoluciona con la solución | Co-evoluciona con el problema |

## Conexiones

- **Tracer Bullets** (PP): implementación concreta — un end-to-end funcional desde el día 1 permite que problema y solución co-evolucionen
- **Design it Twice** (Ousterhout): explorar alternativas es parte de la co-evolución
- **Strategic Programming** (Ousterhout): invertir tiempo en refinar el problema y la solución juntos
- Fuente: [[wiki/sources/the-design-of-design-frederick-brooks]] — Cap. 5

---

- 2026-06-02: Página creada — Cap. 5 de The Design of Design
