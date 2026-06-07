# cortex-imprint

Archivar una síntesis valiosa de la sesión actual como página permanente en el wiki.

## Cuándo invocar

Cuando el usuario invoca `/cortex-imprint` explícitamente. No invocar automáticamente — es el usuario quien decide que algo vale la pena persistir.

Casos típicos:
- Un análisis comparativo produjo una conclusión no obvia
- Una decisión de diseño quedó fundamentada y documentada
- Una conversación reveló un patrón o principio que JP querrá consultar después
- Una query respondió algo que va a ser útil en futuras sesiones

## Flujo

1. Revisar la conversación actual e identificar la síntesis principal producida
2. Proponer: tipo de página, título sugerido, ruta propuesta
3. Esperar confirmación o ajuste de JP
4. Crear la página con el template correspondiente
5. Agregar `[[wikilinks]]` a páginas relacionadas existentes
6. Actualizar `wiki/index.md`
7. Agregar entrada a `wiki/meta/log.md`: `## [YYYY-MM-DD] query | {título}`

## Tipos válidos y rutas

| Qué se produjo | Tipo | Ruta |
|----------------|------|------|
| Principio, patrón, framework | concept | `wiki/concepts/` |
| Decisión de diseño para un proyecto | page (ADR) | `wiki/pages/` |
| Análisis de una herramienta/persona | entity | `wiki/entities/` |
| Síntesis de una fuente externa | source | `wiki/sources/` |

## Reglas

- La página debe ser durable — escribirla como si JP la fuera a leer en 6 meses sin el contexto de la sesión
- No incluir referencias a la conversación ("como discutimos hoy") — el contenido debe valer por sí solo
- Verdad compilada: escribir completo, no en parches
- Si ya existe una página sobre el tema, actualizar en vez de duplicar
