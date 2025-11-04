# CI/CD y Automatización

El proyecto ejecuta todo el ciclo de validaciones mediante **Makefile** y scripts shell. Esto elimina la dependencia de GitHub Actions y permite correr la misma cadena en cualquier entorno, incluso sin conexión.

## 🎯 Flujos Automatizados

### Flujo de desarrollo diario

```bash
# 1. Crear nueva feature
./scripts/bash/create-new-feature.sh

# 2. Implementar cambios
./scripts/bash/implement.sh

# 3. Validar antes de publicar
make ci
# O directamente: ./scripts/bash/ci-local.sh
```

Los git hooks instalados por `./scripts/bash/spec-hooks-install.sh` ejecutan:

- **pre-commit:** validaciones rápidas (formato y sincronización de especificación)
- **pre-push:** linting, tests y documentación
- **post-commit:** sincronización de documentación y especificaciones

### Flujo de validación continua

```bash
# Ejecuta todas las validaciones (recomendado)
make ci

# O directamente con el script:
./scripts/bash/ci-local.sh
```

Este script reemplaza los workflows históricos `lint.yml`, `docs.yml` y
`test.yml`. Ejecuta en orden:

1. `lint-local.sh` – Markdown y Shell (shellcheck)
2. `test-all.sh` – Suite de pruebas con BATS
3. `build-docs.sh` – Generación de documentación estática

Cada paso puede omitirse con variables de entorno (`SKIP_LINT`, `SKIP_TESTS`,
`SKIP_DOCS`).

### Flujo de release

```bash
# Ejecuta el proceso completo de release (recomendado)
make release

# O directamente con el script:
./scripts/bash/release-local.sh
```

`release-local.sh` orquesta los siguientes pasos:

1. `check-release-exists.sh`
2. `get-next-version.sh`
3. `update-version.sh`
4. `generate-release-notes.sh`
5. `create-release-packages.sh`
6. `create-github-release.sh` (omitible con `SKIP_PUBLISH=1`)

Todos los scripts viven en `scripts/bash/release/` y soportan la variable
`RELEASE_DRY_RUN=1` para ejecutar el proceso sin efectos secundarios.

### Flujo de documentación

```bash
# Generar documentación estática (recomendado)
make docs

# Servir la documentación localmente
make docs-serve

# O directamente con los scripts:
./scripts/bash/build-docs.sh
./scripts/bash/build-docs.sh --serve
```

La generación utiliza MkDocs (`mkdocs build --strict`). Con `--serve` se
levanta un servidor con live reload en `http://localhost:8000`.

## 🔧 Scripts y Comandos Disponibles

### Comandos Make (recomendado)

| Comando | Descripción |
|---------|-------------|
| `make help` | Listar todas las tareas disponibles |
| `make test` | Ejecutar suite de tests con BATS |
| `make lint` | Linting de Markdown y Shell |
| `make docs` | Generar documentación con MkDocs |
| `make docs-serve` | Generar y servir documentación localmente |
| `make ci` | Pipeline completo (lint + tests + docs) |
| `make release` | Proceso de release |
| `make clean` | Limpiar archivos generados |
| `make check-deps` | Verificar dependencias instaladas |
| `make install-hooks` | Instalar git hooks |

### Scripts Shell

| Script | Descripción | Equivalente histórico |
|--------|-------------|------------------------|
| `ci-local.sh` | Pipeline completo (lint + tests + docs) | `.github/workflows/lint.yml`, `test.yml`, `docs.yml` |
| `lint-local.sh` | Linting de Markdown y Shell | `.github/workflows/lint.yml` |
| `test-all.sh` | Suite de tests con BATS | Parte de `test.yml` |
| `build-docs.sh` | Generación y servido de documentación | `.github/workflows/docs.yml` |
| `release-local.sh` | Orquestación de release | `.github/workflows/release.yml` |

## 📋 Configuración inicial

```bash
# 1. Instalar git hooks
./scripts/bash/spec-hooks-install.sh

# 2. Verificar prerequisitos de herramientas
./scripts/bash/check-prerequisites.sh

# 3. Inicializar constitución del equipo
./scripts/bash/setup-constitution.sh
```

## 🚨 Troubleshooting

Consulta [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) para problemas comunes con
los scripts o dependencias.
