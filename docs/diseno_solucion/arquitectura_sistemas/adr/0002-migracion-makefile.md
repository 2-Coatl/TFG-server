# ADR 0002: Migración de Codex CLI a Makefile

**Estado**: ACEPTADO

**Fecha**: 2025-11-02

**Reemplaza**: [ADR 0001: Reimplementación de la herramienta Codex CLI en Shell](0001-ejecucion-codex.md)

## Contexto

El proyecto implementó una herramienta CLI personalizada llamada `bin/codex` (ver ADR 0001) para orquestar tareas de desarrollo. Esta herramienta:

- Era un parser TOML escrito en Bash puro (~312 líneas)
- Requería un archivo `codex.toml` que nunca fue creado
- Duplicaba funcionalidad que Make provee de forma estándar
- Introducía complejidad innecesaria y riesgos de seguridad

### Problemas identificados

1. **Archivo de configuración faltante**: `codex.toml` nunca existió, haciendo `bin/codex` inútil
2. **Vulnerabilidad de seguridad**: Inyección de comandos en líneas 175-177 y 225 de `bin/codex`
3. **Complejidad innecesaria**: Parser TOML en Bash cuando Make es estándar POSIX
4. **Mantenibilidad**: 312 líneas de código complejo vs. Makefile estándar
5. **Adopción**: `make` es universal; `codex` es específico del proyecto

### Análisis de alternativas

| Criterio | bin/codex | Makefile | Ganador |
|----------|-----------|----------|---------|
| Instalación requerida | No | No (estándar POSIX) | Empate |
| Complejidad | 312 líneas Bash | ~100 líneas Make | Makefile |
| Familiaridad del equipo | Baja | Alta | Makefile |
| Seguridad | Vulnerable | Probado | Makefile |
| Mantenimiento | Alto | Bajo | Makefile |
| Documentación | Requiere crear | Estándar conocido | Makefile |

## Decisión

Se elimina `bin/codex` y se reemplaza con un **Makefile estándar** que:

- Define targets estándar: `test`, `lint`, `docs`, `ci`, `release`, `clean`, `help`
- Integra con los scripts existentes en `scripts/bash/`
- Usa solo herramientas Shell/Bash (sin Python)
- Provee mensajes consistentes con colores
- Incluye verificación de dependencias (`make check-deps`)

### Comandos de migración

| Antes (bin/codex) | Después (Makefile) |
|-------------------|-------------------|
| `./bin/codex listar` | `make help` |
| `./bin/codex ejecutar pruebas` | `make test` |
| `./bin/codex ejecutar lint` | `make lint` |
| N/A | `make ci` |
| N/A | `make docs` |

### Cambios eliminando Python

Además de eliminar `bin/codex`, se eliminan referencias a Python:

- **test-all.sh**: Eliminar pytest, usar BATS exclusivamente
- **lint-local.sh**: Eliminar ruff, usar solo shellcheck + markdownlint
- **build-docs.sh**: Reemplazar servidor Python por alternativa Bash (opcional)

## Consecuencias

### Positivas

✅ **Simplicidad**: Makefile es estándar y familiar para todos los desarrolladores
✅ **Seguridad**: Elimina vulnerabilidad de inyección de comandos
✅ **Mantenibilidad**: Código más simple y mantenible
✅ **Sin dependencias nuevas**: Make está en todos los sistemas POSIX
✅ **Mejores prácticas**: Uso de herramientas estándar de la industria
✅ **Documentación**: `make help` auto-documenta las tareas disponibles

### Negativas

⚠️ **Cambio de interfaz**: Usuarios deben aprender nuevos comandos (mínimo)
⚠️ **Rompe scripts existentes**: Scripts que invocaban `bin/codex` deben actualizarse
⚠️ **Deprecación**: ADR 0001 queda obsoleto

### Neutrales

- El archivo histórico `codex.toml.example` se mantiene como referencia
- Los scripts en `scripts/bash/` siguen funcionando igual
- La filosofía "solo Shell" se mantiene

## Notas de implementación

### Archivo histórico

Se crea `codex.toml.example` para referencia de cómo habría sido la configuración:

```toml
version = 1

[[tareas]]
nombre = "test"
descripcion = "Ejecutar tests con BATS"
comando = ["bats", "test/test.bats"]
directorio = "."

[[tareas]]
nombre = "lint"
descripcion = "Validar código"
comando = ["make", "lint"]
directorio = "."
```

### Actualización de documentación

Archivos actualizados:
- `README.md`: Ejemplos con `make` en lugar de `codex`
- `docs/automation/ci-cd.md`: Referencias a Makefile
- `CHANGELOG.md`: Registro de cambios breaking

### Tests

La suite de tests migra completamente a BATS:
- `test/test.bats`: Suite principal (ya existe)
- Eliminar dependencias de pytest del README

## Referencias

- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [POSIX Make Specification](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html)
- [Bash Automated Testing System (BATS)](https://github.com/bats-core/bats-core)

## Historial de revisiones

| Fecha | Autor | Cambio |
|-------|-------|--------|
| 2025-11-02 | Claude Code | Creación inicial del ADR |
