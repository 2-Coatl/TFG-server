# Servidor MCP - Model Context Protocol

## Visión General

El servidor MCP (Model Context Protocol) permite que asistentes de IA como Claude Code, Cursor y otros clientes MCP interactúen de forma inteligente con el proyecto TFG Server. Implementado completamente en Shell/Bash, expone herramientas especializadas para análisis de requisitos, validación de código y ejecución de pipelines CI.

**Decisión arquitectónica**: [ADR 0003: Servidor MCP en Shell](../../diseno_solucion/arquitectura_sistemas/adr/0003-servidor-mcp-shell.md)

## Ubicación

```
.devcontainer/mcp/
├── README.md              # Documentación técnica completa
├── server.sh              # Servidor JSON-RPC principal
├── lib/
│   └── mcp-common.sh     # Funciones comunes
└── tools/                 # Herramientas MCP
    ├── analyze-requirements.sh
    ├── run-ci.sh
    ├── scan-shell.sh
    ├── list-governance.sh
    └── validate-structure.sh
```

## Requisitos Previos

### Software requerido

- **Bash 4.0+**: Intérprete shell
- **jq**: Procesamiento JSON
- **shellcheck** (opcional): Mejora análisis de scripts
- **bats** (opcional): Requerido para `run_ci_pipeline`

Verificar dependencias:

```bash
make check-deps
```

### Entorno de ejecución

El servidor MCP se ejecuta automáticamente en:

- **VSCode Devcontainers**
- **GitHub Codespaces**
- **Cursor**
- **Claude Code**

La configuración se encuentra en `.devcontainer/devcontainer.json`.

## Herramientas Disponibles

### 1. analyze_requirements

**Propósito**: Analiza documentos de requisitos contra estándares ISO 29148, BABOK v3 y PMBOK 7.

**Parámetros**:
- `file_path` (string, requerido): Ruta relativa en `docs/requisitos/`

**Ejemplo de uso**:
```json
{
  "name": "analyze_requirements",
  "arguments": {
    "file_path": "registro_maestro.md"
  }
}
```

**Salida**:
- Estadísticas de requisitos por tipo (REQ-BN, REQ-FN, REQ-NF, etc.)
- Validación contra ISO 29148 (introducción, alcance, definiciones)
- Puntuación de calidad (0-100)
- Recomendaciones de mejora

**Tipos de requisitos detectados**:
- `REQ-BN-*`: Requisitos de Negocio (Business Requirements)
- `REQ-SH-*`: Requisitos de Stakeholders
- `REQ-FN-*`: Requisitos Funcionales
- `REQ-NF-*`: Requisitos No Funcionales
- `REQ-TR-*`: Requisitos de Transición
- `UC-*`: Casos de Uso

### 2. run_ci_pipeline

**Propósito**: Ejecuta el pipeline completo de integración continua.

**Parámetros**:
- `skip_tests` (boolean, opcional): Omitir ejecución de tests

**Ejemplo de uso**:
```json
{
  "name": "run_ci_pipeline",
  "arguments": {
    "skip_tests": false
  }
}
```

**Pasos ejecutados**:
1. Verificar dependencias (`make check-deps`)
2. Lint Markdown (`make lint-markdown`)
3. Lint Shell (`make lint-shell`)
4. Tests BATS (`make test`) - si no se omite
5. Generar documentación (`make docs`)

**Salida**:
- Resumen de ejecución con métricas
- Estado de cada paso (✅/❌)
- Tasa de éxito
- Recomendaciones de acción

### 3. scan_shell_quality

**Propósito**: Analiza la calidad de scripts shell con métricas avanzadas.

**Parámetros**:
- `script_path` (string, requerido): Ruta relativa al script `.sh`

**Ejemplo de uso**:
```json
{
  "name": "scan_shell_quality",
  "arguments": {
    "script_path": "scripts/bash/ci-local.sh"
  }
}
```

**Métricas analizadas**:
- Líneas de código, comentarios, funciones
- Complejidad ciclomática (if, loops, case)
- Mejores prácticas (shebang, `set -euo pipefail`)
- Análisis shellcheck (errores y warnings)
- Patrones problemáticos (`eval`, backticks)

**Salida**:
- Métricas detalladas
- Análisis de complejidad
- Validación de mejores prácticas
- Resultados de shellcheck
- Puntuación de calidad (0-100)
- Recomendaciones específicas

### 4. list_governance_docs

**Propósito**: Lista documentos de gobernanza disponibles.

**Parámetros**: Ninguno

**Ejemplo de uso**:
```json
{
  "name": "list_governance_docs",
  "arguments": {}
}
```

**Salida**:
- Lista de documentos en `docs/gobernanza/`
- Total de documentos
- Rutas relativas

### 5. validate_project_structure

**Propósito**: Valida que la estructura del proyecto cumple con las convenciones.

**Parámetros**: Ninguno

**Ejemplo de uso**:
```json
{
  "name": "validate_project_structure",
  "arguments": {}
}
```

**Validaciones**:
- Directorios esperados (docs/, scripts/bash/, test/, etc.)
- Archivos clave (README.md, Makefile, devcontainer.json)

**Salida**:
- Estado de cada directorio/archivo (✅/❌)
- Resumen de validación
- Elementos faltantes

## Arquitectura Técnica

### Protocolo JSON-RPC

El servidor implementa **MCP 2024-11-05** usando JSON-RPC 2.0 sobre stdio.

**Métodos soportados**:

```
initialize              → Handshake inicial
tools/list              → Listar herramientas disponibles
tools/call              → Ejecutar herramienta específica
notifications/initialized → Confirmación (no requiere respuesta)
```

### Flujo de comunicación

