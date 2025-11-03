# Changelog

Todos los cambios notables del proyecto se documentan en este archivo.

El formato se basa en [Keep a Changelog](<https://keepachangelog.com/es/1.0.0>/),
y este proyecto adhiere a [Semantic Versioning](<https://semver.org/lang/es>/).

## [Unreleased]

### 🔴 BREAKING CHANGES

- **Eliminado `bin/codex`**: La herramienta CLI personalizada ha sido reemplazada por Makefile estándar
  - Migración: `./bin/codex listar` → `make help`
  - Migración: `./bin/codex ejecutar pruebas` → `make test`
  - Ver [ADR 0002](docs/adr/0002-migracion-makefile.md) para detalles

- **Eliminado soporte para Python**: El proyecto es ahora 100% Shell/Bash
  - Removido: pytest como dependencia
  - Removido: ruff como linter
  - Suite de tests migrada completamente a BATS

### ✨ Added

- **Makefile**: Sistema estándar de automatización con targets:
  - `make help`: Listar tareas disponibles
  - `make test`: Ejecutar suite BATS
  - `make lint`: Validar código (shellcheck + markdownlint)
  - `make docs`: Generar documentación
  - `make ci`: Pipeline completo de CI
  - `make release`: Proceso de release
  - `make clean`: Limpiar archivos generados
  - `make check-deps`: Verificar dependencias instaladas
  - `make install-hooks`: Instalar git hooks

- **ADR 0002**: Documentación de migración a Makefile
- **codex.toml.example**: Archivo de referencia histórica (ver ADR 0001)

### 🔧 Changed

- **test-all.sh**: Migrado de pytest a BATS
  - Variable de entorno: `PYTEST_ARGS` → `BATS_ARGS`
  - Corregido word splitting bug (línea 45)

- **lint-local.sh**: Eliminada sección de linting Python (ruff)
  - Ahora solo ejecuta: markdownlint-cli2 + shellcheck

- **README.md**: Actualizado con instrucciones de Makefile
  - Ejemplos actualizados con comandos `make`
  - Lista completa de dependencias documentada
  - Referencias a ADR actualizadas

### 🗑️ Removed

- **bin/codex**: Parser TOML en Bash (312 líneas)
  - Razón: Complejidad innecesaria, vulnerabilidad de seguridad
  - Reemplazado por: Makefile estándar

- **Referencias a Python**:
  - pytest de scripts y documentación
  - ruff de lint-local.sh
  - Mención de Python 3.11+ en requisitos

### 🔒 Security

- **Eliminada vulnerabilidad de inyección de comandos** en bin/codex (líneas 175-177, 225)
- **Corregido word splitting** en test-all.sh que podía causar ejecución inesperada

### 📚 Documentation

- **ADR 0001**: Marcado como DEPRECADO con referencia a ADR 0002
- **ADR 0002**: Creado - documenta migración completa a Makefile
- **README.md**: Reescrito con enfoque en Makefile y comandos actualizados

### 🐛 Fixed

- Word splitting en `test-all.sh` línea 45 (variable PYTEST_ARGS sin comillas)
- Validación de cambio de directorio en `test-all.sh` línea 25

---

## [1.0.0] - Histórico

### Added

- Initial scaffolding of project structure
- Implementación de bin/codex en Shell (ver ADR 0001 - DEPRECADO)
