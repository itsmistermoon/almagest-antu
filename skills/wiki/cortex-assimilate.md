# cortex-assimilate

Ingerir una fuente nueva y sintetizar páginas wiki a partir de ella.

## Cuándo invocar esta skill

Llamar automáticamente cuando el usuario entregue contenido nuevo con cualquiera de estas formas:
- "nueva ingesta {url o archivo}"
- "procesar {url o archivo}"
- "agregar / añadir {fuente}"
- URL entregada directamente (sin contexto adicional)
- Nombre de archivo visible en `.raw/` que aún no tiene página wiki

## Modos de entrada

### Modo URL
1. Descargar el contenido de la URL
2. Guardar en `.raw/{slug}.md` (nunca sobrescribir si ya existe)
3. Continuar con flujo de síntesis

### Modo archivo `.raw/`
1. Leer el archivo indicado en `.raw/`
2. Continuar con flujo de síntesis

## Flujo de síntesis

1. Leer el contenido fuente
2. Determinar qué crear (ver criterios abajo)
3. Para cada pieza: usar el template correspondiente como guía estructural
4. Crear páginas en la ruta correcta
5. Actualizar `wiki/index.md` con las páginas nuevas

## Tipos, rutas y templates

| Tipo | Ruta | Template |
|------|------|----------|
| **Fuente** | `wiki/sources/` | `templates/source.md` |
| **Concepto** | `wiki/concepts/` | `templates/concept.md` |
| **Entidad** | `wiki/entities/` | `templates/entity.md` |
| **Proyecto** | `wiki/pages/` | `templates/project.md` |

## Criterios para crear conceptos

**Crear** si:
- Tiene nombre propio (principio, patrón, framework, técnica, idea con identidad)
- Puede aplicarse o referenciarse en sesiones futuras
- Merece artículo propio para entenderse (no es solo un ejemplo de paso)

**Omitir** si:
- Es instancia o ejemplo concreto, no el concepto en sí
- Ya existe página wiki para ese concepto — actualizar en vez de duplicar
- Es tan genérico que no agrega valor como página separada

## Criterios para crear entidades

**Crear** si:
- Es persona, organización, herramienta o servicio con identidad propia en el vault
- Aparece en más de un contexto, o tiene un rol activo en los proyectos de JP

**Omitir** si:
- Es mencionada de pasada sin rol propio
- Ya existe página wiki para esa entidad — actualizar en vez de duplicar

## Criterios para crear proyectos

Solo crear si es un proyecto activo de JP (con repo, estado, decisiones propias).
No crear páginas de proyecto para proyectos ajenos mencionados como contexto.

## Reglas

- **Nunca modificar `.raw/`** — es inmutable
- Siempre crear una página `wiki/sources/` por fuente procesada
- Usar los templates como guía estructural — no comparar con páginas existentes para decidir qué escribir
- Si ya existe página para el tema, actualizarla en vez de crear duplicado
- Verdad compilada se escribe completa, no se acumula en parches
- Incluir `[[wikilinks]]` a páginas existentes del vault
- Si hay contradicción con contenido existente, marcarla como `[!contradiction]`
