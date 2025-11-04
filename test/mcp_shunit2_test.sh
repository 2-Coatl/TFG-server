#!/usr/bin/env bash
# Test suite para servidor MCP usando shUnit2
#
# Ejecutar con: ./test/mcp_shunit2_test.sh
# o con: make test-shunit2

# Directorio del proyecto
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MCP_DIR="$PROJECT_ROOT/.devcontainer/mcp"

# =============================================================================
# Setup y Teardown
# =============================================================================

oneTimeSetUp() {
    # Verificar que jq está disponible
    if ! command -v jq >/dev/null 2>&1; then
        fail "jq is required but not installed"
    fi
}

setUp() {
    # No se requiere setup específico por test
    :
}

tearDown() {
    # No se requiere teardown específico por test
    :
}

# =============================================================================
# Tests de Estructura
# =============================================================================

testMcpDirectoryExists() {
    assertTrue "MCP directory should exist" "[ -d '$MCP_DIR' ]"
}

testServerScriptExists() {
    assertTrue "Server script should exist" "[ -f '$MCP_DIR/server.sh' ]"
}

testServerScriptIsExecutable() {
    assertTrue "Server script should be executable" "[ -x '$MCP_DIR/server.sh' ]"
}

testCommonLibraryExists() {
    assertTrue "Common library should exist" "[ -f '$MCP_DIR/lib/mcp-common.sh' ]"
}

testToolsDirectoryExists() {
    assertTrue "Tools directory should exist" "[ -d '$MCP_DIR/tools' ]"
}

testAnalyzeRequirementsToolExists() {
    assertTrue "analyze-requirements tool should exist" \
        "[ -x '$MCP_DIR/tools/analyze-requirements.sh' ]"
}

testRunCiToolExists() {
    assertTrue "run-ci tool should exist" \
        "[ -x '$MCP_DIR/tools/run-ci.sh' ]"
}

testScanShellToolExists() {
    assertTrue "scan-shell tool should exist" \
        "[ -x '$MCP_DIR/tools/scan-shell.sh' ]"
}

testListGovernanceToolExists() {
    assertTrue "list-governance tool should exist" \
        "[ -x '$MCP_DIR/tools/list-governance.sh' ]"
}

testValidateStructureToolExists() {
    assertTrue "validate-structure tool should exist" \
        "[ -x '$MCP_DIR/tools/validate-structure.sh' ]"
}

# =============================================================================
# Tests de Protocolo JSON-RPC
# =============================================================================

testServerRespondsToInitialize() {
    local response
    response=$(echo '{"jsonrpc":"2.0","id":"1","method":"initialize","params":{}}' | \
        timeout 3 "$MCP_DIR/server.sh" 2>/dev/null)

    assertNotNull "Response should not be null" "$response"
    assertContains "$response" '"jsonrpc":"2.0"'
    assertContains "$response" '"protocolVersion"'
}

testServerRespondsToToolsList() {
    local response
    response=$(echo '{"jsonrpc":"2.0","id":"2","method":"tools/list","params":{}}' | \
        timeout 3 "$MCP_DIR/server.sh" 2>/dev/null)

    assertNotNull "Response should not be null" "$response"
    assertContains "$response" '"tools"'
    assertContains "$response" 'analyze_requirements'
}

testServerListsExactly5Tools() {
    local response tool_count
    response=$(echo '{"jsonrpc":"2.0","id":"2","method":"tools/list","params":{}}' | \
        timeout 3 "$MCP_DIR/server.sh" 2>/dev/null)

    tool_count=$(echo "$response" | jq -r '.result.tools | length')
    assertEquals "Should list exactly 5 tools" "5" "$tool_count"
}

testServerReturnsErrorForUnknownMethod() {
    local response
    response=$(echo '{"jsonrpc":"2.0","id":"99","method":"unknown_method","params":{}}' | \
        timeout 3 "$MCP_DIR/server.sh" 2>/dev/null)

    assertContains "$response" '"error"'
}

# =============================================================================
# Tests de Herramientas MCP
# =============================================================================

testValidateProjectStructureViaJsonRpc() {
    local response
    response=$(echo '{"jsonrpc":"2.0","id":"3","method":"tools/call","params":{"name":"validate_project_structure","arguments":{}}}' | \
        timeout 5 "$MCP_DIR/server.sh" 2>/dev/null)

    assertContains "$response" '"content"'
    assertContains "$response" 'Validación de Estructura'
}

testValidateProjectStructureReturnsValidJson() {
    local response result
    response=$(echo '{"jsonrpc":"2.0","id":"3","method":"tools/call","params":{"name":"validate_project_structure","arguments":{}}}' | \
        timeout 5 "$MCP_DIR/server.sh" 2>/dev/null)

    # Verificar que podemos extraer el texto con jq
    result=$(echo "$response" | jq -r '.result.content[0].text')
    assertNotNull "Result text should not be null" "$result"
}

