# TFG MCP Server - Model Context Protocol

Servidor MCP (Model Context Protocol) implementado completamente en **Shell/Bash** para el proyecto TFG Server.

Este servidor expone herramientas de análisis y automatización del proyecto a través del protocolo MCP, permitiendo que asistentes de IA como Claude Code, Cursor, y otros clientes MCP interactúen inteligentemente con el repositorio.

## 🎯 Características

- **100% Shell** - Sin dependencias de Node.js o Python
- **5 Herramientas MCP** - Análisis de requisitos, CI, calidad de código, y más
- **JSON-RPC sobre stdio** - Protocolo estándar MCP
- **Integración automática** - Configurado en `.devcontainer/devcontainer.json`

## 📦 Herramientas Disponibles

### 1. `analyze_requirements`

Analiza documentos de requisitos y valida contra ISO 29148, BABOK v3, y PMBOK 7.

**Parámetros:**

- `file_path` (string, requerido): Ruta relativa al archivo en `docs/requisitos/`

**Ejemplo:**

```json
{
  "name": "analyze_requirements",
  "arguments": {
    "file_path": "registro_maestro.md"
  }
}
```

**Qué hace:**

- Cuenta requisitos por tipo (REQ-BN, REQ-FN, REQ-NF, etc.)
- Valida estructura según ISO 29148
- Detecta criterios de aceptación y trazabilidad
- Calcula puntuación de calidad (0-100)
- Proporciona recomendaciones específicas

### 2. `run_ci_pipeline`

Ejecuta el pipeline completo de integración continua del proyecto.

**Parámetros:**

- `skip_tests` (boolean, opcional): Si es `true`, omite la ejecución de tests

**Ejemplo:**

```json
{
  "name": "run_ci_pipeline",
  "arguments": {
    "skip_tests": false
  }
}
```

**Qué hace:**

- Verifica dependencias (`make check-deps`)
- Ejecuta lint de Markdown (`make lint-markdown`)
- Ejecuta lint de Shell (`make lint-shell`)
- Ejecuta tests BATS (`make test`)
- Genera documentación (`make docs`)
- Proporciona resumen detallado con métricas

### 3. `scan_shell_quality`

Analiza la calidad de scripts shell con shellcheck y métricas de complejidad.

**Parámetros:**

- `script_path` (string, requerido): Ruta relativa al script `.sh`

**Ejemplo:**

```json
{
  "name": "scan_shell_quality",
  "arguments": {
    "script_path": "scripts/bash/ci-local.sh"
  }
}
```

**Qué hace:**

- Cuenta líneas de código, comentarios, funciones
- Calcula complejidad ciclomática
- Verifica mejores prácticas (shebang, `set -euo pipefail`)
- Ejecuta shellcheck y reporta errores/warnings
- Detecta patrones problemáticos (`eval`, backticks)
- Calcula puntuación de calidad (0-100)

### 4. `list_governance_docs`

Lista todos los documentos de gobernanza disponibles en `docs/gobernanza/`.

**Parámetros:** Ninguno

**Ejemplo:**

```json
{
  "name": "list_governance_docs",
  "arguments": {}
}
```

### 5. `validate_project_structure`

Valida que la estructura del proyecto cumple con las convenciones documentadas.

**Parámetros:** Ninguno

**Ejemplo:**

```json
{
  "name": "validate_project_structure",
  "arguments": {}
}
```

**Qué hace:**

- Verifica existencia de directorios clave
- Verifica existencia de archivos principales
- Reporta elementos faltantes

## 🚀 Uso

### Automático (Recomendado)

Si usas **VSCode/Cursor/Claude Code**, el servidor MCP se configura automáticamente al abrir el proyecto en el devcontainer.

1. Abre el proyecto en devcontainer
2. El servidor MCP estará disponible automáticamente
3. Usa comandos de IA que llamen a las herramientas MCP

### Manual (Testing)

Para probar el servidor manualmente:

```bash
# Navegar al directorio MCP
cd .devcontainer/mcp

# Ejecutar servidor (modo interactivo)
./server.sh

# Enviar mensaje de inicialización
echo '{"jsonrpc":"2.0","id":"1","method":"initialize","params":{}}' | ./server.sh

# Listar herramientas
echo '{"jsonrpc":"2.0","id":"2","method":"tools/list","params":{}}' | ./server.sh

# Llamar herramienta
echo '{"jsonrpc":"2.0","id":"3","method":"tools/call","params":{"name":"validate_project_structure","arguments":{}}}' | ./server.sh
```

## 📁 Estructura

