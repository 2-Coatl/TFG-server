# Procedimiento - Release Local Orquestado por Scripts

**Propósito:** Detallar la ejecución controlada de releases utilizando los scripts bash documentados en `docs/automation/releases.md` y `docs/automation/ci-cd.md`.

## Alcance
Aplica a la generación de versiones estables del paquete y su publicación manual o automatizada.

## Roles
- **Release manager:** coordina la ejecución del script maestro y valida los artefactos.
- **Equipo técnico:** confirma que la versión candidata pasó por CI y pruebas adicionales.

## Prerrequisitos
- Flujo de desarrollo completo (`make ci`) ejecutado sin errores en la rama objetivo.
- Credenciales y permisos para publicar artefactos (si aplica).
- Herramientas de packaging (`build` o `setuptools`) instaladas.

## Pasos
1. **Preparación**
   - Revisar `CHANGELOG.md` y confirmar que refleja los cambios que se incluirán.
   - Definir si la ejecución será un `dry run` (`RELEASE_DRY_RUN=1`) o real.
2. **Ejecución principal**
   - Ejecutar `make release` o `./scripts/bash/release-local.sh`.
   - El script invoca en orden: `check-release-exists.sh`, `get-next-version.sh`, `update-version.sh`, `generate-release-notes.sh`, `create-release-packages.sh` y `create-github-release.sh`.
3. **Publicación condicionada**
   - Usar `SKIP_PUBLISH=1` si se requiere validar artefactos antes de publicarlos.
   - Si todo es correcto, repetir sin la variable para publicar.
4. **Validaciones posteriores**
   - Verificar la integridad de los paquetes generados.
   - Confirmar que la release aparece en el repositorio remoto cuando se habilita la publicación.

## Entregables
- Artefactos construidos (`dist/` o equivalente) y notas de release generadas.
- Registro de ejecución del script con resultados de cada paso.

## Métricas sugeridas
- Tiempo total de ejecución del script.
- Número de ejecuciones en `dry run` antes de la publicación.

## Referencias
- `docs/automation/releases.md`
- `docs/automation/ci-cd.md`
