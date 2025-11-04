#!/usr/bin/env bash
# Servidor MCP para TFG Requirements Engineering
# Implementa Model Context Protocol usando Shell puro y JSON-RPC sobre stdio

set -euo pipefail

# Directorio del servidor MCP
MCP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$MCP_DIR/../.." && pwd)"

# Cargar utilidades comunes
# shellcheck source=lib/mcp-common.sh
source "$MCP_DIR/lib/mcp-common.sh"

# Verificar dependencias
check_dependencies

# Información del servidor
SERVER_NAME="tfg-requirements-server"
SERVER_VERSION="0.1.0"
PROTOCOL_VERSION="2024-11-05"

# Listar todas las herramientas MCP disponibles
list_tools() {
    cat <<'EOF'
{
  "tools": [
    {
      "name": "analyze_requirements",
      "description": "Analiza documentos de requisitos en docs/requisitos/ y valida contra ISO 29148, BABOK y PMBOK",
      "inputSchema": {
        "type": "object",
        "properties": {
          "file_path": {
            "type": "string",
            "description": "Ruta relativa al archivo en docs/requisitos/ (ej: registro_maestro.md)"
          }
        },
        "required": ["file_path"]
      }
    },
    {
      "name": "run_ci_pipeline",
      "description": "Ejecuta el pipeline CI completo del proyecto (lint + test + docs)",
      "inputSchema": {
        "type": "object",
        "properties": {
          "skip_tests": {
            "type": "boolean",
            "description": "Si es true, omite la ejecución de tests"
          }
        }
      }
    },
    {
      "name": "scan_shell_quality",
      "description": "Analiza la calidad de scripts shell con shellcheck y métricas de complejidad",
      "inputSchema": {
        "type": "object",
        "properties": {
          "script_path": {
            "type": "string",
            "description": "Ruta relativa al script .sh a analizar (ej: scripts/bash/ci-local.sh)"
          }
        },
        "required": ["script_path"]
      }
    },
    {
      "name": "list_governance_docs",
      "description": "Lista todos los documentos de gobernanza disponibles en docs/gobernanza/",
      "inputSchema": {
        "type": "object",
        "properties": {}
      }
    },
    {
      "name": "validate_project_structure",
      "description": "Valida que la estructura del proyecto cumple con las convenciones documentadas",
      "inputSchema": {
        "type": "object",
        "properties": {}
      }
    }
  ]
}
EOF
}

# Ejecutar una herramienta MCP
call_tool() {
    local tool_name="$1"
    local arguments="$2"

    mcp_log "Calling tool: $tool_name"

    case "$tool_name" in
        analyze_requirements)
            "$MCP_DIR/tools/analyze-requirements.sh" "$arguments"
            ;;
        run_ci_pipeline)
            "$MCP_DIR/tools/run-ci.sh" "$arguments"
            ;;
        scan_shell_quality)
            "$MCP_DIR/tools/scan-shell.sh" "$arguments"
            ;;
        list_governance_docs)
            "$MCP_DIR/tools/list-governance.sh" "$arguments"
            ;;
        validate_project_structure)
            "$MCP_DIR/tools/validate-structure.sh" "$arguments"
            ;;
        *)
            mcp_tool_error "Unknown tool: $tool_name"
            ;;
    esac
}

# Procesar mensaje de inicialización
handle_initialize() {
    local id="$1"

    mcp_log "Initialize request received"

    jq -nc \
        --arg version "$PROTOCOL_VERSION" \
        --arg name "$SERVER_NAME" \
        --arg server_version "$SERVER_VERSION" \
        '{
            protocolVersion: $version,
            capabilities: {
                tools: {}
            },
            serverInfo: {
                name: $name,
                version: $server_version
            }
        }' | mcp_response "$id"
}

# Loop principal del servidor MCP
# Lee mensajes JSON-RPC de stdin y responde por stdout
main() {
    mcp_log "TFG MCP Server starting..."
    mcp_log "Server: $SERVER_NAME v$SERVER_VERSION"
    mcp_log "Protocol: $PROTOCOL_VERSION"
    mcp_log "Project root: $PROJECT_ROOT"

    # Leer mensajes JSON-RPC línea por línea desde stdin
    while IFS= read -r line; do
        # Ignorar líneas vacías
        [[ -z "$line" ]] && continue

        # Parsear mensaje JSON-RPC
        local method id
        method=$(echo "$line" | jq -r '.method // empty')
        id=$(echo "$line" | jq -r '.id // empty')

        mcp_log "Received method: $method (id: $id)"

        case "$method" in
            initialize)
                handle_initialize "$id"
                ;;

            tools/list)
                list_tools | mcp_response "$id"
                ;;

            tools/call)
                local tool_name arguments result
                tool_name=$(echo "$line" | jq -r '.params.name // empty')
                arguments=$(echo "$line" | jq -c '.params.arguments // {}')

                # Ejecutar herramienta y capturar resultado (solo stdout, logs van a stderr)
                if result=$(call_tool "$tool_name" "$arguments"); then
                    echo "$result" | mcp_response "$id"
                else
                    mcp_error_response "$id" "Tool execution failed: $tool_name"
                fi
                ;;

            notifications/initialized)
                mcp_log "Client initialized notification received"
                # No response needed for notifications
                ;;

            "")
                mcp_log "Received empty method, ignoring"
                ;;

            *)
                mcp_log "Unknown method: $method"
                if [[ -n "$id" ]]; then
                    mcp_error_response "$id" "Method not found: $method"
                fi
                ;;
        esac
    done

    mcp_log "TFG MCP Server shutting down"
}

# Ejecutar servidor
main "$@"
