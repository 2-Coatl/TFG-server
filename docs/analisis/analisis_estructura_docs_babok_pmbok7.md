# Evaluación de alineación BABOK y PMBOK 7

## Propósito
Analizar cómo la documentación actual soporta tanto la perspectiva de análisis de negocio (BABOK) como los dominios de desempeño del PMBOK Séptima Edición.

## Hallazgos clave
- **Gobernanza**: existen decisiones registradas en `docs/adr/`, pero falta explicitar cómo se actualizan y comunican.
- **Stakeholders**: no se dispone de un registro actualizado; esto limita la colaboración efectiva descrita por BABOK y el dominio de Stakeholders del PMBOK.
- **Valor**: la propuesta de valor del TFG se encuentra en README, aunque sin métricas de validación.
- **Ciclo de vida**: la guía de TDD en README describe prácticas de desarrollo, pero no un ciclo de vida integral del producto.

## Tabla de correlación
| Dominio PMBOK 7 | Área BABOK relacionada | Evidencia | Observaciones |
| --- | --- | --- | --- |
| Stakeholder | Elicitation and Collaboration | No hay actas ni mapa de interesados. | Priorizar la creación de un registro de stakeholders y su impacto. |
| Team | Business Analysis Planning and Monitoring | README promueve TDD pero no define roles. | Documentar responsabilidades y expectativas del equipo. |
| Development Approach and Life Cycle | Requirements Life Cycle Management | Suite de pruebas en `tests/` sigue TDD. | Ampliar con un roadmap de releases y gestión de versiones. |
| Measurement | Strategy Analysis | No existen indicadores cuantitativos. | Proponer OKR o métricas de producto ligadas a entregables. |
| Uncertainty | Solution Evaluation | No hay gestión explícita de riesgos. | Incorporar un registro de riesgos en `docs/`. |

## Recomendaciones conjuntas
1. Definir un **Cuadro de Mandos Ligero** que consolide métricas de valor y riesgos.
2. Establecer un **procedimiento de revisión periódica** de ADR y documentos de análisis.
3. Crear un **índice navegable** en `docs/` que relacione análisis, ADR y plantillas, facilitando la trazabilidad cruzada entre BABOK y PMBOK.

## Seguimiento
- Revisar avances trimestralmente y registrar aprendizajes en un nuevo documento de retrospectiva.
- Incorporar los resultados en la planificación de roadmap para mantener la alineación con ambos marcos.
