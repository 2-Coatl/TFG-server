# Procedimiento de Creación de Features

## Objetivo

Guiar el proceso completo de creación de una nueva funcionalidad, desde la
planificación hasta el merge, siguiendo las mejores prácticas del proyecto.

## Workflow Completo

```
Planificación → Implementación → Testing → Documentación → Review → Merge
```

## Procedimiento Paso a Paso

### 1. Planificación

#### 1.1 Crear Issue en GitHub

```bash
# Usar GitHub CLI
gh issue create \
  --title "Feature: [nombre descriptivo]" \
  --body "Descripción detallada de la feature"
```

O en la web: GitHub > Issues > New Issue

#### 1.2 Definir Requisitos

Documentar en: `docs/requisitos/registro_maestro.md`

```markdown
## REQ-XXX: [Nombre de Feature]

**Tipo:** Funcional
**Prioridad:** Alta/Media/Baja
**Estado:** En desarrollo

**Descripción:**
[Descripción detallada]

**Criterios de Aceptación:**
- [ ] Criterio 1
- [ ] Criterio 2
- [ ] Criterio 3
```

### 2. Crear Rama de Feature

```bash
# Actualizar main
git checkout main
git pull origin main

# Crear rama de feature
git checkout -b feature/nombre-feature

# Convención de nombres:
# feature/auth-system
# feature/user-dashboard
# bugfix/login-error
```

### 3. Implementación

#### 3.1 Desarrollar Código

```bash
# Crear scripts necesarios
vim scripts/bash/nueva-funcionalidad.sh

# Header estándar para scripts
#!/usr/bin/env bash
################################################################################
# nueva-funcionalidad.sh - Descripción breve
#
# PROPÓSITO:
#   Descripción detallada del propósito
#
# USO:
#   ./scripts/bash/nueva-funcionalidad.sh [opciones]
################################################################################

set -euo pipefail

# Implementación...
```

#### 3.2 Validar Sintaxis Continuamente

```bash
# Durante desarrollo
bash -n scripts/bash/nueva-funcionalidad.sh

# O usar linter
make lint-shell
```

### 4. Testing

#### 4.1 Crear Tests

Crear: `test/test_nueva_funcionalidad.bats`

```bash
#!/usr/bin/env bats

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" && pwd )"
    PATH="$DIR/../scripts/bash:$PATH"
}

@test "nueva funcionalidad funciona correctamente" {
    run nueva-funcionalidad.sh --test
    assert_success
    assert_output --partial "éxito"
}

@test "maneja errores correctamente" {
    run nueva-funcionalidad.sh --invalid
    assert_failure
}
```

#### 4.2 Ejecutar Tests

```bash
# Ejecutar todos los tests
make test

# Ejecutar test específico
bats test/test_nueva_funcionalidad.bats
```

### 5. Documentación

#### 5.1 Documentar en README

Actualizar: `README.md` o documentación relevante

```markdown
### Nueva Funcionalidad

Descripción de qué hace y cómo usarla.

```bash
./scripts/bash/nueva-funcionalidad.sh --option
```
```

#### 5.2 Crear Procedimiento (si aplica)

Si la feature requiere procedimiento operativo:

Crear: `docs/procedimientos/procedimiento_nueva_funcionalidad.md`

#### 5.3 Actualizar CHANGELOG

Editar: `CHANGELOG.md`

```markdown
## [Unreleased]

### Added

- Nueva funcionalidad para [descripción]
```

### 6. Validación Pre-Commit

```bash
# CI completo
make ci

# Si pasa:
# ✓ Linting
# ✓ Tests
# ✓ Docs

# Entonces commit
git add .
git commit -m "feat: implementar [nombre feature]"
```

### 7. Push y Pull Request

#### 7.1 Push a Remoto

```bash
git push -u origin feature/nombre-feature
```

#### 7.2 Crear Pull Request

```bash
# Usando GitHub CLI
gh pr create \
  --title "feat: [nombre feature]" \
  --body "$(cat <<'EOF'
## Resumen
Descripción de los cambios

## Cambios incluidos
- Cambio 1
- Cambio 2

## Tests
- [x] Tests unitarios pasando
- [x] Tests de integración pasando
- [x] Validación manual realizada

## Checklist
- [x] CI pasando
- [x] Documentación actualizada
- [x] CHANGELOG actualizado
EOF
)"
```

