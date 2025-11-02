# TFG Server

Herramienta monolítica para ejecutar tareas de soporte al desarrollo, implementada íntegramente con Shell.

## Requisitos

- Bash 4 o superior
- GNU Make
- Herramientas estándar POSIX (awk, sort, etc.)

### Dependencias de desarrollo

- **bats-core**: Suite de pruebas automatizadas
- **shellcheck**: Análisis estático de scripts shell
- **markdownlint-cli2**: Validación de archivos Markdown
- **docfx**: Generación de documentación

Para verificar dependencias instaladas:

```bash
make check-deps
```

## Instalación

No es necesario crear entornos virtuales ni instalar paquetes. Basta con clonar el repositorio:

```bash
git clone <repository-url>
cd TFG-server
```

## Uso

El proyecto usa **Makefile** para orquestar todas las tareas de desarrollo. Para ver las tareas disponibles:

```bash
make help
```

### Comandos principales

```bash
make test          # Ejecutar suite de tests con BATS
make lint          # Validar código (shell + markdown)
make docs          # Generar documentación
make ci            # Pipeline completo de CI
make clean         # Limpiar archivos generados
```

La salida utiliza prefijos como `[INFO]`, `[SUCCESS]` y `[ERROR]` siguiendo la guía de mensajes sin emojis.

## Desarrollo

1. Trabaja siguiendo TDD: escribe primero las pruebas en `test/` y ejecútalas con `make test`
2. Valida tu código antes de commit: `make lint`
3. Mantén sincronizada la documentación en PostScript (`docs/estandares-shell-postscript.ps`)

## 🚀 Automatización

El proyecto utiliza **Makefile** y scripts shell para ejecutar todas las validaciones sin depender de GitHub Actions.

```bash
# Validación completa (CI)
make ci

# Crear release
make release

# Generar documentación
make docs

# O directamente con los scripts:
./scripts/bash/ci-local.sh
./scripts/bash/release-local.sh
./scripts/bash/build-docs.sh
```

Los git hooks instalados con `make install-hooks` (o `./scripts/bash/spec-hooks-install.sh`) ejecutan validaciones automáticas en `pre-commit`, `pre-push` y `post-commit`.

Consulta la documentación completa en `docs/automation/ci-cd.md`.

## Documentación de decisiones

Las decisiones arquitectónicas se registran en `docs/adr`:

- [ADR 0002: Migración a Makefile](docs/adr/0002-migracion-makefile.md) - Sistema actual de automatización
- [ADR 0001: Codex CLI](docs/adr/0001-ejecucion-codex.md) - **DEPRECADO** (reemplazado por Makefile)

Para ampliar la comprensión sobre la estructura documental y su alineación con marcos de análisis de negocio y gestión de proyectos, revisa los análisis en `docs/analisis/`:

- [Análisis de la estructura documental frente a BABOK](docs/analisis/analisis_estructura_docs_babok.md)
- [Evaluación de alineación BABOK y PMBOK 7](docs/analisis/analisis_estructura_docs_babok_pmbok7.md)
