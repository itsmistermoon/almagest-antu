---
title: Sistema de Progresión Bushidō
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [gamificacion, narrative, ux, leveling]
aliases: [bushido, niveles, subniveles, virtudes]
---

# Sistema de Progresión Bushidō

Sistema narrativo de niveles del [[wiki/pages/loyalty-platform|loyalty-platform]] basado en la cultura samurái. Implementado para [[wiki/entities/imaquinaria|Imaquinaria]] como tenant inicial.

## Niveles

| Nivel | Título | Rango XP |
|-------|--------|----------|
| 0 | Rōnin (浪人) | 0–299 |
| 1 | Samurai (侍) | 300–659 |
| 2 | Hatamoto (旗本) | 660–1739 |
| 3 | Daimyō (大名) | 1740+ |

## Estados mentales (subniveles)

Cada nivel se recorre en 3 estados:

- **Fudoshin (不動心)** — 0–20% — "mente inmóvil", estado inicial
- **Mushin (無心)** — 20–50% — "mente sin mente", flujo
- **Zanshin (残心)** — 50–100% — "mente vigilante", casi listo para ascender

## Ciclo Daimyō

Al llegar al nivel máximo (Daimyō), en vez de subir más, se recorren ciclos que desbloquean las 7 virtudes del Bushidō: **Gi (義) → Yū (勇) → Jin (仁) → Rei (礼) → Makoto (誠) → Meiyo (名誉) → Chūgi (忠義)**. Chūgi es fijo como cima narrativa desde el ciclo 8.

## Curva XP (calibrada con datos reales)

```
xp_per_1000_clp:     10
level_thresholds_xp: [0, 300, 660, 1740]
sublevel_breakpoints: [[0.20, 0.50] × 4 clases]
daimyo_cycle_xp:     360
```

**Tiempos esperados:**
- Casual (1visita/mes × $3K = 30XP/mes): Samurai en 10m, Daimyō en 50m
- Habitual (2visitas/mes × $3K = 60XP/mes): Samurai en 5m, Daimyō en 29m

## Fórmula XP/Mon

Proporcional: `(amount_clp * rate) // 1000`. Da 1 Mon/XP por cada $100 exactos (ADR-0017). No retroactivo.

---

- 2026-06-02: Página creada — síntesis de CONTEXT.md y ROADMAP.md
