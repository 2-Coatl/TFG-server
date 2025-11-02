# CI/CD y Automatización

El proyecto ejecuta todo el ciclo de validaciones mediante scripts shell. Esto
elimina la dependencia de GitHub Actions y permite correr la misma cadena en
cualquier entorno, incluso sin conexión.

## 🎯 Flujos Automatizados

### Flujo de desarrollo diario

```bash
# 1. Crear nueva feature
./scripts/bash/create-new-feature.sh

# 2. Implementar cambios
./scripts/bash/implement.sh

# 3. Validar antes de publicar
./scripts/bash/ci-local.sh
```

Los git hooks instalados por `./scripts/bash/spec-hooks-install.sh` ejecutan:

- **pre-commit:** validaciones rápidas (formato y sincronización de especificación)
- **pre-push:** linting, tests y documentación
- **post-commit:** sincronización de documentación y especificaciones

### Flujo de validación continua

```bash
# Ejecuta todas las validaciones
./scripts/bash/ci-local.sh
```

Este script reemplaza los workflows históricos `lint.yml`, `docs.yml` y
`test.yml`. Ejecuta en orden:

1. `lint-local.sh` – Markdown, Python y Shell
2. `test-all.sh` – Suite de pruebas
3. `build-docs.sh` – Generación de documentación estática

Cada paso puede omitirse con variables de entorno (`SKIP_LINT`, `SKIP_TESTS`,
`SKIP_DOCS`).

### Flujo de release

```bash
# Ejecuta el proceso completo de release
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
# Generar documentación estática
./scripts/bash/build-docs.sh

# Servir la documentación localmente
./scripts/bash/build-docs.sh --serve
```

La generación utiliza DocFX (`docfx build docs/docfx.json`). Con `--serve` se
levanta un servidor simple en `http://localhost:8080`.

## 🔧 Scripts disponibles

| Script | Descripción | Equivalente histórico |
|--------|-------------|------------------------|
| `ci-local.sh` | Pipeline completo (lint + tests + docs) | `.github/workflows/lint.yml`, `test.yml`, `docs.yml` |
| `lint-local.sh` | Linting de Markdown, Python y Shell | `.github/workflows/lint.yml` |
| `test-all.sh` | Suite de pytest | Parte de `test.yml` |
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
