# Referencia de Scripts

Esta sección agrupa los scripts disponibles en `scripts/bash/` y su propósito.

## 🔄 Ciclo de vida

### Desarrollo
- [`create-new-feature.sh`](development.md#create-new-feature) – Prepara estructura para nuevas funcionalidades.
- [`implement.sh`](development.md#implement) – Ejecuta la fase de implementación y sincronización.
- [`setup-plan.sh`](development.md#setup-plan) – Crea un plan de trabajo inicial.

### Validación
- [`ci-local.sh`](maintenance.md#ci-local) – Pipeline de CI/CD completo.
- [`lint-local.sh`](maintenance.md#lint-local) – Linting aislado.
- [`test-all.sh`](maintenance.md#test-all) – Suite de pruebas.

### Releases y documentación
- [`release-local.sh`](maintenance.md#release-local) – Orquesta el proceso de release.
- [`build-docs.sh`](maintenance.md#build-docs) – Genera y sirve la documentación.
- Scripts auxiliares en [`scripts/bash/release/`](maintenance.md#release-scripts).

Para detalles específicos consulta las secciones de [desarrollo](development.md)
y [mantenimiento](maintenance.md).
