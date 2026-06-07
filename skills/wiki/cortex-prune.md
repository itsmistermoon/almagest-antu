# cortex-prune

Health check del vault. Recorrer `wiki/`, compilar hallazgos por categoría ordenados por severidad, reportar y preguntar si proceder a corregir.

## Criterios de detección

### Severidad alta
- **Dead links** — `[[wikilinks]]` que apuntan a páginas que no existen en disco
- **Fuentes sin procesar** — archivos en `.raw/` sin página correspondiente en `wiki/sources/`
- **Páginas sin frontmatter** — archivos `.md` en `wiki/` sin bloque YAML

### Severidad media
- **Páginas huérfanas** — sin wikilinks entrantes desde ninguna otra página del vault
- **Proyectos activos sin fuentes vinculadas** — `wiki/pages/` con `status: active` sin ninguna fuente en `wiki/sources/` que los referencie
- **Conceptos sin wikilinks salientes** — página de concepto que no enlaza a ninguna otra (señal de conocimiento aislado)

### Severidad baja
- **Claims potencialmente desactualizados** — páginas con `updated` > 90 días que contienen afirmaciones de hecho (precios, APIs, versiones)
- **Fuentes sin tags** — `wiki/sources/` con `tags: []` vacío
- **Entidades sin apariciones** — `wiki/entities/` que no son referenciadas desde ninguna fuente ni concepto

## Output esperado

Por cada hallazgo: ruta del archivo, descripción del problema, acción sugerida.
Al final: resumen de conteos por severidad + preguntar si corregir automáticamente los de severidad baja.

## Acciones de corrección automática permitidas

- Agregar frontmatter faltante (inferir tipo desde la carpeta)
- Agregar entrada en `wiki/index.md` para páginas que existen en disco pero no están indexadas
- Agregar entrada en `wiki/meta/log.md`: `## [YYYY-MM-DD] lint | {N} hallazgos — {resumen}`

## Acciones que requieren confirmación

- Eliminar páginas huérfanas
- Marcar claims como `[!stale]`
- Crear páginas faltantes de fuentes no procesadas
