#!/usr/bin/env bash
# Herramienta MCP: Validar Estructura del Proyecto
# Valida que el proyecto cumple con las convenciones documentadas

set -euo pipefail

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_DIR="$(dirname "$TOOLS_DIR")"
PROJECT_ROOT="$(cd "$MCP_DIR/../.." && pwd)"

# shellcheck source=../lib/mcp-common.sh
source "$MCP_DIR/lib/mcp-common.sh"

mcp_log "Validating project structure"

cd "$PROJECT_ROOT"

# Directorios esperados
EXPECTED_DIRS=(
    "docs"
    "docs/requisitos"
    "docs/gobernanza"
    "docs/plantillas"
    "scripts/bash"
    "test"
)

# Archivos esperados
EXPECTED_FILES=(
    "README.md"
    "Makefile"
    ".devcontainer/devcontainer.json"
)

RESULT="# ✅ Validación de Estructura del Proyecto\n\n"
RESULT="$RESULT## Directorios\n\n"

MISSING_DIRS=0
for dir in "${EXPECTED_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        RESULT="$RESULT- ✅ \`$dir/\`\n"
    else
        RESULT="$RESULT- ❌ \`$dir/\` - **FALTANTE**\n"
        MISSING_DIRS=$((MISSING_DIRS + 1))
    fi
done

RESULT="$RESULT\n## Archivos Clave\n\n"

MISSING_FILES=0
for file in "${EXPECTED_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        RESULT="$RESULT- ✅ \`$file\`\n"
    else
        RESULT="$RESULT- ❌ \`$file\` - **FALTANTE**\n"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

RESULT="$RESULT\n## Resultado\n\n"

if [[ $MISSING_DIRS -eq 0 && $MISSING_FILES -eq 0 ]]; then
    RESULT="$RESULT✅ **La estructura del proyecto es válida**\n"
else
    RESULT="$RESULT⚠️ **Estructura incompleta**: $MISSING_DIRS directorios y $MISSING_FILES archivos faltantes\n"
fi

mcp_tool_success "$(echo -e "$RESULT")"
