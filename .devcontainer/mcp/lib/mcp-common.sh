#!/usr/bin/env bash
# Funciones comunes para el servidor MCP en Shell
# Implementa utilidades JSON-RPC para comunicación con clientes MCP

# Enviar respuesta JSON-RPC exitosa
# Uso: echo "$result_json" | mcp_response "$id"
mcp_response() {
    local id="$1"
    local result
    result=$(cat)

    jq -nc \
        --arg id "$id" \
        --argjson result "$result" \
        '{
            jsonrpc: "2.0",
            id: $id,
            result: $result
        }'
}

# Enviar error JSON-RPC
# Uso: mcp_error_response "$id" "$error_message"
mcp_error_response() {
    local id="$1"
    local message="$2"

    jq -nc \
        --arg id "$id" \
        --arg msg "$message" \
        '{
            jsonrpc: "2.0",
            id: $id,
            error: {
                code: -32603,
                message: $msg
            }
        }'
}

# Log de debug (a stderr para no interferir con JSON-RPC en stdout)
mcp_log() {
    echo "[MCP $(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

# Crear respuesta de error para herramientas MCP
# Uso: mcp_tool_error "mensaje de error"
mcp_tool_error() {
    local message="$1"
    jq -nc \
        --arg msg "$message" \
        '{
            content: [{
                type: "text",
                text: $msg
            }],
            isError: true
        }'
}

# Crear respuesta exitosa para herramientas MCP
# Uso: mcp_tool_success "resultado"
mcp_tool_success() {
    local text="$1"
    jq -nc \
        --arg text "$text" \
        '{
            content: [{
                type: "text",
                text: $text
            }]
        }'
}

# Validar que jq está disponible
check_dependencies() {
    if ! command -v jq >/dev/null 2>&1; then
        echo "[ERROR] jq is required but not installed" >&2
        exit 1
    fi
}

# Obtener valor de un campo JSON
# Uso: get_json_field "$json" ".field.path"
get_json_field() {
    local json="$1"
    local field="$2"
    echo "$json" | jq -r "$field // empty"
}

# Exportar funciones
export -f mcp_response
export -f mcp_error_response
export -f mcp_log
export -f mcp_tool_error
export -f mcp_tool_success
export -f check_dependencies
export -f get_json_field
