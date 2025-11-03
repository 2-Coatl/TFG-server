# Procedimiento de Instalación y Gestión de Git Hooks

## Objetivo

Configurar y mantener git hooks automáticos que validen la calidad del código en
momentos clave del flujo de desarrollo (commit, push, post-commit).

## Alcance

Este procedimiento cubre:

- Instalación de git hooks personalizados
- Configuración de validaciones automáticas
- Gestión de hooks en el ciclo de vida del proyecto
- Resolución de problemas con hooks

## Responsables

- **Ejecutor**: Cada desarrollador del equipo
- **Mantenedor**: Tech Lead
- **Auditor**: DevOps Engineer

## ¿Qué son los Git Hooks?

Los git hooks son scripts que Git ejecuta automáticamente en respuesta a
eventos específicos:

- **pre-commit**: Antes de crear un commit
- **pre-push**: Antes de hacer push al remoto
- **post-commit**: Después de crear un commit

## Hooks del Proyecto

### pre-commit

**Script:** `scripts/bash/spec-sync-pre-commit.sh`

**Función:**

- Valida sintaxis de archivos modificados
- Verifica formato básico
- Ejecución rápida (~2-5 segundos)

**Se ejecuta:**

- Automáticamente antes de `git commit`
- Bloquea el commit si hay errores

### pre-push

**Script:** `scripts/bash/spec-sync-pre-push.sh`

**Función:**

- Ejecuta linting completo
- Ejecuta suite de tests
- Validación exhaustiva (~10-20 segundos)

**Se ejecuta:**

- Automáticamente antes de `git push`
- Bloquea el push si hay errores

### post-commit

**Script:** `scripts/bash/spec-sync-post-commit.sh`

**Función:**

- Sincroniza metadatos del proyecto
- Actualiza índices internos
- No bloquea operaciones

**Se ejecuta:**

- Automáticamente después de `git commit`
- Siempre tiene éxito (no bloquea)

## Instalación

### Instalación Completa (Recomendado)

```bash
make install-hooks
```

**Salida esperada:**

```
[install-hooks] Instalando git hooks...
[spec-hooks-install] Instalando git hooks del proyecto
Hook instalado: pre-commit
Hook instalado: pre-push
Hook instalado: post-commit
[install-hooks] Git hooks instalados
```

### Instalación Manual

```bash
./scripts/bash/spec-hooks-install.sh
```

### Verificación de Instalación

```bash
# Listar hooks instalados
ls -la .git/hooks/

# Deberías ver:
# pre-commit -> ../../scripts/bash/spec-sync-pre-commit.sh
# pre-push -> ../../scripts/bash/spec-sync-push.sh
# post-commit -> ../../scripts/bash/spec-sync-post-commit.sh
```

### Desinstalación

```bash
# Eliminar hooks
rm .git/hooks/pre-commit
rm .git/hooks/pre-push
rm .git/hooks/post-commit

# O eliminar todo
rm .git/hooks/*
```

## Uso Diario

### Workflow Normal (Con Hooks)

```bash
# 1. Hacer cambios
vim archivo.md

# 2. Agregar al stage
git add archivo.md

# 3. Commit (pre-commit se ejecuta automáticamente)
git commit -m "docs: actualizar archivo"
# ✓ Hook pre-commit: validando...
# ✓ Hook pre-commit: OK

# 4. Push (pre-push se ejecuta automáticamente)
git push
# ✓ Hook pre-push: ejecutando tests...
# ✓ Hook pre-push: OK
```

### Omitir Hooks (Emergencias)

```bash
# Omitir pre-commit
git commit --no-verify -m "hotfix urgente"

# Omitir pre-push
git push --no-verify
```

**⚠️ ADVERTENCIA:** Solo usar en emergencias. El código sin validar puede
romper el build.

### Desactivar Hooks Temporalmente

```bash
# Método 1: Renombrar
mv .git/hooks/pre-commit .git/hooks/pre-commit.disabled

# Trabajar...

# Reactivar
mv .git/hooks/pre-commit.disabled .git/hooks/pre-commit

# Método 2: Usar variable de entorno
SKIP_HOOKS=1 git commit -m "mensaje"
```

## Configuración Avanzada

### Personalizar Hook pre-commit

Editar: `scripts/bash/spec-sync-pre-commit.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "[pre-commit] Ejecutando validaciones..."

# Agregar validaciones personalizadas
# Ejemplo: validar nombres de archivos
if git diff --cached --name-only | grep -q " "; then
  echo "ERROR: Archivos con espacios en el nombre"
  exit 1
fi

echo "[pre-commit] OK"
```