```
.devcontainer/mcp/
├── README.md                      # Esta documentación
├── server.sh                      # Servidor MCP principal (JSON-RPC)
├── lib/
│   └── mcp-common.sh             # Funciones comunes (JSON-RPC, logging)
└── tools/                         # Herramientas MCP
    ├── analyze-requirements.sh   # Analizar requisitos
    ├── run-ci.sh                 # Ejecutar pipeline CI
    ├── scan-shell.sh             # Analizar calidad Shell
    ├── list-governance.sh        # Listar docs de gobernanza
    └── validate-structure.sh     # Validar estructura proyecto
```

## 🔧 Dependencias

### Requeridas

- **Bash 4+** - Intérprete shell
- **jq** - Procesamiento JSON (ya instalado en el proyecto)

### Opcionales (mejoran funcionalidad)

- **shellcheck** - Para análisis detallado de scripts (herramienta `scan_shell_quality`)
- **bats** - Para ejecutar tests (herramienta `run_ci_pipeline`)
- **markdownlint-cli2** - Para lint de Markdown (herramienta `run_ci_pipeline`)

Verificar dependencias:

```bash
make check-deps
```

## 🛠️ Desarrollo

### Agregar una Nueva Herramienta

1. **Crear script en `tools/`:**

```bash
touch .devcontainer/mcp/tools/mi-herramienta.sh
chmod +x .devcontainer/mcp/tools/mi-herramienta.sh
```

2. **Implementar usando plantilla:**

```bash
#!/usr/bin/env bash
set -euo pipefail

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_DIR="$(dirname "$TOOLS_DIR")"
PROJECT_ROOT="$(cd "$MCP_DIR/../.." && pwd)"

# shellcheck source=../lib/mcp-common.sh
source "$MCP_DIR/lib/mcp-common.sh"

# Parsear argumentos
ARGS="${1:-{}}"
MI_PARAM=$(echo "$ARGS" | jq -r '.mi_param // empty')

# Tu lógica aquí
RESULT="Mi resultado"

# Retornar resultado
mcp_tool_success "$RESULT"
```

3. **Registrar en `server.sh`:**

Agregar a la función `list_tools()`:

```json
{
  "name": "mi_herramienta",
  "description": "Descripción de mi herramienta",
  "inputSchema": {
    "type": "object",
    "properties": {
      "mi_param": {
        "type": "string",
        "description": "Descripción del parámetro"
      }
    },
    "required": ["mi_param"]
  }
}
```

Agregar a la función `call_tool()`:

```bash
mi_herramienta)
    "$MCP_DIR/tools/mi-herramienta.sh" "$arguments"
    ;;
```

### Testing

Probar una herramienta directamente:

```bash
cd .devcontainer/mcp

# Probar herramienta con argumentos JSON
./tools/analyze-requirements.sh '{"file_path":"registro_maestro.md"}'

# Probar herramienta sin argumentos
./tools/validate-structure.sh '{}'
```

## 📚 Referencias

- [Model Context Protocol Specification](https://modelcontextprotocol.io/)
- [JSON-RPC 2.0 Specification](https://www.jsonrpc.org/specification)
- [TFG Server Documentation](../../docs/)

## 🤝 Integración con Claude Code

Este servidor MCP está diseñado específicamente para trabajar con asistentes de IA como Claude Code.

**Ejemplos de prompts:**

- "Analiza el archivo de requisitos registro_maestro.md"
- "Ejecuta el pipeline CI completo"
- "Analiza la calidad del script ci-local.sh"
- "Valida la estructura del proyecto"
- "Lista los documentos de gobernanza"

Claude Code automáticamente detectará y usará las herramientas MCP apropiadas para responder.

## 📝 Notas

- El servidor usa **stderr para logs** y **stdout para JSON-RPC** - no interferir con la salida
- Todos los resultados están en **formato Markdown** para mejor legibilidad
- Las herramientas son **idempotentes** - pueden ejecutarse múltiples veces sin efectos secundarios
- El servidor sigue **estándares POSIX** donde sea posible para máxima portabilidad

## 🐛 Troubleshooting

### El servidor no inicia

```bash
# Verificar que el script es ejecutable
chmod +x .devcontainer/mcp/server.sh

# Verificar que jq está instalado
command -v jq || echo "jq no encontrado"
```

### Herramienta retorna error

```bash
# Ejecutar herramienta directamente para ver error
.devcontainer/mcp/tools/nombre-herramienta.sh '{"param":"value"}'

# Ver logs en stderr
.devcontainer/mcp/server.sh 2>mcp-debug.log
```

### Cliente MCP no detecta servidor

Verificar `.devcontainer/devcontainer.json`:

```json
{
  "customizations": {
    "vscode": {
      "settings": {
        "mcp.servers": {
          "tfg-requirements": {
            "command": "bash",
            "args": ["${workspaceFolder}/.devcontainer/mcp/server.sh"]
          }
        }
      }
    }
  }
}
```

---

**Versión**: 0.1.0
**Protocolo MCP**: 2024-11-05
**Licencia**: Misma que TFG-server
