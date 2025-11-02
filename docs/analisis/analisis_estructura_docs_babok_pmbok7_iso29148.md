# Análisis de alineación documental v3.0

## Propósito
Consolidar la evaluación de la documentación del proyecto integrando los criterios del BABOK v3, el PMBOK Séptima Edición y la norma ISO/IEC/IEEE 29148 para identificar brechas y acciones priorizadas.

## Metodología
1. Revisar los artefactos existentes en `docs/`, `docs/adr/` y `README.md`.
2. Mapear cada artefacto a las áreas de conocimiento del BABOK y los dominios de desempeño del PMBOK 7.
3. Contrastar la estructura resultante con los *Information Items* que exige ISO 29148 para documentación de requisitos.
4. Identificar brechas, duplicidades y propuestas de mejora incremental.

## Resumen ejecutivo
- **Cobertura parcial**: El repositorio documenta decisiones (ADR) y lineamientos de desarrollo (README), pero carece de registros sistemáticos de stakeholders, requisitos y métricas de valor.
- **Integración pendiente**: No existe un repositorio único que vincule análisis de negocio, gestión de proyecto y artefactos de requisitos.
- **Oportunidades**: Crear plantillas ligeras para requisitos, stakeholders y riesgos permitiría cumplir con ISO 29148 sin perder agilidad, reforzando la alineación con BABOK y PMBOK.

## Mapa cruzado BABOK + PMBOK 7
| Dominio PMBOK 7 | Área BABOK | Evidencia actual | Brecha identificada |
| --- | --- | --- | --- |
| Stakeholder | Elicitation and Collaboration | No hay registros formales de interesados. | Definir un directorio de stakeholders con expectativas, influencia y compromisos.
| Team | Business Analysis Planning and Monitoring | README describe TDD, sin asignación de roles. | Documentar responsabilidades y mecanismos de coordinación.
| Development Approach & Life Cycle | Requirements Life Cycle Management | Pruebas automatizadas en `tests/`. | Incorporar roadmap de releases, criterios de transición y estados de requisitos.
| Measurement | Strategy Analysis | Objetivos de alto nivel en README. | Establecer métricas cuantitativas y umbrales de valor.
| Uncertainty | Solution Evaluation | No se registran riesgos ni evaluaciones post-entrega. | Implementar registro de riesgos y lecciones aprendidas.

## Validación contra ISO/IEC/IEEE 29148
| Information Item ISO 29148 | Evidencia en el repositorio | Riesgo | Acción recomendada |
| --- | --- | --- | --- |
| Perfil del proyecto y alcance | README introduce objetivos generales. | Medio: falta detalle de límites, stakeholders y supuestos. | Extender README o crear documento de alcance con contexto, restricciones y supuestos.
| Necesidades de las partes interesadas | No existe documentación explícita. | Alto: dificulta priorizar requisitos y medir valor. | Crear plantilla de "Necesidades de stakeholders" en `docs/plantillas/` y poblarla.
| Requisitos del sistema/producto | No hay catálogo de requisitos. | Alto: falta trazabilidad y criterios de aceptación. | Implementar un registro de requisitos (ID, descripción, estado, fuente, pruebas asociadas).
| Requisitos de interfaz | No se han descrito. | Medio: riesgo de inconsistencias técnicas. | Añadir sección específica en el registro de requisitos para interfaces internas/externas.
| Requisitos de rendimiento y calidad | Ausentes. | Alto: dificulta medir conformidad. | Documentar métricas de desempeño, seguridad y usabilidad ligadas a pruebas automatizadas.
| Atributos de requisito y trazabilidad | ADR capturan decisiones, pero no enlazan con requisitos. | Medio: se pierde visibilidad de impactos. | Añadir campos en el registro para relaciones con ADR, historias de usuario y pruebas.
| Plan de gestión de requisitos | No existe. | Alto: riesgo de cambios no controlados. | Crear procedimiento liviano que detalle ciclos de revisión, responsables y herramientas.

## Recomendaciones priorizadas
1. **Registro de stakeholders** (corto plazo): documento compartido que identifique interesados, objetivos y frecuencia de interacción.
2. **Catálogo de requisitos conforme a ISO 29148** (corto-medio plazo): tabla con atributos mínimos (ID, fuente, prioridad, criterio de aceptación, estado, enlace a pruebas).
3. **Procedimiento de gestión de cambios de requisitos** (medio plazo): definir cómo se capturan, aprueban y comunican los cambios, enlazado a ADR y pruebas.
4. **Métricas de valor y calidad** (medio plazo): establecer indicadores cuantitativos y ligarlos al ciclo de releases.
5. **Registro de riesgos y lecciones aprendidas** (continuo): actualizar cada iteración para soportar el dominio de Incertidumbre del PMBOK y la evaluación de soluciones del BABOK.

## Próximos pasos
- Socializar la propuesta con el equipo y validar la factibilidad de cada acción.
- Priorizar la creación de plantillas reutilizables en `docs/plantillas/` antes de poblar los registros.
- Revisar el cumplimiento con ISO 29148 trimestralmente y ajustar los artefactos según la evolución del proyecto.