O en la web: GitHub > Pull Requests > New Pull Request

### 8. Code Review

#### 8.1 Responder a Comentarios

```bash
# Hacer cambios solicitados
vim archivo.sh

# Commit
git add .
git commit -m "fix: atender comentarios de review"

# Push
git push
```

#### 8.2 Aprobar y Merge

Una vez aprobado:

```bash
# Squash and merge (recomendado)
gh pr merge --squash --delete-branch

# O merge normal
gh pr merge --merge
```

## Convenciones de Commits

### Formato

```
<tipo>(<scope>): <descripción>

[cuerpo opcional]

[footer opcional]
```

### Tipos

- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Formato, puntuación, etc.
- `refactor`: Refactorización de código
- `test`: Agregar o modificar tests
- `chore`: Tareas de mantenimiento

### Ejemplos

```bash
# Feature simple
git commit -m "feat: agregar autenticación de usuarios"

# Feature con scope
git commit -m "feat(auth): implementar login con OAuth"

# Fix
git commit -m "fix: corregir validación de email"

# Docs
git commit -m "docs: actualizar procedimiento de deployment"

# Con cuerpo
git commit -m "feat: implementar caché de resultados

Agrega sistema de caché usando Redis para mejorar performance.
Reduce tiempo de respuesta en 80%.

Closes #123"
```

## Checklist de Feature Completa

Antes de marcar la feature como completa:

- [ ] Código implementado y funcional
- [ ] Tests escritos y pasando
- [ ] Linting sin errores: `make lint`
- [ ] CI completo pasando: `make ci`
- [ ] Documentación actualizada
- [ ] CHANGELOG actualizado
- [ ] README actualizado (si aplica)
- [ ] Procedimiento creado (si aplica)
- [ ] Code review completado
- [ ] PR aprobado
- [ ] Merge a main completado
- [ ] Rama feature eliminada

## Plantilla de Feature Branch

Script helper: `scripts/bash/create-new-feature.sh`

```bash
#!/usr/bin/env bash

FEATURE_NAME="$1"

if [[ -z "$FEATURE_NAME" ]]; then
  echo "Uso: $0 <nombre-feature>"
  exit 1
fi

# Actualizar main
git checkout main
git pull

# Crear rama
git checkout -b "feature/$FEATURE_NAME"

# Crear estructura
mkdir -p "scripts/bash"
mkdir -p "test"
mkdir -p "docs/procedimientos"

echo "Feature branch creada: feature/$FEATURE_NAME"
echo "Siguiente paso: Implementar funcionalidad"
```

Uso:

```bash
./scripts/bash/create-new-feature.sh auth-system
```

## Mejores Prácticas

1. **Mantener features pequeñas:**
   - Una feature = una funcionalidad específica
   - Si es muy grande, dividir en sub-features

2. **Commits atómicos:**
   - Cada commit debe ser una unidad lógica
   - Debe poder revertirse sin romper nada

3. **Tests primero (TDD):**
   ```bash
   # Escribir test (falla)
   bats test/test_feature.bats

   # Implementar código
   vim scripts/bash/feature.sh

   # Test pasa
   bats test/test_feature.bats
   ```

4. **Documentar mientras desarrollas:**
   - No dejar documentación para el final
   - Actualizar README con cada cambio significativo

5. **Rebase frecuente con main:**
   ```bash
   git fetch origin
   git rebase origin/main
   ```

## Solución de Problemas

### Conflictos de Merge

```bash
# Rebase con main
git fetch origin
git rebase origin/main

# Resolver conflictos
vim archivo-conflicto

# Continuar rebase
git add .
git rebase --continue
```

### CI Falla en PR

```bash
# Pull de la rama
git checkout feature/mi-feature

# Ejecutar CI localmente
make ci

# Corregir errores
# Commit y push
git push
```

### Branch desactualizado

```bash
# Actualizar desde main
git checkout feature/mi-feature
git fetch origin
git rebase origin/main
git push --force-with-lease
```

## Referencias

- Script helper: `scripts/bash/create-new-feature.sh`
- Convenciones: <https://www.conventionalcommits.org/>
- GitHub CLI: <https://cli.github.com/>

## Historial de Cambios

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-11-03 | 1.0 | Creación inicial del procedimiento |
