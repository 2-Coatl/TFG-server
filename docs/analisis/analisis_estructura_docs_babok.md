# Análisis de la estructura documental frente a BABOK

## Objetivo
Evaluar el grado de alineación de la documentación del proyecto con las áreas de conocimiento del BABOK v3 para identificar brechas y oportunidades de mejora.

## Resumen ejecutivo
La estructura actual cubre parcialmente la planificación de la estrategia (Business Analysis Planning and Monitoring) a través de los ADR, pero carece de artefactos formales para el análisis de stakeholders y la gestión de requisitos. Se recomienda incorporar plantillas ligeras que permitan rastrear decisiones y necesidades del negocio.

## Mapeo de componentes
| Área BABOK | Evidencia en el repositorio | Observaciones |
| --- | --- | --- |
| Business Analysis Planning and Monitoring | `docs/adr/0001-ejecucion-codex.md` | Documenta la decisión clave, pero no describe métricas de éxito ni responsables. |
| Elicitation and Collaboration | No se encontraron documentos específicos. | Sería útil registrar sesiones de entrevistas o discovery técnico. |
| Requirements Life Cycle Management | No existen tableros o registros de trazabilidad. | Proponer un registro de requisitos mínimo viable en Markdown. |
| Strategy Analysis | README y ADR establecen objetivos generales. | Profundizar en métricas de valor y hipótesis verificables. |
| Solution Evaluation | No hay informes de evaluación post-implementación. | Añadir plantillas para lecciones aprendidas tras entregas. |

## Recomendaciones
1. **Plantilla de actas de elicitation**: crear un formato reutilizable en `docs/plantillas/` para capturar expectativas y riesgos.
2. **Registro de requisitos**: mantener una matriz simple de requisitos con estados y responsables.
3. **Indicadores de éxito**: agregar una sección en cada ADR que identifique criterios de aceptación y métricas.

## Próximos pasos
- Priorizar la creación de la matriz de requisitos en el próximo sprint.
- Definir responsables para mantener actualizados los artefactos propuestos.
