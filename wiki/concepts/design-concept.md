---
title: Design Concept
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, brooks, arquitectura, abstraccion]
aliases: [design-concept, concepto-de-diseno, integridad-conceptual, entidad-platonica]
---

# Design Concept

Entidad platónica del diseño, identificada por Rachael Luck en conversaciones de diseño arquitectónico. Es la **Idea** del diseño que existe independientemente de sus representaciones (planos, código, prototipos). Brooks la experimentó con System/360: el "verdadero" System/360 no estaba en el hardware sino en *Principles of Operation*.

## Principio

> El diseño real no está en los planos ni en el código, sino en la Idea. La representación más completa de System/360 no era el hardware sino el manual.

Brooks conecta esto con Dorothy Sayers (*The Mind of the Maker*): el proceso creativo tiene tres aspectos — Idea, Energy (Implementation), Interaction (Uso).

## Por qué importa

1. **Integridad conceptual**: los grandes diseños tienen unidad, economía, claridad. Reconocer el Design Concept como entidad ayuda a buscar su integridad.
2. **Comunicación en equipo**: hablar del Design Concept directamente (no de representaciones derivadas) facilita la conversación. Los storyboards en cine cumplen este rol.
3. **La regla de 7±2**: solo un número limitado de diseñadores puede compartir un Design Concept. Si el equipo es grande, el concepto debe residir en la mente de uno o de un núcleo pequeño que habla constantemente.

## Casa View/360

Brocks experimentó el mismo fenómeno con su casa de playa. El Design Concept se volvió real mucho antes de que empezara la construcción, y persistió a través de múltiples versiones de planos y maquetas de cartón.

## Conexiones

- Relacionado con **abstracción** en Ousterhout (Cap. 4) — la interfaz de un módulo es una forma de Design Concept
- Se pierde con **information leakage** y **temporal decomposition**
- El Design Concept debe ser estable para que deep modules funcionen
- Fuente: [[wiki/sources/the-design-of-design-frederick-brooks]] — Cap. 1

---

- 2026-06-02: Página creada — Cap. 1 de The Design of Design