```
Cliente                    Servidor MCP
   |                            |
   |---(initialize)------------>|
   |<--(capabilities)-----------|
   |                            |
   |---(tools/list)------------>|
   |<--(lista de tools)---------|
   |                            |
   |---(tools/call)------------>|
   |    {name, arguments}       |
   |                            |
   |<--(resultado)--------------|
```

### Separación de streams

- **stdout**: Solo JSON-RPC (comunicación con cliente)
- **stderr**: Logs y debugging (formato: `[MCP timestamp] mensaje`)

Esta separación evita que los logs interfieran con el protocolo.

### Manejo de errores

El servidor retorna errores JSON-RPC estándar:

```json
{
  "jsonrpc": "2.0",
  "id": "...",
  "error": {
    "code": -32603,
    "message": "Descripción del error"
  }
}
```

Códigos de error comunes:
- `-32700`: Parse error (JSON inválido)
- `-32600`: Invalid request
- `-32601`: Method not found
- `-32603`: Internal error (ejecución de herramienta falló)

## Integración con Devcontainer

### Configuración automática

`.devcontainer/devcontainer.json`:

```json
{
  "customizations": {
    "vscode": {
      "settings": {
        "mcp.servers": {
          "tfg-requirements": {
            "command": "bash",
            "args": ["${workspaceFolder}/.devcontainer/mcp/server.sh"],
            "description": "TFG Requirements Engineering Server"
          }
        }
      }
    }
  }
}
```

### Extensiones recomendadas

Agregadas automáticamente al devcontainer:
- `timonwong.shellcheck`: Análisis de scripts Shell
- `foxundermoon.shell-format`: Formateo de scripts

## Testing Manual

### Pruebas básicas

```bash
cd .devcontainer/mcp

# Test 1: Inicialización
echo '{"jsonrpc":"2.0","id":"1","method":"initialize","params":{}}' | \
  ./server.sh 2>/dev/null

# Test 2: Listar herramientas
echo '{"jsonrpc":"2.0","id":"2","method":"tools/list","params":{}}' | \
  ./server.sh 2>/dev/null | jq '.result.tools[].name'

# Test 3: Validar estructura
echo '{"jsonrpc":"2.0","id":"3","method":"tools/call","params":{"name":"validate_project_structure","arguments":{}}}' | \
  ./server.sh 2>/dev/null | jq -r '.result.content[0].text'
```

### Pruebas de herramientas directamente

```bash
# Analizar requisitos
./tools/analyze-requirements.sh '{"file_path":"registro_maestro.md"}'

# Validar estructura
./tools/validate-structure.sh '{}'

# Analizar script
./tools/scan-shell.sh '{"script_path":"scripts/bash/ci-local.sh"}'
```

## Mantenimiento

### Agregar nueva herramienta

1. **Crear script en `tools/`**:
```bash
touch .devcontainer/mcp/tools/mi-herramienta.sh
chmod +x .devcontainer/mcp/tools/mi-herramienta.sh
```

2. **Usar plantilla estándar**:
```bash
#!/usr/bin/env bash
set -euo pipefail

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_DIR="$(dirname "$TOOLS_DIR")"
PROJECT_ROOT="$(cd "$MCP_DIR/../.." && pwd)"

source "$MCP_DIR/lib/mcp-common.sh"

ARGS="${1:-"{}"}"
# Parsear argumentos con jq

# Tu lógica aquí

mcp_tool_success "$RESULTADO"
```

3. **Registrar en `server.sh`**:
- Agregar a `list_tools()`
- Agregar caso en `call_tool()`

4. **Documentar**:
- Actualizar `.devcontainer/mcp/README.md`
- Actualizar este documento
- Agregar tests

### Logs y debugging

Ver logs del servidor:

```bash
# Ejecutar con logs visibles
echo '...' | ./server.sh 2>&1 | grep "^\[MCP"

# Guardar logs en archivo
./server.sh 2>mcp-debug.log
```

### Actualizar protocolo MCP

Si MCP actualiza su especificación:

1. Revisar [https://modelcontextprotocol.io/](https://modelcontextprotocol.io/)
2. Actualizar `PROTOCOL_VERSION` en `server.sh`
3. Implementar nuevos métodos si es necesario
4. Actualizar documentación

## Troubleshooting

### Servidor no inicia

**Síntoma**: Servidor no responde o retorna errores.

**Soluciones**:
```bash
# Verificar permisos
chmod +x .devcontainer/mcp/server.sh

# Verificar jq
command -v jq || echo "jq no instalado"

# Verificar sintaxis
bash -n .devcontainer/mcp/server.sh
```

### Cliente MCP no detecta servidor

**Síntoma**: VSCode/Cursor no muestra el servidor MCP.

**Soluciones**:
1. Reconstruir devcontainer: `Cmd/Ctrl+Shift+P` → "Rebuild Container"
2. Verificar `.devcontainer/devcontainer.json`
3. Revisar logs de cliente MCP

### Herramienta retorna error

**Síntoma**: `tools/call` retorna error.

**Soluciones**:
```bash
# Ejecutar herramienta directamente
.devcontainer/mcp/tools/nombre-herramienta.sh '{"param":"value"}'

# Verificar argumentos JSON
echo '{"param":"value"}' | jq .

# Ver logs completos
./server.sh 2>&1
```

## Referencias

- [ADR 0003: Servidor MCP en Shell](../../diseno_solucion/arquitectura_sistemas/adr/0003-servidor-mcp-shell.md)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [JSON-RPC 2.0](https://www.jsonrpc.org/specification)
- [README técnico MCP](../../../.devcontainer/mcp/README.md)

## Historial de cambios

| Fecha | Versión | Cambio |
|-------|---------|--------|
| 2025-11-04 | 0.1.0 | Implementación inicial con 5 herramientas |
