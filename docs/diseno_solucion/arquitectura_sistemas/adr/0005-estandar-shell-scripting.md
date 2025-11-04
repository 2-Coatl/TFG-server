# ADR 0005: Adopción de Estándar de Shell Scripting para Sistemas de Producción

**Estado**: ACEPTADO

**Fecha**: 2025-11-04

**Contexto relacionado**: Complementa [ADR 0002: Migración a Makefile](0002-migracion-makefile.md) y [ADR 0003: Servidor MCP en Shell](0003-servidor-mcp-shell.md)

## Contexto

El proyecto TFG Server utiliza extensivamente Shell scripting para:

- Automatización de tareas de desarrollo (CI/CD)
- Scripts de despliegue y mantenimiento
- Herramientas de validación y testing
- Orquestación de procesos del sistema
- Configuración de entornos

### Problemas identificados

1. **Inconsistencia en estilos**: Diferentes scripts usan diferentes convenciones
2. **Falta de manejo de errores**: No todos los scripts usan `set -e` o `set -euo pipefail`
3. **Salida inconsistente**: Mezcla de emojis, Unicode, y formatos inconsistentes
4. **Falta de validación**: No hay validación automática (ShellCheck)
5. **Documentación dispersa**: No hay una guía central de referencia
6. **Portabilidad limitada**: No está claro cuándo usar bash vs POSIX sh
7. **Seguridad**: Riesgos de inyección de comandos y manejo inseguro de datos

### Necesidades identificadas

El proyecto requiere:

- ✅ Estándar unificado de Shell scripting
- ✅ Validación automática de scripts
- ✅ Guía completa de referencia
- ✅ Herramientas de enforcement
- ✅ Integración con CI/CD
- ✅ Documentación de mejores prácticas de seguridad
- ✅ Claridad entre bash y POSIX sh

## Decisión

Se adopta **Shell Scripting Guide v2.1** como estándar obligatorio para todos los scripts del proyecto.

### Componentes del estándar

#### 1. Guía completa de referencia

Documento de 12 secciones que cubre:

1. **Purpose and Scope**: Audiencia y casos de uso
2. **Decision Criteria**: Flowcharts para decidir tipo y ubicación de scripts
3. **Shell Selection**: Cuándo usar bash vs POSIX sh
4. **Core Requirements**: Templates y elementos obligatorios
5. **Output Standards**: Formato de salida estandarizado (NO emojis)
6. **Error Handling**: Estrategias de manejo de errores y exit codes
7. **Security Guidelines**: Prevención de inyecciones, manejo de secretos
8. **Code Organization**: Estructura de archivos y funciones
9. **Testing Requirements**: Unit tests, integration tests, validación
10. **Examples**: Scripts completos de ejemplo (deployment, backup, health checks)
11. **Validation Tools**: ShellCheck y herramientas de validación
12. **References**: Estándares (POSIX, Debian Policy), recursos

#### 2. Reglas críticas obligatorias

| ID | Regla | Nivel | Enforcement |
|----|-------|-------|-------------|
| R1 | Shebang obligatorio (`#!/usr/bin/env bash` o `#!/usr/bin/env sh`) | CRITICAL | ShellCheck + Hook |
| R2 | `set -e` mínimo, `set -euo pipefail` recomendado (bash) | CRITICAL | ShellCheck + Hook |
| R3 | NO usar emojis ni Unicode decorativo en salida | HIGH | Manual review |
| R4 | Prefijos estándar: `[INFO]`, `[ERROR]`, `[WARN]`, `[SUCCESS]` | HIGH | Manual review |
| R5 | Quote todas las variables: `"$var"` no `$var` | CRITICAL | ShellCheck SC2086 |
| R6 | NO hardcodear secretos | CRITICAL | Manual review + Secrets scanning |
| R7 | Validar todos los inputs de usuario | HIGH | Code review |
| R8 | Documentación en header (Purpose, Usage, Dependencies) | MEDIUM | Template enforcement |

#### 3. Templates obligatorios

**Template mínimo (POSIX sh)**:

```sh
#!/usr/bin/env sh
# Description: Brief one-line description
# Usage: script-name.sh [options]

set -eu

main() {
    # Script logic here
    printf '[INFO] Task completed\n'
}

main "$@"
exit 0
```

**Template estándar (bash)**:

```sh
#!/usr/bin/env bash
#
# Name: script-name.sh
# Description: Detailed description
# Usage: script-name.sh [OPTIONS] ARGS
# Dependencies: command1, command2
#

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

log_info() {
    printf '[INFO] %s\n' "$*"
}

log_error() {
    printf '[ERROR] %s\n' "$*" >&2
}

main() {
    log_info "Starting execution"
    # Main logic
    log_info "Execution completed"
}

main "$@"
exit 0
```

