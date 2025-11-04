#!/usr/bin/env bash
# Herramienta MCP: Listar Documentos de Gobernanza
# Lista todos los documentos de gobernanza disponibles

set -euo pipefail

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_DIR="$(dirname "$TOOLS_DIR")"
PROJECT_ROOT="$(cd "$MCP_DIR/../.." && pwd)"

# shellcheck source=../lib/mcp-common.sh
source "$MCP_DIR/lib/mcp-common.sh"

GOV_DIR="$PROJECT_ROOT/docs/gobernanza"

if [[ ! -d "$GOV_DIR" ]]; then
    mcp_tool_error "Directorio de gobernanza no encontrado: docs/gobernanza"
    exit 0
fi

mcp_log "Listing governance documents"

# Listar archivos
RESULT="# 📋 Documentos de Gobernanza\n\n"

# Contar documentos
TOTAL_DOCS=$(find "$GOV_DIR" -type f -name "*.md" | wc -l)
RESULT="$RESULT**Total de documentos**: $TOTAL_DOCS\n\n"

# Listar por categoría
RESULT="$RESULT## Documentos Disponibles\n\n"

while IFS= read -r file; do
    rel_path=${file#$PROJECT_ROOT/}
    filename=$(basename "$file")
    RESULT="$RESULT- \`$rel_path\`\n"
done < <(find "$GOV_DIR" -type f -name "*.md" | sort)

RESULT="$RESULT\n---\n**Directorio**: \`$GOV_DIR\`"

mcp_tool_success "$(echo -e "$RESULT")"
