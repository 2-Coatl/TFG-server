# Git Hooks Disponibles

Los git hooks se instalan mediante `./scripts/bash/spec-hooks-install.sh` y
permiten ejecutar validaciones automáticamente en cada etapa del flujo de
trabajo.

## Hooks configurados

| Hook | Script | Propósito |
|------|--------|-----------|
| `pre-commit` | `scripts/bash/spec-sync-pre-commit.sh` | Verifica formato y sincronización de especificaciones. |
| `pre-push` | `scripts/bash/spec-sync-pre-push.sh` | Ejecuta linting, tests y generación de documentación. |
| `post-commit` | `scripts/bash/spec-sync-post-commit.sh` | Actualiza documentación y especificaciones. |

> Los hooks pueden invocar internamente `ci-local.sh` o los scripts individuales
> según la configuración del repositorio.

## Instalación

```bash
./scripts/bash/spec-hooks-install.sh
```

Este script crea los enlaces simbólicos necesarios dentro de `.git/hooks`.

## Personalización

- Ajusta los scripts de `scripts/bash/spec-sync-*.sh` para incluir validaciones

  adicionales.

- Si necesitas deshabilitar temporalmente un hook, usa las variables de entorno

  documentadas en cada script o exporta `SKIP_HOOKS=1` durante la ejecución.
