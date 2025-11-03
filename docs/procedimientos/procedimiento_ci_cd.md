# Procedimiento de CI/CD (Integración y Despliegue Continuo)

## Objetivo

Ejecutar el pipeline completo de validaciones de calidad de forma local antes de
subir cambios al repositorio, garantizando que todo el código cumple con los
estándares del proyecto.

## Alcance

Este procedimiento cubre:

- Validación de linting (markdown + shell)
- Ejecución de suite de tests
- Generación de documentación
- Validación pre-push y pre-merge

## Responsables

- **Ejecutor**: Desarrollador
- **Validador Automático**: Git hooks + CI local
- **Revisor**: Tech Lead en pull requests

## Prerequisitos

### Dependencias Completas

```bash
make check-deps
```

Debe verificar:

- ✓ bats (testing)
- ✓ shellcheck (linting shell)
- ✓ markdownlint-cli2 (linting markdown)
- ✓ docfx (documentación)

### Variables de Entorno Opcionales

```bash
# Omitir pasos específicos
export SKIP_LINT=1      # Saltar linting
export SKIP_TESTS=1     # Saltar tests
export SKIP_DOCS=1      # Saltar documentación
```

## Arquitectura del Pipeline

```
┌─────────────────────────────────────────┐
│         make ci (Pipeline Completo)     │
└──────────────┬──────────────────────────┘
               │
               ├──> 1. LINTING
               │    ├─> Markdown (markdownlint-cli2)
               │    └─> Shell (shellcheck)
               │
               ├──> 2. TESTING
               │    └─> BATS (test-all.sh)
               │
               └──> 3. DOCUMENTACIÓN
                    └─> DocFX (build-docs.sh)
```

## Procedimiento

### Opción 1: Pipeline Completo (Recomendado)

```bash
make ci
```

**Este comando ejecuta:**

1. Linting de markdown y shell
2. Suite completa de tests con BATS
3. Generación de documentación

**Salida esperada:**

```
[ci-local] Iniciando pipeline de CI local...
[ci-local] Iniciando: Linting
[lint-local] Ejecutando markdownlint-cli2
[lint-local] Ejecutando shellcheck
[lint-local] Linting completado
[ci-local] Completado: Linting
[ci-local] Iniciando: Tests
[test-all] Ejecutando bats
1..2
ok 1 muestra la versión del proyecto
ok 2 estructura documental reorganizada
[test-all] Tests completados
[ci-local] Completado: Tests
[ci-local] Iniciando: Documentación
[build-docs] Generando documentación con DocFX
[build-docs] Documentación generada
[ci-local] Completado: Documentación
[ci-local] CI local completado satisfactoriamente
[ci] Pipeline CI completado
```

### Opción 2: Pasos Individuales

#### 2.1 Solo Linting

```bash
make lint
```

Ver detalles en: `docs/procedimientos/procedimiento_linting.md`

#### 2.2 Solo Tests

```bash
make test
```

Ver detalles en: `docs/procedimientos/testing-bats.md`

#### 2.3 Solo Documentación

```bash
make docs
```

Ver detalles en: `docs/procedimientos/procedimiento_generacion_docs.md`

### Opción 3: Pipeline con Saltos

```bash
# Saltar documentación (más rápido)
SKIP_DOCS=1 make ci

# Saltar tests
SKIP_TESTS=1 make ci

# Solo linting y tests
SKIP_DOCS=1 make ci
```

### Opción 4: Ejecución Directa del Script

```bash
# Equivalente a make ci
./scripts/bash/ci-local.sh

# Con variables de entorno
SKIP_DOCS=1 ./scripts/bash/ci-local.sh
```

## Integración con Git Workflow

### Workflow Recomendado

```bash
# 1. Hacer cambios
git add .

# 2. Ejecutar CI local
make ci

# 3. Si pasa, hacer commit
git commit -m "feat: nueva funcionalidad"

# 4. Push (con validación automática)
git push
```

### Git Hooks Automáticos

Una vez instalados los hooks (`make install-hooks`):

**Pre-commit:**

- Valida sintaxis de archivos modificados
- No ejecuta CI completo (sería muy lento)

**Pre-push:**

- Ejecuta CI completo automáticamente
- Bloquea push si falla alguna validación

**Post-commit:**

- Sincroniza metadatos
- Actualiza documentación interna

## Manejo de Errores

### Error en Linting

```
[lint-local] ERROR: no se encontró el comando 'markdownlint-cli2'
```

**Solución:**

