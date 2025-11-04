#!/usr/bin/env bats

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PROJECT_ROOT="$DIR/.."
    MCP_DIR="$PROJECT_ROOT/.devcontainer/mcp"
}

# ============================================================================
# Tests de estructura y permisos
# ============================================================================

@test "directorio MCP existe" {
    [[ -d "$MCP_DIR" ]]
}

@test "servidor MCP existe y es ejecutable" {
    [[ -f "$MCP_DIR/server.sh" ]]
    [[ -x "$MCP_DIR/server.sh" ]]
}

@test "librería común MCP existe" {
    [[ -f "$MCP_DIR/lib/mcp-common.sh" ]]
}

@test "directorio de herramientas MCP existe" {
    [[ -d "$MCP_DIR/tools" ]]
}

@test "herramienta analyze-requirements existe y es ejecutable" {
    [[ -f "$MCP_DIR/tools/analyze-requirements.sh" ]]
    [[ -x "$MCP_DIR/tools/analyze-requirements.sh" ]]
}

@test "herramienta run-ci existe y es ejecutable" {
    [[ -f "$MCP_DIR/tools/run-ci.sh" ]]
    [[ -x "$MCP_DIR/tools/run-ci.sh" ]]
}

@test "herramienta scan-shell existe y es ejecutable" {
    [[ -f "$MCP_DIR/tools/scan-shell.sh" ]]
    [[ -x "$MCP_DIR/tools/scan-shell.sh" ]]
}

@test "herramienta list-governance existe y es ejecutable" {
    [[ -f "$MCP_DIR/tools/list-governance.sh" ]]
    [[ -x "$MCP_DIR/tools/list-governance.sh" ]]
}

@test "herramienta validate-structure existe y es ejecutable" {
    [[ -f "$MCP_DIR/tools/validate-structure.sh" ]]
    [[ -x "$MCP_DIR/tools/validate-structure.sh" ]]
}

@test "documentación MCP README existe" {
    [[ -f "$MCP_DIR/README.md" ]]
}

# ============================================================================
# Tests del protocolo JSON-RPC
# ============================================================================

@test "servidor MCP responde a initialize" {
    run bash -c "echo '{\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"initialize\",\"params\":{}}' | timeout 3 $MCP_DIR/server.sh 2>/dev/null"
    assert_success
    assert_output --partial '"jsonrpc":"2.0"'
    assert_output --partial '"protocolVersion"'
    assert_output --partial '"capabilities"'
}

@test "servidor MCP responde a tools/list" {
    run bash -c "echo '{\"jsonrpc\":\"2.0\",\"id\":\"2\",\"method\":\"tools/list\",\"params\":{}}' | timeout 3 $MCP_DIR/server.sh 2>/dev/null"
    assert_success
    assert_output --partial '"tools"'
    assert_output --partial 'analyze_requirements'
    assert_output --partial 'run_ci_pipeline'
    assert_output --partial 'scan_shell_quality'
}

@test "servidor MCP lista exactamente 5 herramientas" {
    run bash -c "echo '{\"jsonrpc\":\"2.0\",\"id\":\"2\",\"method\":\"tools/list\",\"params\":{}}' | timeout 3 $MCP_DIR/server.sh 2>/dev/null | jq -r '.result.tools | length'"
    assert_success
    assert_output "5"
}

@test "servidor MCP retorna error para método desconocido" {
    run bash -c "echo '{\"jsonrpc\":\"2.0\",\"id\":\"99\",\"method\":\"unknown_method\",\"params\":{}}' | timeout 3 $MCP_DIR/server.sh 2>/dev/null"
    assert_success
    assert_output --partial '"error"'
}

# ============================================================================
# Tests de herramientas MCP - validate_project_structure
# ============================================================================

@test "validate_project_structure ejecuta correctamente vía JSON-RPC" {
    run bash -c "echo '{\"jsonrpc\":\"2.0\",\"id\":\"3\",\"method\":\"tools/call\",\"params\":{\"name\":\"validate_project_structure\",\"arguments\":{}}}' | timeout 5 $MCP_DIR/server.sh 2>/dev/null"
    assert_success
    assert_output --partial '"content"'
    assert_output --partial 'Validación de Estructura'
}

@test "validate_project_structure retorna JSON válido" {
    run bash -c "echo '{\"jsonrpc\":\"2.0\",\"id\":\"3\",\"method\":\"tools/call\",\"params\":{\"name\":\"validate_project_structure\",\"arguments\":{}}}' | timeout 5 $MCP_DIR/server.sh 2>/dev/null | jq '.result.content[0].text'"
    assert_success
}

@test "validate_project_structure encuentra directorios clave" {
    run bash -c "echo '{\"jsonrpc\":\"2.0\",\"id\":\"3\",\"method\":\"tools/call\",\"params\":{\"name\":\"validate_project_structure\",\"arguments\":{}}}' | timeout 5 $MCP_DIR/server.sh 2>/dev/null | jq -r '.result.content[0].text'"
    assert_success
    assert_output --partial 'docs/'
    assert_output --partial 'scripts/bash/'
}

# ============================================================================
# Tests de herramientas MCP - analyze_requirements
# ============================================================================

@test "analyze_requirements ejecuta correctamente con archivo válido" {
    run bash -c "echo '{\"jsonrpc\":\"2.0\",\"id\":\"4\",\"method\":\"tools/call\",\"params\":{\"name\":\"analyze_requirements\",\"arguments\":{\"file_path\":\"registro_maestro.md\"}}}' | timeout 5 $MCP_DIR/server.sh 2>/dev/null"
    assert_success
    assert_output --partial 'Análisis de Requisitos'
}