Después de editar:

```bash
# Reinstalar hooks
make install-hooks
```

### Ejecutar Hook Manualmente

```bash
# Probar pre-commit sin hacer commit
.git/hooks/pre-commit

# Probar pre-push sin hacer push
.git/hooks/pre-push
```

## Hooks en Equipo

### Primera Instalación para Nuevos Desarrolladores

```bash
# 1. Clonar repositorio
git clone <repo-url>
cd TFG-server

# 2. Instalar hooks
make install-hooks

# 3. Verificar instalación
ls -la .git/hooks/
```

### Actualización de Hooks

Cuando el equipo actualiza los scripts de hooks:

```bash
# 1. Pull de cambios
git pull

# 2. Reinstalar hooks
make install-hooks

# 3. Los hooks ahora usan las últimas versiones
```

### Hooks en CI/CD

Los hooks NO se ejecutan en CI/CD automáticamente. En su lugar:

```bash
# CI ejecuta las mismas validaciones directamente
make ci
```

## Solución de Problemas

### Hook bloquea commit pero no hay errores visibles

```bash
# Ejecutar hook manualmente para ver salida
.git/hooks/pre-commit
```

### Hook no se ejecuta

**Verificar:**

```bash
# 1. Existe el hook?
ls -la .git/hooks/pre-commit

# 2. Tiene permisos de ejecución?
chmod +x .git/hooks/pre-commit

# 3. Apunta al script correcto?
cat .git/hooks/pre-commit
```

### Hook falla siempre

```bash
# Desactivar temporalmente
git commit --no-verify -m "mensaje"

# Reportar problema al equipo
# Reinstalar después de fix
make install-hooks
```

### Hook muy lento

**Pre-commit lento:**

```bash
# Editar spec-sync-pre-commit.sh
# Reducir validaciones a solo archivos modificados
```

**Pre-push lento:**

```bash
# Considerar skip temporal durante desarrollo
SKIP_HOOKS=1 git push

# O configurar para ejecutar solo en main
```

## Mejores Prácticas

1. **Instalar hooks inmediatamente:**
   ```bash
   # Primer comando después de clone
   make install-hooks
   ```

2. **No omitir hooks sin razón:**
   - Usar `--no-verify` solo en emergencias
   - Documentar por qué se omitió

3. **Mantener hooks actualizados:**
   ```bash
   # Después de cada git pull
   make install-hooks
   ```

4. **Probar cambios en hooks:**
   ```bash
   # Antes de commit del script modificado
   .git/hooks/pre-commit
   ```

5. **Documentar hooks personalizados:**
   - Agregar comentarios en scripts
   - Actualizar este procedimiento

## Hooks Avanzados

### Hook condicional por rama

```bash
#!/usr/bin/env bash

# Solo ejecutar en main
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" != "main" ]]; then
  exit 0
fi

# Validaciones estrictas para main
make ci
```

### Hook con notificaciones

```bash
#!/usr/bin/env bash

if ! make lint; then
  # Notificar fallo
  notify-send "Pre-commit Failed" "Fix linting errors"
  exit 1
fi
```

### Hook con caché

```bash
#!/usr/bin/env bash

# Cache de última ejecución
CACHE_FILE=".git/pre-commit-cache"

# Si no hay cambios desde última vez
if git diff --cached | sha256sum | grep -q "$(cat $CACHE_FILE)"; then
  echo "Sin cambios desde última validación"
  exit 0
fi

# Ejecutar validaciones
make lint

# Guardar hash
git diff --cached | sha256sum > $CACHE_FILE
```

## Integración con IDE

### VSCode

Agregar a `.vscode/settings.json`:

```json
{
  "git.enableCommitSigning": true,
  "git.alwaysSignOff": true
}
```

### IntelliJ/PyCharm

Settings > Version Control > Git > "Run Git hooks"

## Métricas de Hooks

### Tiempo de Ejecución

```bash
# Medir tiempo de pre-commit
time .git/hooks/pre-commit

# Medir tiempo de pre-push
time .git/hooks/pre-push
```

**Objetivos:**

- pre-commit: < 5 segundos
- pre-push: < 30 segundos

### Tasa de Fallos

Monitorear:

- Frecuencia de `--no-verify`
- Commits que rompen build
- Tiempo de corrección

## Referencias

- Scripts de hooks: `scripts/bash/spec-*`
- Instalador: `scripts/bash/spec-hooks-install.sh`
- Git Hooks Docs: <https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks>

## Historial de Cambios

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-11-03 | 1.0 | Creación inicial del procedimiento |
