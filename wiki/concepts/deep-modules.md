---
title: Deep Modules (Módulos Profundos)
type: concept
created: 2026-06-02
updated: 2026-06-02
tags: [software-design, modularidad, abstraccion, ousterhout]
aliases: [deep-module, shallow-module, profundidad-de-modulos]
---

# Deep Modules

Concepto central de *A Philosophy of Software Design*. Un **módulo profundo** es aquel que ofrece mucha funcionalidad escondida detrás de una interfaz simple. Un **módulo shallow** tiene una interfaz casi tan compleja como su implementación.

## Principio

> El mejor módulo es el que provee funcionalidad poderosa con una interfaz simple.

La profundidad se visualiza como un rectángulo: el área es la funcionalidad, el borde superior es la interfaz. Los mejores módulos tienen mucha área y poco borde.

## Ejemplo clásico: Unix I/O

Cinco syscalls (open, read, write, lseek, close) que esconden cientos de miles de líneas de implementación: sistemas de archivos, caching, scheduling de disco, permisos, devices heterogéneos. La interfaz no ha cambiado en décadas aunque la implementación evolucionó radicalmente.

## Ejemplo anti: Java I/O

```java
FileInputStream fileStream = new FileInputStream(fileName);
BufferedInputStream bufferedStream = new BufferedInputStream(fileStream);
ObjectInputStream objectStream = new ObjectInputStream(bufferedStream);
```

Tres objetos para abrir un archivo. Cada clase es shallow — el buffering es algo que debería venir por defecto. Esto es **classitis**.

## Red Flags

- **Shallow Module**: la interfaz no es mucho más simple que la implementación
- **Overexposure**: la API fuerza a conocer features poco usados para usar los comunes
- **Pass-Through Method**: método que solo delega sin agregar valor

## Conexiones

- Se logra mediante **information hiding**
- Se potencia con módulos **general-purpose** (no special-purpose)
- **Pull complexity downwards**: que el módulo absorba complejidad en lugar de filtrarla
- Se pierde con **classitis** (muchas clases pequeñas y shallow)
- Fuente: [[wiki/sources/a-philosophy-of-software-design-john-ousterhout]]

---

- 2026-06-02: Página creada — síntesis de Cap. 4 (Modules Should Be Deep)