```bash
npm install -g markdownlint-cli2
```

### Error en Tests

```
✗ estructura documental reorganizada
  (in test file test/test.bats, line 20)
```

**Solución:**

1. Revisar el test fallido
2. Corregir el código o actualizar el test
3. Volver a ejecutar: `make test`

### Error en Documentación

```
[build-docs] ERROR: no se encontró el comando 'docfx'
```

**Solución:**

```bash
# Instalar docfx
# Ver: docs/procedimientos/procedimiento_generacion_docs.md
```

### Pipeline Interrumpido

Si el CI falla en cualquier paso:

1. El pipeline se detiene inmediatamente
2. Se muestra el error específico
3. Código de salida: 1 (error)

**No se ejecutan pasos posteriores hasta corregir el error.**

## Validación Pre-Merge

Antes de crear un Pull Request:

```bash
# 1. Asegurar que estás en tu rama
git checkout mi-feature-branch

# 2. Actualizar desde main
git fetch origin
git rebase origin/main

# 3. Ejecutar CI completo
make ci

# 4. Si todo pasa, push
git push origin mi-feature-branch

# 5. Crear PR en GitHub
```

## Optimización de Tiempo

### CI Completo vs Parcial

| Comando | Tiempo Aprox. | Cuándo Usar |
|---------|---------------|-------------|
| `make lint` | 5-10s | Después de cambios menores |
| `make test` | 2-5s | Después de cambios en código |
| `make ci` | 15-30s | Antes de push/PR |
| `SKIP_DOCS=1 make ci` | 10-15s | Durante desarrollo activo |

### Cache de Dependencias

DocFX y herramientas de linting cachean resultados:

- Primera ejecución: más lenta
- Ejecuciones subsecuentes: más rápidas

## CI en Diferentes Entornos

### Desarrollo Local

```bash
make ci
```

### Container/DevContainer

```bash
# Mismo comando, funciona en contenedor
make ci
```

### GitHub Actions (Futuro)

El mismo pipeline se puede adaptar a GitHub Actions:

```yaml
# .github/workflows/ci.yml
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run CI
        run: make ci
```

## Métricas de Calidad

### Criterios de Éxito

Para que el CI pase:

- ✅ 0 errores de linting
- ✅ 100% de tests pasando
- ✅ Documentación genera sin errores
- ✅ Tiempo de ejecución < 2 minutos

### Monitoreo

```bash
# Ver última ejecución
git log -1 --format="%h %s %cr"

# Ver estado de hooks
ls -la .git/hooks/
```

## Resolución de Problemas Comunes

### "CI toma demasiado tiempo"

```bash
# Usar versión optimizada
SKIP_DOCS=1 make ci
```

### "Fallan tests que antes pasaban"

```bash
# Limpiar y volver a ejecutar
make clean
make test
```

### "Error de permisos en scripts"

```bash
# Asegurar permisos de ejecución
chmod +x scripts/bash/*.sh
```

### "Dependencias desactualizadas"

```bash
# Verificar versiones
make check-deps

# Actualizar dependencias
npm update -g markdownlint-cli2
```

## Mejores Prácticas

1. **Ejecutar CI antes de cada push:**
   ```bash
   git push && echo "ERROR: Ejecuta 'make ci' primero" || make ci && git push
   ```

2. **Usar aliases para eficiencia:**
   ```bash
   alias ci="make ci"
   alias ciq="SKIP_DOCS=1 make ci"  # CI rápido
   ```

3. **Integrar en editor/IDE:**
   - VSCode: Agregar tarea en `.vscode/tasks.json`
   - Vim: Mapear comando `:make ci`

4. **No omitir validaciones en main:**
   ```bash
   # Nunca hacer esto en main:
   git push --no-verify  # ❌ Malo
   ```

5. **Documentar fallos persistentes:**
   - Crear issue en GitHub
   - Incluir salida completa del CI
   - Marcar como bloqueante

## Scripts Relacionados

- Pipeline principal: `scripts/bash/ci-local.sh`
- Linting: `scripts/bash/lint-local.sh`
- Tests: `scripts/bash/test-all.sh`
- Documentación: `scripts/bash/build-docs.sh`

## Referencias

- ADR 0002: Migración a Makefile (decisión arquitectónica)
- docs/automation/ci-cd.md (documentación técnica)
- docs/procedimientos/procedimiento_linting.md
- docs/procedimientos/testing-bats.md

## Historial de Cambios

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-11-03 | 1.0 | Creación inicial del procedimiento |