#### 4. Criterios de decisión

**Flowchart de selección de shell**:

```
¿Necesita features específicas de bash?
(arrays, [[]], ${var//}, pipefail)
├── SÍ → Usar #!/usr/bin/env bash
└── NO → Usar #!/usr/bin/env sh (máxima portabilidad)
```

**Flowchart de ubicación de scripts**:

```
¿Qué propósito tiene el script?
├── Testing → test/unit/, test/integration/, test/system/
├── Hooks Git → infrastructure/hooks/
├── Setup inicial → scripts/setup/
├── Mantenimiento → scripts/maintenance/{component}/
├── Configuración → infrastructure/configs/
├── Orquestador GitHub → script/ (bootstrap, test, deploy)
└── Utilidad reutilizable → infrastructure/utils/
```

#### 5. Formato de salida estandarizado

**Prohibido**:
- ✅ ❌ ⚠️ ℹ️ 🚀 🔍 📁 💡 (todos los emojis)
- ╔═╗ ║ ╚═╝ (box drawing)
- → ⇒ ➜ (Unicode arrows)

**Obligatorio**:
```sh
[INFO]    Información general
[DEBUG]   Detalles de debug
[WARN]    Advertencia
[ERROR]   Error encontrado
[SUCCESS] Operación exitosa
[FAIL]    Operación fallida
[RUNNING] Ejecución en progreso
[DONE]    Completado
```

#### 6. Herramientas de validación

**ShellCheck obligatorio**:

```bash
# Validación básica
shellcheck script.sh

# Con severidad específica
shellcheck --severity=warning script.sh

# En CI/CD
find . -name "*.sh" -type f -exec shellcheck {} +
```

**Configuración ShellCheck (`.shellcheckrc`)**:

```ini
# Habilitar todas las verificaciones por defecto
enable=all

# Excluir solo con justificación documentada
# SC2086: Quote variables (mantener activado)
# SC2046: Quote command substitution (mantener activado)
```

#### 7. Integración CI/CD

**Pre-commit hook obligatorio**:

```sh
#!/usr/bin/env bash
# .git/hooks/pre-commit

for file in $(git diff --cached --name-only --diff-filter=ACM | grep '\.sh$'); do
    if ! shellcheck "$file"; then
        echo "[ERROR] ShellCheck failed for $file"
        exit 1
    fi
done
```

**GitHub Actions/GitLab CI**:

```yaml
shellcheck:
  stage: validate
  image: koalaman/shellcheck-alpine:stable
  script:
    - find . -name "*.sh" -type f -exec shellcheck {} +
```

### Alcance de aplicación

**Obligatorio para**:
- ✅ Todos los scripts nuevos
- ✅ Scripts existentes al ser modificados significativamente
- ✅ Scripts críticos (deployment, backup, setup)

**Recomendado para**:
- ⚠️ Scripts legacy (migración gradual)
- ⚠️ Scripts de un solo uso (apply principles, skip tooling)

## Alternativas consideradas

| Alternativa | Ventajas | Desventajas | Decisión |
|-------------|----------|-------------|----------|
| **1. Sin estándar (status quo)** | Sin esfuerzo | Inconsistencia, errores, mantenibilidad baja | ❌ Rechazado |
| **2. Google Shell Style Guide** | Bien conocido | Menos detallado, no cubre POSIX, sin templates | ❌ Insuficiente |
| **3. Debian Policy (solo sección 10.4)** | Estándar de facto | Muy básico, no cubre casos complejos | ❌ Insuficiente |
| **4. Shell Scripting Guide v2.1** | Completo, templates, security, testing, herramientas | Requiere migración, aprendizaje inicial | ✅ **Seleccionado** |
| **5. Migrar a Python/Go** | Mejor para lógica compleja | Cambia lenguaje, pierde integración con sistema | ❌ No aplicable |

## Consecuencias

### Positivas

1. ✅ **Consistencia**: Todos los scripts siguen el mismo estándar
2. ✅ **Calidad**: Validación automática reduce errores
3. ✅ **Seguridad**: Guías específicas previenen vulnerabilidades
4. ✅ **Mantenibilidad**: Templates y estructura clara facilitan entendimiento
5. ✅ **Onboarding**: Guía completa facilita incorporación de nuevos miembros
6. ✅ **Portabilidad**: Claridad sobre bash vs POSIX sh
7. ✅ **Testing**: Frameworks y ejemplos para testing de scripts
8. ✅ **Documentación**: Referencia central para todas las dudas
9. ✅ **CI/CD**: Integración automática con pipelines
10. ✅ **Profesionalismo**: Salida limpia sin emojis para logs de producción

