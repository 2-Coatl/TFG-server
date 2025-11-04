#!/usr/bin/env bash
# Script de validación MCP (sin BATS)
# Ejecuta validaciones básicas del servidor MCP

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MCP_DIR="$PROJECT_ROOT/.devcontainer/mcp"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

# Función de test
test_check() {
    local test_name="$1"
    local test_command="$2"

    if eval "$test_command" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $test_name"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}✗${NC} $test_name"
        FAILED=$((FAILED + 1))
    fi
}

echo "===================="
echo "Validación MCP"
echo "===================="
echo ""

echo "Tests de estructura:"
test_check "Directorio MCP existe" "[[ -d '$MCP_DIR' ]]"
test_check "Servidor MCP existe y es ejecutable" "[[ -x '$MCP_DIR/server.sh' ]]"
test_check "Librería común existe" "[[ -f '$MCP_DIR/lib/mcp-common.sh' ]]"
test_check "5 herramientas MCP existen" "[[ \$(ls -1 '$MCP_DIR/tools'/*.sh | wc -l) -eq 5 ]]"

echo ""
echo "Tests de protocolo JSON-RPC:"
test_check "Servidor responde a initialize" "echo '{\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"initialize\",\"params\":{}}' | timeout 3 '$MCP_DIR/server.sh' 2>/dev/null | jq -e '.result.protocolVersion' >/dev/null"
test_check "Servidor lista 5 herramientas" "[[ \$(echo '{\"jsonrpc\":\"2.0\",\"id\":\"2\",\"method\":\"tools/list\",\"params\":{}}' | timeout 3 '$MCP_DIR/server.sh' 2>/dev/null | jq -r '.result.tools | length') -eq 5 ]]"
test_check "Servidor responde a tools/call" "echo '{\"jsonrpc\":\"2.0\",\"id\":\"3\",\"method\":\"tools/call\",\"params\":{\"name\":\"validate_project_structure\",\"arguments\":{}}}' | timeout 5 '$MCP_DIR/server.sh' 2>/dev/null | jq -e '.result.content[0].text' >/dev/null"

echo ""
echo "Tests de herramientas:"
test_check "validate_project_structure funciona" "'$MCP_DIR/tools/validate-structure.sh' '{}' 2>/dev/null | jq -e '.content[0].text' >/dev/null"
test_check "analyze_requirements funciona" "'$MCP_DIR/tools/analyze-requirements.sh' '{\"file_path\":\"registro_maestro.md\"}' 2>/dev/null | jq -e '.content[0].text' >/dev/null"
test_check "scan_shell funciona" "'$MCP_DIR/tools/scan-shell.sh' '{\"script_path\":\"scripts/bash/common.sh\"}' 2>/dev/null | jq -e '.content[0].text' >/dev/null"
test_check "list_governance funciona" "'$MCP_DIR/tools/list-governance.sh' '{}' 2>/dev/null | jq -e '.content[0].text' >/dev/null"

echo ""
echo "Tests de documentación:"
test_check "ADR 0003 existe" "[[ -f '$PROJECT_ROOT/docs/diseno_solucion/arquitectura_sistemas/adr/0003-servidor-mcp-shell.md' ]]"
test_check "Docs de implementación existen" "[[ -f '$PROJECT_ROOT/docs/implementacion/infrastructure/mcp-server.md' ]]"
test_check "README menciona MCP" "grep -q 'Model Context Protocol' '$PROJECT_ROOT/README.md'"
test_check "toc.yml incluye MCP" "grep -q 'mcp-server.md' '$PROJECT_ROOT/docs/toc.yml'"

echo ""
echo "Tests de configuración:"
test_check "devcontainer.json configurado" "grep -q 'mcp.servers' '$PROJECT_ROOT/.devcontainer/devcontainer.json'"
test_check "jq está instalado" "command -v jq >/dev/null"

echo ""
echo "===================="
echo -e "${GREEN}Passed: $PASSED${NC}"
if [[ $FAILED -gt 0 ]]; then
    echo -e "${RED}Failed: $FAILED${NC}"
    echo ""
    echo "Ejecuta 'make test' para pruebas completas con BATS"
    exit 1
else
    echo -e "${GREEN}Failed: 0${NC}"
    echo ""
    echo "✅ Todas las validaciones MCP pasaron"
    echo "Para pruebas completas, ejecuta: make test"
    exit 0
fi
