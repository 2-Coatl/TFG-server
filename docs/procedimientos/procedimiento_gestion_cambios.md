# Procedimiento - Gestión de Cambios de Requisitos

**Propósito:** Controlar la recepción, análisis y aprobación de cambios sobre los requisitos, alineado al proceso descrito en `docs/gobernanza/procesos/proceso_gestion_cambios.md`.

## Alcance
Requerimientos funcionales y no funcionales del producto bajo gobierno del repositorio.

## Roles
- **Solicitante:** registra la necesidad de cambio y provee contexto.
- **Analista de requisitos:** evalúa impacto y mantiene la trazabilidad.
- **Comité de aprobación:** decide la incorporación del cambio.

## Prerrequisitos
- Plantillas de gobernanza actualizadas (`plantillas/gobernanza/`).
- Registro maestro de requisitos y trazabilidad disponible (`docs/requisitos/`).

## Frecuencia
Proceso disparado bajo demanda cuando se envía una nueva solicitud de cambio.

## Pasos
1. **Registro de solicitud**
   - Completar `plantillas/gobernanza/plantilla_plan_gestion_cambios_requisitos.md`.
   - Añadir la solicitud en `docs/tareas_analisis/gestion_ciclo_vida_requisitos/t_5.4_evaluar_cambios/`.
2. **Análisis de impacto**
   - Revisar dependencias en `docs/requisitos/trazabilidad_general.md`.
   - Identificar pruebas afectadas (`docs/validacion_evaluacion/casos_prueba/`).
   - Documentar observaciones en el registro maestro (`docs/requisitos/registro_maestro.md`).
3. **Evaluación y recomendación**
   - Contrastar con prioridades existentes (`t_5.3_priorizar_requisitos`).
   - Proponer actualización de métricas o riesgos asociados.
4. **Aprobación o rechazo**
   - Registrar la decisión en `docs/tareas_analisis/gestion_ciclo_vida_requisitos/t_5.5_aprobar_requisitos/`.
   - Actualizar baselines relevantes y notificar a stakeholders.
5. **Seguimiento**
   - Ajustar `docs/requisitos/registro_maestro.md` y `docs/requisitos/trazabilidad_general.md` con el estado final.
   - Levantar tareas de implementación y prueba según la decisión.

## Entregables
- Solicitud de cambio completada.
- Registro maestro y trazabilidad actualizados.
- Acta o nota de aprobación asociada al cambio.

## Métricas sugeridas
- Tiempo promedio de ciclo desde la solicitud hasta la decisión.
- Número de cambios aprobados vs. rechazados por periodo.

## Referencias
- `docs/gobernanza/procesos/proceso_gestion_cambios.md`
- `docs/requisitos/registro_maestro.md`
- `docs/requisitos/trazabilidad_general.md`
- `docs/tareas_analisis/gestion_ciclo_vida_requisitos/`