### Negativas (mitigadas)

1. ⚠️ **Curva de aprendizaje**: Equipo debe estudiar guía completa
   - **Mitigación**: Guía bien estructurada, templates listos para copiar
2. ⚠️ **Esfuerzo inicial**: Configurar herramientas y hooks
   - **Mitigación**: Scripts de instalación automatizados
3. ⚠️ **Migración gradual**: Scripts legacy no conformes inmediatamente
   - **Mitigación**: Aplicar estándar solo en nuevos scripts y modificaciones mayores
4. ⚠️ **ShellCheck puede ser estricto**: Falsos positivos ocasionales
   - **Mitigación**: Permitir exclusiones documentadas con justificación

### Neutras

- 🔄 **Sin cambio en funcionalidad**: Scripts hacen lo mismo, solo mejor estructurados
- 🔄 **Herramientas opcionales**: ShellCheck recomendado pero no bloqueante inicialmente

## Verificación de éxito

La adopción del estándar se considera exitosa cuando:

1. ✅ Todos los scripts nuevos pasan ShellCheck sin errores
2. ✅ 100% de scripts nuevos usan templates estándar
3. ✅ 90%+ de scripts usan `set -e` o `set -euo pipefail`
4. ✅ Cero emojis en salida de scripts de producción
5. ✅ Pre-commit hook instalado y funcionando
6. ✅ CI/CD ejecuta validación ShellCheck en todos los PRs
7. ✅ Documentación actualizada con referencias al estándar
8. ✅ Equipo conoce y aplica el estándar (medido en code reviews)

## Plan de implementación

### Fase 1: Documentación (1 hora) ✅

- [x] Crear ADR 0005 documentando decisión
- [ ] Agregar guía completa a `docs/gobernanza/estandares/shell-scripting-guide.md`
- [ ] Crear referencia rápida en `docs/gobernanza/estandares/shell-scripting-quickref.md`

### Fase 2: Herramientas (2 horas)

- [ ] Crear `.shellcheckrc` en raíz del proyecto
- [ ] Crear `scripts/bash/validate-shell-scripts.sh`
- [ ] Crear hook de pre-commit en `infrastructure/hooks/pre-commit-shellcheck`
- [ ] Crear script de instalación de hooks

### Fase 3: Integración CI/CD (1 hora)

- [ ] Agregar validación ShellCheck a `Makefile`
- [ ] Agregar job de ShellCheck a CI pipeline
- [ ] Actualizar `.gitignore` si es necesario

### Fase 4: Documentación de uso (1 hora)

- [ ] Actualizar `README.md` con mención del estándar
- [ ] Actualizar `docs/scripts/development.md`
- [ ] Crear ejemplos en `docs/gobernanza/estandares/shell-examples/`

### Fase 5: Comunicación (30 min)

- [ ] Anunciar adopción del estándar al equipo
- [ ] Documentar en changelog del proyecto
- [ ] Actualizar guías de contribución

## Referencias

### Estándares base

- **POSIX.1-2024** (IEEE Std 1003.1-2024): https://pubs.opengroup.org/onlinepubs/9699919799/
- **Debian Policy Manual** (v4.6.2), Section 10.4: https://www.debian.org/doc/debian-policy/ch-files.html#scripts
- **Google Shell Style Guide**: https://google.github.io/styleguide/shellguide.html

### Herramientas

- **ShellCheck**: https://www.shellcheck.net/
- **shfmt**: https://github.com/mvdan/sh

### Recursos adicionales

- **Safe Shell Scripting**: https://sipb.mit.edu/doc/safe-shell/
- **Bash Reference Manual**: https://www.gnu.org/software/bash/manual/
- **OWASP Command Injection**: https://owasp.org/www-community/attacks/Command_Injection

### Documentos relacionados

- [ADR 0002: Migración a Makefile](0002-migracion-makefile.md)
- [ADR 0003: Servidor MCP en Shell](0003-servidor-mcp-shell.md)
- [Shell Scripting Guide v2.1](../../gobernanza/estandares/shell-scripting-guide.md)

## Historial de cambios

| Fecha | Cambio | Responsable |
|-------|--------|-------------|
| 2025-11-04 | ADR creado y aceptado | Claude Code |

---

**Firmado**: Claude Code
**Revisado**: Pendiente
**Aprobado**: Pendiente
