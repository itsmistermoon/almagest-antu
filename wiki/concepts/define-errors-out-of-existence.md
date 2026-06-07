---
title: Define Errors Out Of Existence
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, errores, complejidad, ousterhout]
aliases: [definir-errores-fuera-de-existencia, error-handling-design]
---

# Define Errors Out Of Existence

Técnica de diseño que propone modificar la semántica de las operaciones para que los casos excepcionales desaparezcan, en lugar de manejarlos explícitamente con excepciones.

## Principio

> El manejo de excepciones es una de las peores fuentes de complejidad. La mejor forma de reducir esa complejidad es reducir la cantidad de lugares donde deben manejarse excepciones.

## Cuatro técnicas

### 1. Definir errores fuera de existencia

Cambiar la semántica para que el "error" sea un caso normal.

- **Tcl unset**: en lugar de lanzar error si la variable no existe, redefinir como "asegurar que la variable no existe". Si ya no existe, no hay nada que hacer.
- **Unix file deletion**: eliminar un archivo abierto no falla. Se marca para eliminar, los procesos existentes siguen accediéndolo, se libera cuando todos lo cierran. Define dos errores: el delete en sí y el acceso concurrente.
- **Java substring**: en lugar de lanzar IndexOutOfBoundsException, truncar automáticamente al rango válido (como hace Python).

### 2. Mask exceptions

Manejar el error en el nivel más bajo posible para que no se propague.

Ej: RAMCloud maneja crashes de servidores NFS internamente — la aplicación nunca ve el error.

### 3. Exception aggregation

Agrupar múltiples excepciones relacionadas en un solo manejo.

### 4. Crash

Cuando el error es realmente excepcional (no recuperable), a veces es mejor crash que propagar complejidad.

## Por qué menos excepciones = menos bugs

Puede sonar contra-intuitivo: ¿no detectar errores no causa más bugs? Ousterhout argumenta que **el exceso de detección de errores aumenta la complejidad** (código adicional, casos difíciles de probar), y esa complejidad introduce bugs. El mejor camino para reducir bugs es software más simple.

## Red Flags

- Excepciones innecesarias en APIs (ej: Java substring)
- Manejo de errores que es más código que la lógica normal
- Excepciones que se definen porque "es mejor detectar errores"

## Conexiones

- Se relaciona con **design it twice**: a menudo una segunda iteración revela formas de eliminar casos especiales
- Se relaciona con **pull complexity downwards**: el módulo bajo absorbe la complejidad del error
- Fuente: [[wiki/sources/a-philosophy-of-software-design-john-ousterhout]]

---

- 2026-06-02: Página creada — síntesis de Cap. 10 (Define Errors Out Of Existence)