@test "analyze_requirements retorna error con archivo inexistente" {
    run bash -c "$MCP_DIR/tools/analyze-requirements.sh '{\"file_path\":\"archivo-que-no-existe.md\"}' 2>/dev/null"
    assert_success
    assert_output --partial 'Archivo no encontrado'
    assert_output --partial 'isError'
}

@test "analyze_requirements requiere parámetro file_path" {
    run bash -c "$MCP_DIR/tools/analyze-requirements.sh '{}' 2>/dev/null"
    assert_success
    assert_output --partial 'requerido'
    assert_output --partial 'isError'
}

@test "analyze_requirements genera métricas de calidad" {
    run bash -c "$MCP_DIR/tools/analyze-requirements.sh '{\"file_path\":\"registro_maestro.md\"}' 2>/dev/null | jq -r '.content[0].text'"
    assert_success
    assert_output --partial 'Puntuación de Calidad'
    assert_output --partial 'Estadísticas Generales'
}

# ============================================================================
# Tests de herramientas MCP - scan_shell_quality
# ============================================================================

@test "scan_shell_quality analiza scripts existentes" {
    run bash -c "$MCP_DIR/tools/scan-shell.sh '{\"script_path\":\"scripts/bash/ci-local.sh\"}' 2>/dev/null"
    assert_success
    assert_output --partial 'Análisis de Calidad'
    assert_output --partial 'Métricas de Código'
}

@test "scan_shell_quality requiere parámetro script_path" {
    run bash -c "$MCP_DIR/tools/scan-shell.sh '{}' 2>/dev/null"
    assert_success
    assert_output --partial 'requerido'
    assert_output --partial 'isError'
}

@test "scan_shell_quality retorna error con archivo inexistente" {
    run bash -c "$MCP_DIR/tools/scan-shell.sh '{\"script_path\":\"script-inexistente.sh\"}' 2>/dev/null"
    assert_success
    assert_output --partial 'no encontrado'
    assert_output --partial 'isError'
}

@test "scan_shell_quality calcula puntuación de calidad" {
    run bash -c "$MCP_DIR/tools/scan-shell.sh '{\"script_path\":\"scripts/bash/common.sh\"}' 2>/dev/null | jq -r '.content[0].text'"
    assert_success
    assert_output --partial 'Puntuación de Calidad'
    assert_output --partial '/100'
}

# ============================================================================
# Tests de herramientas MCP - list_governance_docs
# ============================================================================

@test "list_governance_docs lista documentos" {
    run bash -c "$MCP_DIR/tools/list-governance.sh '{}' 2>/dev/null"
    assert_success
    assert_output --partial 'Documentos de Gobernanza'
}

@test "list_governance_docs retorna JSON válido" {
    run bash -c "$MCP_DIR/tools/list-governance.sh '{}' 2>/dev/null | jq '.content[0].text'"
    assert_success
}

# ============================================================================
# Tests de librería común
# ============================================================================

@test "mcp-common.sh puede ser cargado sin errores" {
    run bash -c "source $MCP_DIR/lib/mcp-common.sh && echo 'ok'"
    assert_success
    assert_output 'ok'
}

@test "mcp-common.sh exporta funciones requeridas" {
    run bash -c "source $MCP_DIR/lib/mcp-common.sh && type mcp_tool_success"
    assert_success
    assert_output --partial 'function'
}

@test "mcp_tool_success genera JSON válido" {
    run bash -c "source $MCP_DIR/lib/mcp-common.sh && mcp_tool_success 'test message' | jq '.content[0].text'"
    assert_success
    assert_output '"test message"'
}

@test "mcp_tool_error genera JSON válido con isError" {
    run bash -c "source $MCP_DIR/lib/mcp-common.sh && mcp_tool_error 'error message' | jq '.isError'"
    assert_success
    assert_output 'true'
}

# ============================================================================
# Tests de dependencias
# ============================================================================

@test "jq está instalado" {
    run command -v jq
    assert_success
}

@test "jq puede procesar JSON" {
    run bash -c "echo '{\"test\":\"value\"}' | jq -r '.test'"
    assert_success
    assert_output 'value'
}

# ============================================================================
# Tests de integración con devcontainer
# ============================================================================

@test "devcontainer.json contiene configuración MCP" {
    run grep -q "mcp.servers" "$PROJECT_ROOT/.devcontainer/devcontainer.json"
    assert_success
}

@test "devcontainer.json referencia servidor MCP correcto" {
    run grep -q "server.sh" "$PROJECT_ROOT/.devcontainer/devcontainer.json"
    assert_success
}

# ============================================================================
# Tests de documentación
# ============================================================================

@test "documentación ADR 0003 existe" {
    [[ -f "$PROJECT_ROOT/docs/diseno_solucion/arquitectura_sistemas/adr/0003-servidor-mcp-shell.md" ]]
}

@test "documentación de implementación MCP existe" {
    [[ -f "$PROJECT_ROOT/docs/implementacion/infrastructure/mcp-server.md" ]]
}

@test "README menciona MCP" {
    run grep -q "Model Context Protocol" "$PROJECT_ROOT/README.md"
    assert_success
}

@test "toc.yml incluye ADR 0003" {
    run grep -q "0003-servidor-mcp-shell" "$PROJECT_ROOT/docs/toc.yml"
    assert_success
}

@test "toc.yml incluye documentación MCP infrastructure" {
    run grep -q "mcp-server.md" "$PROJECT_ROOT/docs/toc.yml"
    assert_success
}
