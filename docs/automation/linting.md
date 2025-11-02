# Linting y Validaciones

El script `./scripts/bash/lint-local.sh` centraliza todas las validaciones de
estilo y calidad que anteriormente se ejecutaban en GitHub Actions.

## Cobertura del linting

| Tecnología | Herramienta | Comando |
|------------|-------------|---------|
| Markdown   | `markdownlint-cli2` | `markdownlint-cli2 "**/*.md" ...` |
| Python     | `ruff` | `ruff check src tests` |
| Shell      | `shellcheck` | `shellcheck` sobre todos los `.sh` |

Puedes omitir cada categoría con las variables de entorno `SKIP_MARKDOWN`,
`SKIP_PYTHON` y `SKIP_SHELL`.

## Prerrequisitos

Ejecuta `./scripts/bash/check-prerequisites.sh` para validar que las herramientas
estén disponibles en tu máquina. El script de linting finaliza con error si una
de las herramientas no está instalada.

## Buenas prácticas

- Ejecuta el linting antes de abrir un Pull Request.
- Mantén los scripts actualizados con comentarios y encabezados descriptivos.
- Revisa los mensajes del linter: indican la ruta exacta y la regla que falló.