testAnalyzeRequirementsWithValidFile() {
    local response
    response=$(echo '{"jsonrpc":"2.0","id":"4","method":"tools/call","params":{"name":"analyze_requirements","arguments":{"file_path":"registro_maestro.md"}}}' | \
        timeout 5 "$MCP_DIR/server.sh" 2>/dev/null)

    assertContains "$response" 'Análisis de Requisitos'
}

testAnalyzeRequirementsWithMissingFile() {
    local response
    response=$("$MCP_DIR/tools/analyze-requirements.sh" '{"file_path":"archivo-inexistente.md"}' 2>/dev/null)

    assertContains "$response" 'Archivo no encontrado'
    assertContains "$response" 'isError'
}

testAnalyzeRequirementsRequiresFilePath() {
    local response
    response=$("$MCP_DIR/tools/analyze-requirements.sh" '{}' 2>/dev/null)

    assertContains "$response" 'requerido'
    assertContains "$response" 'isError'
}

testScanShellWithExistingScript() {
    local response
    response=$("$MCP_DIR/tools/scan-shell.sh" '{"script_path":"scripts/bash/common.sh"}' 2>/dev/null)

    assertContains "$response" 'Análisis de Calidad'
    assertContains "$response" 'Métricas de Código'
}

testScanShellRequiresScriptPath() {
    local response
    response=$("$MCP_DIR/tools/scan-shell.sh" '{}' 2>/dev/null)

    assertContains "$response" 'requerido'
    assertContains "$response" 'isError'
}

testListGovernanceReturnsDocuments() {
    local response
    response=$("$MCP_DIR/tools/list-governance.sh" '{}' 2>/dev/null)

    assertContains "$response" 'Documentos de Gobernanza'
}

# =============================================================================
# Tests de Librería Común
# =============================================================================

testCommonLibraryCanBeLoaded() {
    # shellcheck disable=SC1091
    ( source "$MCP_DIR/lib/mcp-common.sh" && echo "ok" ) >/dev/null 2>&1
    assertTrue "Common library should load without errors" $?
}

testMcpToolSuccessGeneratesValidJson() {
    # shellcheck disable=SC1091
    source "$MCP_DIR/lib/mcp-common.sh"
    local result
    result=$(mcp_tool_success 'test message' | jq -r '.content[0].text')
    assertEquals "Should return test message" "test message" "$result"
}

testMcpToolErrorGeneratesJsonWithIsError() {
    # shellcheck disable=SC1091
    source "$MCP_DIR/lib/mcp-common.sh"
    local result
    result=$(mcp_tool_error 'error message' | jq -r '.isError')
    assertEquals "Should have isError=true" "true" "$result"
}

# =============================================================================
# Tests de Integración
# =============================================================================

testDevcontainerConfigContainsMcpConfig() {
    local devcontainer_file="$PROJECT_ROOT/.devcontainer/devcontainer.json"
    assertTrue "devcontainer.json should exist" "[ -f '$devcontainer_file' ]"

    grep -q "mcp.servers" "$devcontainer_file"
    assertTrue "devcontainer.json should contain mcp.servers config" $?
}

testDevcontainerConfigReferencesServerScript() {
    local devcontainer_file="$PROJECT_ROOT/.devcontainer/devcontainer.json"

    grep -q "server.sh" "$devcontainer_file"
    assertTrue "devcontainer.json should reference server.sh" $?
}

# =============================================================================
# Tests de Documentación
# =============================================================================

testAdr003Exists() {
    local adr_file="$PROJECT_ROOT/docs/diseno_solucion/arquitectura_sistemas/adr/0003-servidor-mcp-shell.md"
    assertTrue "ADR 0003 should exist" "[ -f '$adr_file' ]"
}

testImplementationDocsExist() {
    local docs_file="$PROJECT_ROOT/docs/implementacion/infrastructure/mcp-server.md"
    assertTrue "Implementation docs should exist" "[ -f '$docs_file' ]"
}

testReadmeMentionsMcp() {
    local readme_file="$PROJECT_ROOT/README.md"

    grep -q "Model Context Protocol" "$readme_file"
    assertTrue "README should mention MCP" $?
}

testTocIncludesMcpDocs() {
    local toc_file="$PROJECT_ROOT/docs/toc.yml"

    grep -q "mcp-server.md" "$toc_file"
    assertTrue "toc.yml should include MCP docs" $?
}

# =============================================================================
# Cargar shUnit2
# =============================================================================

# Cargar shUnit2 framework
# shellcheck disable=SC1091
. "$PROJECT_ROOT/test/lib/shunit2"
