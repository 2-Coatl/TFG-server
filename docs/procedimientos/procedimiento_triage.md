# Procedimiento - Triage de Funcionalidades y Bugs

**Propósito:** Estandarizar la recepción y clasificación de nuevos requerimientos o incidencias siguiendo la guía descrita en `docs/triage-framework.md` y los registros de `docs/tareas_analisis/`.

## Alcance
Solicitudes entrantes (historias, épicas, bugs) que requieren evaluación inicial antes de planificarse.

## Roles
- **Facilitador/a de triage:** coordina la sesión y documenta acuerdos.
- **Representante de producto:** aporta contexto de negocio y prioriza.
- **Representante técnico:** estima impacto en arquitectura y pruebas.

## Prerrequisitos
- Backlog actualizado en los tableros correspondientes (`docs/tableros/`).
- Registros de stakeholders y métricas vigentes para tomar decisiones informadas.

## Frecuencia
Sesiones semanales o cuando exista un volumen significativo de solicitudes pendientes.

## Pasos
1. **Preparación de la sesión**
   - Recolectar insumos desde `docs/necesidades_negocio/` y `docs/requisitos/` para entender dependencias.
   - Identificar ítems nuevos y agruparlos por tipo (feature, bug, deuda técnica).
2. **Clasificación inicial**
   - Confirmar si el ítem cuenta con información mínima (contexto, objetivo, criterios de aceptación).
   - Registrar faltantes en `docs/tareas_analisis/elicitacion_colaboracion/` para seguimiento.
3. **Evaluación de impacto**
   - Consultar trazas existentes en `docs/requisitos/trazabilidad_general.md`.
   - Revisar métricas y riesgos asociados en `docs/validacion_evaluacion/` y `docs/analisis/`.
4. **Priorización y decisión**
   - Ubicar el ítem en la categoría adecuada (p. ej. MoSCoW) apoyándose en `t_5.3_priorizar_requisitos`.
   - Registrar decisiones en `docs/tareas_analisis/gestion_ciclo_vida_requisitos/readme.md` y crear tareas derivadas.
5. **Seguimiento posterior**
   - Actualizar el backlog y notificar al equipo sobre el estado resultante.
   - Generar acciones en tableros o actas según corresponda (`docs/plantillas/`).

## Entregables
- Registro actualizado de cada ítem triageado con su estado y prioridad.
- Lista de acciones o tareas derivadas para completar información faltante.

## Métricas sugeridas
- Porcentaje de ítems aceptados vs. rechazados en cada sesión.
- Tiempo promedio desde la recepción hasta la clasificación final.

## Referencias
- `docs/triage-framework.md`
- `docs/tareas_analisis/`
- `docs/requisitos/trazabilidad_general.md`
- `docs/tableros/`
