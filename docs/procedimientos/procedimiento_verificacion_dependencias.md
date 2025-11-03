# Procedimiento de Verificación de Dependencias

## Objetivo

Verificar que todas las herramientas y dependencias necesarias para el
desarrollo estén correctamente instaladas y configuradas.

## Comando Rápido

```bash
make check-deps
```

## Dependencias Requeridas

| Herramienta | Propósito | Versión Mínima |
|-------------|-----------|----------------|
| bats | Testing | 1.0+ |
| shellcheck | Linting shell | 0.9+ |
| markdownlint-cli2 | Linting markdown | 0.12+ |
| docfx | Documentación | 2.70+ |

## Procedimiento de Verificación

### 1. Verificación Automática

```bash
make check-deps
```

**Salida esperada (todas instaladas):**

```
[check-deps] Verificando dependencias...
  ✓ bats
  ✓ shellcheck
  ✓ markdownlint-cli2
  ✓ docfx
[check-deps] Todas las dependencias están instaladas
```

**Salida con dependencias faltantes:**

```
[check-deps] Verificando dependencias...
  ✗ bats no encontrado
  ✓ shellcheck
  ✗ markdownlint-cli2 no encontrado
  ✓ docfx
[check-deps] Faltan 2 dependencia(s)
```

### 2. Instalación de Dependencias Faltantes

#### BATS (Bash Automated Testing System)

```bash
npm install -g bats

# Verificar
bats --version
```

#### shellcheck

```bash
# Linux
wget https://github.com/koalaman/shellcheck/releases/download/v0.10.0/shellcheck-v0.10.0.linux.x64.tar.xz
tar -xf shellcheck-v0.10.0.linux.x64.tar.xz
sudo cp shellcheck-v0.10.0/shellcheck /usr/local/bin/

# macOS
brew install shellcheck

# Verificar
shellcheck --version
```

#### markdownlint-cli2

```bash
npm install -g markdownlint-cli2

# Verificar
markdownlint-cli2 --version
```

#### DocFX

```bash
# Linux/macOS
wget https://github.com/dotnet/docfx/releases/download/v2.70.0/docfx-linux-x64-v2.70.0.zip
unzip docfx-linux-x64-v2.70.0.zip -d ~/docfx
export PATH=$PATH:~/docfx

# Windows
choco install docfx

# Verificar
docfx --version
```

### 3. Verificación Post-Instalación

```bash
# Verificar nuevamente
make check-deps

# Debería mostrar todas con ✓
```

## Script Manual de Verificación

```bash
#!/usr/bin/env bash

echo "Verificando dependencias..."

# Función helper
check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "  ✓ $1"
    return 0
  else
    echo "  ✗ $1 no encontrado"
    return 1
  fi
}

# Verificar cada una
check_cmd bats
check_cmd shellcheck
check_cmd markdownlint-cli2
check_cmd docfx

echo "Verificación completa"
```

## Dependencias Opcionales

### Para Desarrollo

- **Node.js 18+**: Para herramientas npm
- **Python 3.11+**: Para scripts auxiliares
- **Make**: Para comandos de automatización

### Verificación de Opcionales

```bash
node --version
python3 --version
make --version
```

## Solución de Problemas

### Dependencia instalada pero no detectada

```bash
# Verificar PATH
echo $PATH

# Buscar binario
which bats
which shellcheck

# Actualizar PATH si es necesario
export PATH=$PATH:/ruta/al/binario
```

### npm install falla

```bash
# Limpiar cache
npm cache clean --force

# Reinstalar
npm install -g markdownlint-cli2 bats
```

### Permisos denegados

```bash
# Usar sudo para instalación global
sudo npm install -g markdownlint-cli2

# O configurar prefijo local
npm config set prefix ~/.npm-global
export PATH=$PATH:~/.npm-global/bin
```

## Integración con Setup

Este comando se ejecuta automáticamente en:

- Setup inicial: `docs/procedimientos/procedimiento_instalacion_entorno.md`
- Antes de CI: `make ci` verifica dependencias

## Referencias

- Script: `Makefile` (target: `check-deps`)
- Instalación: `docs/procedimientos/procedimiento_instalacion_entorno.md`

## Historial de Cambios

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-11-03 | 1.0 | Creación inicial del procedimiento |
