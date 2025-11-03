# Procedimiento de Linting

## Objetivo

Validar la calidad del código mediante análisis estático de scripts shell y
archivos markdown antes de realizar commits o despliegues.

## Alcance

Este procedimiento aplica a:

- Todos los scripts shell (*.sh) en el directorio `scripts/bash/`
- Todos los archivos markdown (*.md) en el repositorio
- Validaciones pre-commit y pre-push

## Responsables

- **Ejecutor**: Desarrollador
- **Validador**: Sistema de CI/CD automático
- **Revisor**: Tech Lead (en pull requests)

## Prerequisitos

### Dependencias Requeridas

- markdownlint-cli2 (validación de markdown)
- shellcheck (análisis de scripts shell)
- GNU Make

### Verificación de Dependencias

```bash
make check-deps
```

### Instalación de Dependencias

Si faltan dependencias:

```bash
# Node.js y npm requeridos
npm install -g markdownlint-cli2

# shellcheck (Linux)
wget https://github.com/koalaman/shellcheck/releases/download/v0.10.0/shellcheck-v0.10.0.linux.x86_64.tar.xz
tar -xf shellcheck-v0.10.0.linux.x86_64.tar.xz
sudo cp shellcheck-v0.10.0/shellcheck /usr/local/bin/
```

## Procedimiento

### 1. Linting Completo

Ejecutar todos los linters (markdown + shell):

```bash
make lint
```

**Salida esperada:**

```
[lint-markdown] Ejecutando markdownlint-cli2...
markdownlint-cli2 v0.18.1 (markdownlint v0.38.0)
Summary: 0 error(s)

[lint-shell] Ejecutando shellcheck...
[lint] Linting completado
```

### 2. Linting de Markdown Únicamente

```bash
make lint-markdown
```

**Archivos validados:**

- Todos los archivos `*.md`
- Excluye: `docs/_site/**`, `node_modules/**`, `venv/**`

**Reglas aplicadas:**

- Configuración en `.markdownlint-cli2.jsonc`
- Reglas deshabilitadas para este proyecto:
  - MD013: longitud de línea (demasiado restrictiva)
  - MD032: líneas alrededor de listas
  - MD036: énfasis como encabezado
  - MD040: lenguaje en bloques de código

### 3. Linting de Shell Scripts Únicamente

```bash
make lint-shell
```

**Archivos validados:**

- `scripts/bash/*.sh`
- `src/project.sh`

**Validaciones de shellcheck:**

- Uso correcto de variables
- Manejo de errores
- Portabilidad POSIX
- Buenas prácticas de shell scripting

### 4. Linting con Salto de Validaciones

Para desarrollo rápido, se pueden omitir validaciones:

```bash
# Solo markdown
SKIP_SHELL=1 make lint

# Solo shell
SKIP_MARKDOWN=1 make lint
```

## Corrección de Errores

### Errores Comunes de Markdown

**MD022 - Líneas alrededor de encabezados:**

```markdown
# Incorrecto
## Título
Contenido inmediato

# Correcto
## Título

Contenido con línea en blanco
```

**MD041 - Primera línea debe ser H1:**

```markdown
# Incorrecto
## Título de nivel 2

# Correcto
# Título de nivel 1
```

**MD034 - URLs sin formato:**

```markdown
# Incorrecto
Contacto: email@example.com

# Correcto
Contacto: <email@example.com>
```

### Errores Comunes de Shell

**SC2086 - Comillas en variables:**

```bash
# Incorrecto
cd $DIR

# Correcto
cd "$DIR"
```

**SC2046 - Comillas en sustitución de comandos:**

```bash
# Incorrecto
for file in $(ls *.txt); do

# Correcto
while IFS= read -r file; do
  # procesar archivo
done < <(find . -name "*.txt")
```

**SC2034 - Variable no utilizada:**

```bash
# Incorrecto
UNUSED_VAR="valor"

# Correcto (usar _ para variables intencionales)
_UNUSED_VAR="valor"  # Variable para documentación
```

## Integración con Git Hooks

El linting se ejecuta automáticamente en:

**Pre-commit:**

- Valida archivos modificados antes de commit
- Script: `scripts/bash/spec-sync-pre-commit.sh`

**Pre-push:**

- Valida todos los archivos antes de push
- Script: `scripts/bash/spec-sync-pre-push.sh`

### Instalación de Hooks

```bash
make install-hooks
```

### Desactivar Hooks Temporalmente

```bash
# Commit sin hooks
git commit --no-verify -m "mensaje"

# Push sin hooks
git push --no-verify
```

## Solución de Problemas

### Error: markdownlint-cli2 no encontrado

```bash
npm install -g markdownlint-cli2
```

### Error: shellcheck no encontrado

```bash
# Verificar instalación
which shellcheck

# Reinstalar si es necesario
# Ver sección "Instalación de Dependencias"
```

### Demasiados errores de markdown

Si el linter reporta muchos errores:

1. Revisar configuración en `.markdownlint-cli2.jsonc`
2. Considerar deshabilitar reglas no críticas
3. Usar herramientas de auto-corrección:

```bash
# Corrección automática (si disponible)
markdownlint-cli2 --fix "**/*.md"
```

## Mejores Prácticas

1. **Ejecutar lint antes de commit:**
   ```bash
   make lint && git commit -m "mensaje"
   ```

2. **Integrar en workflow local:**
   ```bash
   # En tu ~/.bashrc o ~/.zshrc
   alias pre-commit="make lint"
   ```

3. **Revisar errores específicos:**
   ```bash
   # Ver detalles de errores de shell
   shellcheck scripts/bash/mi-script.sh

   # Ver detalles de errores de markdown
   markdownlint-cli2 docs/mi-documento.md
   ```

4. **Validar antes de PR:**
   ```bash
   make ci  # Incluye linting completo
   ```

## Métricas de Calidad

El proyecto debe mantener:

- **0 errores** de linting en main/master
- **0 warnings críticos** de shellcheck
- **100% de archivos** validados

## Referencias

- Configuración: `.markdownlint-cli2.jsonc`
- Scripts: `scripts/bash/lint-local.sh`
- Documentación shellcheck: <https://www.shellcheck.net/>
- Reglas markdownlint: <https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md>

## Historial de Cambios

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-11-03 | 1.0 | Creación inicial del procedimiento |
