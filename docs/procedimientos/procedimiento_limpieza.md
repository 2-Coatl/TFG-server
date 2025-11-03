# Procedimiento de Limpieza del Proyecto

## Objetivo

Limpiar archivos generados, caches y artefactos temporales para mantener el
repositorio limpio y resolver problemas de builds.

## Comando Rápido

```bash
make clean
```

## ¿Qué se Limpia?

### Archivos y Directorios Eliminados

1. **Documentación generada:**
   - `docs/_site/` - Sitio estático de DocFX

2. **Archivos Python:**
   - `**/*.pyc` - Bytecode compilado
   - `**/__pycache__/` - Directorios de cache
   - `**/.pytest_cache/` - Cache de pytest

3. **Archivos de Node.js:**
   - `node_modules/` - Dependencias npm (opcional)
   - `package-lock.json` (si se regenera)

4. **Archivos temporales:**
   - `.DS_Store` (macOS)
   - `*.swp`, `*.swo` (Vim)
   - `*~` (backups de editor)

## Procedimiento

### 1. Limpieza Estándar

```bash
make clean
```

**Salida esperada:**

```
[clean] Limpiando archivos generados...
[clean] Limpieza completada
```

**Archivos eliminados:**

- docs/_site/
- *.pyc
- __pycache__/
- .pytest_cache/

### 2. Limpieza Profunda (Completa)

```bash
# Limpieza estándar + node_modules
make clean
rm -rf node_modules/

# O limpieza completa manual
make deep-clean  # Si existe este target
```

### 3. Limpieza Selectiva

#### Solo Documentación

```bash
rm -rf docs/_site/
```

Útil cuando solo quieres regenerar la documentación.

#### Solo Cache Python

```bash
find . -type f -name "*.pyc" -delete
find . -type d -name "__pycache__" -delete
```

#### Solo Cache de Tests

```bash
find . -type d -name ".pytest_cache" -delete
rm -rf .tox/  # Si usas tox
```

### 4. Limpieza Git

```bash
# Eliminar archivos no tracked
git clean -fd

# Previsualizar qué se eliminará
git clean -fdn

# Incluir archivos ignorados
git clean -fdx

# ⚠️ PELIGROSO: Incluye archivos ignorados importantes
```

## Cuándo Limpiar

### Casos de Uso

1. **Antes de build limpio:**
   ```bash
   make clean
   make ci
   ```

2. **Errores de generación de docs:**
   ```bash
   make clean
   make docs
   ```

3. **Problemas con dependencias:**
   ```bash
   make clean
   rm -rf node_modules/
   npm install
   ```

4. **Antes de cambiar de rama:**
   ```bash
   make clean
   git checkout otra-rama
   ```

5. **Liberar espacio en disco:**
   ```bash
   make clean
   docker system prune -a  # Si usas Docker
   ```

## Limpieza Automática

### Git Hooks

El hook `post-merge` puede limpiar automáticamente:

```bash
# .git/hooks/post-merge
#!/usr/bin/env bash
make clean
```

### Script Periódico

```bash
# Cron job para limpieza semanal
0 0 * * 0 cd /path/to/TFG-server && make clean
```

## Verificación Post-Limpieza

```bash
# Verificar archivos generados eliminados
ls docs/_site/  # No debe existir

# Verificar cache Python eliminado
find . -name "__pycache__" | wc -l  # Debe ser 0

# Verificar tamaño del directorio
du -sh .
```

## Regeneración Después de Limpieza

```bash
# 1. Limpiar
make clean

# 2. Regenerar todo
make ci

# 3. Reinstalar hooks si es necesario
make install-hooks
```

## Limpieza en CI/CD

En pipelines de CI, se recomienda:

```bash
# Inicio de CI
make clean

# Ejecutar validaciones
make ci

# No es necesario limpiar al final (CI elimina el workspace)
```

## Solución de Problemas

### Error: Permission denied

```bash
# Dar permisos
chmod -R u+w docs/_site/

# Limpiar
make clean
```

### Error: Directory not found

Es normal. Significa que no hay nada que limpiar.

### Archivos no se eliminan

```bash
# Verificar permisos
ls -la docs/_site/

# Forzar eliminación
sudo rm -rf docs/_site/  # Usar con precaución
```

## Script de Limpieza Personalizado

```bash
#!/usr/bin/env bash
# clean-all.sh

echo "Limpiando proyecto..."

# Documentación
rm -rf docs/_site/
echo "✓ Docs limpiados"

# Python
find . -type f -name "*.pyc" -delete
find . -type d -name "__pycache__" -delete
find . -type d -name ".pytest_cache" -delete
echo "✓ Cache Python limpiado"

# Node.js
rm -rf node_modules/
echo "✓ Node modules eliminados"

# Archivos temporales
find . -name ".DS_Store" -delete
find . -name "*.swp" -delete
find . -name "*~" -delete
echo "✓ Archivos temporales eliminados"

# Git
git clean -fdx -e node_modules -e venv
echo "✓ Git clean ejecutado"

echo "Limpieza completa"
```

## Mejores Prácticas

1. **Limpiar antes de CI local:**
   ```bash
   make clean && make ci
   ```

2. **No commitear archivos generados:**
   - Verificar `.gitignore` incluye `docs/_site/`
   - Verificar que `__pycache__/` está ignorado

3. **Limpiar después de resolver conflictos:**
   ```bash
   git merge main
   make clean
   ```

4. **Documentar archivos que NO deben limpiarse:**
   - Configuraciones personales
   - Secretos locales
   - Bases de datos de desarrollo

## Archivos Protegidos

Estos archivos NUNCA deben eliminarse con clean:

- `.git/` - Historial de Git
- `scripts/` - Scripts del proyecto
- `docs/**/*.md` - Documentación fuente
- `test/` - Suite de tests
- `.env` - Variables de entorno (si existen)

## Métricas

### Espacio Liberado

```bash
# Antes de limpieza
du -sh .

# Después de limpieza
make clean
du -sh .

# Mostrar diferencia
```

Típicamente libera: 50-200 MB dependiendo del tamaño de `docs/_site/`

## Referencias

- Makefile: Target `clean`
- `.gitignore`: Archivos ignorados por Git
- Docs: `docs/automation/ci-cd.md`

## Historial de Cambios

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-11-03 | 1.0 | Creación inicial del procedimiento |
