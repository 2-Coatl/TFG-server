# Procedimiento - Desarrollo Local Guiado por Automatizaciones

**Propósito:** Establecer los pasos para preparar el entorno local y ejecutar el flujo diario de desarrollo usando los scripts y objetivos de `Makefile` documentados en `docs/automation/ci-cd.md`.

## Alcance

Aplica a cualquier contribución de código o documentación que se implemente desde estaciones de trabajo locales.

## Roles

- **Persona desarrolladora/analista:** ejecuta el flujo completo y corrige hallazgos.
- **Revisora técnica:** valida que las verificaciones se hayan ejecutado y resuelto.

## Prerrequisitos

- Repositorio clonado y dependencias instaladas (`make setup`, `pip install -e .`).
- Git hooks instalados mediante `./scripts/bash/spec-hooks-install.sh` para habilitar validaciones automáticas en `pre-commit`, `pre-push` y `post-commit`.
- Herramientas base verificadas con `./scripts/bash/check-prerequisites.sh`.

## Frecuencia

Debe ejecutarse al iniciar un trabajo nuevo y repetirse antes de publicar ramas o abrir un Pull Request.

## Pasos

1. **Crear rama de trabajo**
   - Ejecutar `./scripts/bash/create-new-feature.sh` y seguir las instrucciones para nombrar la rama.
2. **Implementar cambios**
   - Utilizar `./scripts/bash/implement.sh` como recordatorio de las tareas mínimas (actualizar especificaciones, código y documentación).
3. **Validación continua local**
   - Lanzar `make ci` (o `./scripts/bash/ci-local.sh`) para ejecutar lint, pruebas BATS y generación de documentación.
   - Si se necesita revisar un paso individual, usar `make lint`, `make test` o `make docs` según corresponda.
4. **Revisión manual adicional**
   - Consultar `docs/TROUBLESHOOTING.md` ante fallos recurrentes y documentar ajustes necesarios.
5. **Preparación para compartir**
   - Confirmar que no existen errores pendientes y que los hooks se ejecutan sin bloqueos.
   - Empaquetar cambios con mensajes de commit siguiendo el estándar Conventional Commits.

## Entregables

- Rama actualizada con commits verificados.
- Evidencia de ejecución del flujo (`make ci` exitoso) disponible en el historial local.

## Métricas sugeridas

- Tiempo medio invertido entre `make ci` consecutivos.
- Número de fallos por tipo de verificación (lint/tests/docs) antes de la corrección.

## Referencias

- `docs/automation/ci-cd.md`
- `docs/local-development.md`
- `docs/TROUBLESHOOTING.md`
