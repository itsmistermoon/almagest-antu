---
title: Tracer Bullets
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, pragmatismo, desarrollo, hunt-thomas]
aliases: [tracer-bullets, balas-trazadoras, desarrollo-iterativo, vertical-slice]
---

# Tracer Bullets

Técnica de desarrollo descrita en *The Pragmatic Programmer*. Inspirada en las balas trazadoras (tracer bullets) de las ametralladoras: en lugar de apuntar una vez y disparar, disparas **balas trazadoras** que iluminan su trayectoria, permitiendo ajustar el objetivo en tiempo real.

## Principio

> Desarrollar un end-to-end completo desde el principio, con código real (no prototipos), e ir refinándolo iterativamente.

En lugar de construir la base y luego agregar features, construyes un **esqueleto funcional** de todo el sistema:

- Mínima funcionalidad end-to-end
- Código real, que va a producción (a diferencia de prototipos que se descartan)
- Refinamiento continuo basado en feedback

## Tracer Bullets vs. Prototypes

| Aspecto | Tracer Bullets | Prototypes |
|---------|---------------|------------|
| Objetivo | Probar arquitectura end-to-end | Explorar riesgos específicos |
| Destino | Código de producción | Código descartable |
| Duración | Toda la vida del proyecto | Temporal (días/semanas) |
| Feedback | Ajuste continuo de trayectoria | Lección aprendida |
| Riesgo | Mínimo (siempre hay algo funcional) | Depende de la fidelidad |

## Beneficios

1. **Los usuarios ven algo funcionando rápido**: feedback real temprano
2. **Los desarrolladores construyen una plataforma para trabajar**: en lugar de esperar a que la infraestructura esté lista
3. **Integración continua desde el día 1**: no hay "integration hell"
4. **Siempre hay algo demostrable**: cada iteración produce una versión funcional
5. **Más fácil de estimar**: porque ya tienes experiencia real con la trayectoria

## Cuándo usarlo

Siempre, excepto cuando estás explorando algo radicalmente nuevo (ahí prototype primero). Para features, arquitecturas, APIs — tracer bullets todo el camino.

## Conexiones

- **Ousterhout**: strategic programming se alinea con tracer bullets — la inversión en diseño no es upfront masiva sino iterativa
- **Design it Twice** (Ousterhout): explora alternativas en prototipos, luego tracer bullets para implementar la elegida
- **Agile**: tracer bullets son una implementación concreta del desarrollo iterativo
- **Contraste**: waterfall asume que puedes apuntar una vez y acertar; tracer bullets reconocen que el target se mueve
- Fuente: [[wiki/sources/the-pragmatic-programmer-2nd-edition]] — Topic 12

---

- 2026-06-02: Página creada — Topic 12 de The Pragmatic Programmer
