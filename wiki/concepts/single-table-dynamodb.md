---
title: Single-table DynamoDB Design
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [dynamodb, arquitectura, nosql, aws]
---

# Single-table DynamoDB Design

Patrón de modelado de datos donde todas las entidades del dominio conviven en una misma tabla de DynamoDB, diferenciadas por prefijos en las claves (PK/SK). El diseño se guía por **access patterns** primero — no por normalización relacional.

## Principio

> En DynamoDB primero se definen los access patterns y después se modela la tabla. Es el opuesto del flujo SQL.

## Implementación en loyalty-platform

Tabla única `loyalty-platform-{env}` con:

- `pk = TENANT#{tenant_id}` — partición por tenant
- `sk = TIPO#{id}` — sort key con prefijo por entidad
- 3 GSIs para patterns que no caben en la tabla base
- Billing: PAY_PER_REQUEST

### Prefijos de entidad

| Prefijo | Entidad |
|---------|---------|
| `CLIENT#` | Cliente |
| `TXN#` | Transacción (compra) |
| `REWARD#` | Recompensa (catálogo) |
| `REDEMPTION#` | Canje |
| `STAMPCARD_TPL#` | Plantilla de stamp card |
| `STAMPCARD_PROG#` | Progreso de stamp card |
| `METADATA` | Config del tenant |
| `ANNOUNCEMENT#` | Anuncios (Fokuda) |
| `NOTIFICATION#` | Feed de actividad |
| `MIGRATIONS#GLOBAL` | Tracking de migraciones |

### Access patterns clave

- T1: Obtener config de tenant → `pk=TENANT#tid, sk=METADATA`
- C1-C5: CRUD de cliente por ID, RUT (GSI1), email (GSI2), listado del tenant
- TR1-TR3: Historial de transacciones por cliente
- R1-R2: Catálogo de recompensas
- RE1-RE2: Canjes por cliente

### Regla de oro

Todo query sin `tenant_id` es un bug, no una simplificación.

---

- 2026-06-02: Página creada — síntesis de DATA_MODEL.md y principios del proyecto loyalty-platform
