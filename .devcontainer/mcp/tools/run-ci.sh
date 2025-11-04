#!/usr/bin/env bash
# Herramienta MCP: Ejecutar Pipeline CI
# Ejecuta el pipeline completo de integración continua del proyecto

set -euo pipefail

# Directorio de herramientas
TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_DIR="$(dirname "$TOOLS_DIR")"
PROJECT_ROOT="$(cd "$MCP_DIR/../.." && pwd)"

# Cargar funciones comunes
# shellcheck source=../lib/mcp-common.sh
source "$MCP_DIR/lib/mcp-common.sh"

# Parsear argumentos JSON
ARGS="${1:-"{}"}"
SKIP_TESTS=$(echo "$ARGS" | jq -r '.skip_tests // false')

mcp_log "Running CI pipeline (skip_tests: $SKIP_TESTS)"

# Cambiar al directorio del proyecto
cd "$PROJECT_ROOT"

# Crear archivo temporal para capturar salida
OUTPUT_FILE=$(mktemp)
trap 'rm -f "$OUTPUT_FILE"' EXIT

# Función para ejecutar comando y capturar resultado
run_step() {
    local step_name="$1"
    local command="$2"

    echo "## $step_name" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    if eval "$command" >> "$OUTPUT_FILE" 2>&1; then
        echo "✅ $step_name - PASSED" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        return 0
    else
        echo "❌ $step_name - FAILED" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        return 1
    fi
}

# Iniciar reporte
cat > "$OUTPUT_FILE" <<EOF
# 🚀 Pipeline CI - Resultado de Ejecución

**Proyecto**: TFG Server
**Fecha**: $(date '+%Y-%m-%d %H:%M:%S')
**Directorio**: $PROJECT_ROOT

---

EOF

# Variables para tracking
TOTAL_STEPS=0
PASSED_STEPS=0
FAILED_STEPS=0

# Paso 1: Verificar dependencias
TOTAL_STEPS=$((TOTAL_STEPS + 1))
echo "### Paso 1: Verificar Dependencias" >> "$OUTPUT_FILE"
if make check-deps >> "$OUTPUT_FILE" 2>&1; then
    echo "✅ Dependencias verificadas" >> "$OUTPUT_FILE"
    PASSED_STEPS=$((PASSED_STEPS + 1))
else
    echo "⚠️ Algunas dependencias faltan (continuando)" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# Paso 2: Lint Markdown
TOTAL_STEPS=$((TOTAL_STEPS + 1))
echo "### Paso 2: Lint Markdown" >> "$OUTPUT_FILE"
if run_step "Lint Markdown" "make lint-markdown"; then
    PASSED_STEPS=$((PASSED_STEPS + 1))
else
    FAILED_STEPS=$((FAILED_STEPS + 1))
fi

# Paso 3: Lint Shell
TOTAL_STEPS=$((TOTAL_STEPS + 1))
echo "### Paso 3: Lint Shell Scripts" >> "$OUTPUT_FILE"
if run_step "Lint Shell" "make lint-shell"; then
    PASSED_STEPS=$((PASSED_STEPS + 1))
else
    FAILED_STEPS=$((FAILED_STEPS + 1))
fi

# Paso 4: Tests (si no se omiten)
if [[ "$SKIP_TESTS" != "true" ]]; then
    TOTAL_STEPS=$((TOTAL_STEPS + 1))
    echo "### Paso 4: Tests BATS" >> "$OUTPUT_FILE"
    if run_step "Tests" "make test"; then
        PASSED_STEPS=$((PASSED_STEPS + 1))
    else
        FAILED_STEPS=$((FAILED_STEPS + 1))
    fi
else
    echo "### Paso 4: Tests BATS" >> "$OUTPUT_FILE"
    echo "⏭️ Tests omitidos (skip_tests=true)" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Paso 5: Build Docs
TOTAL_STEPS=$((TOTAL_STEPS + 1))
echo "### Paso 5: Build Documentation" >> "$OUTPUT_FILE"
if run_step "Build Docs" "make docs"; then
    PASSED_STEPS=$((PASSED_STEPS + 1))
else
    FAILED_STEPS=$((FAILED_STEPS + 1))
fi

# Resumen final
cat >> "$OUTPUT_FILE" <<EOF

---

## 📊 Resumen de Ejecución

| Métrica | Valor |
|---------|-------|
| Total de pasos | $TOTAL_STEPS |
| Pasos exitosos | $PASSED_STEPS |
| Pasos fallidos | $FAILED_STEPS |
| Tasa de éxito | $(awk "BEGIN {printf \"%.1f\", ($PASSED_STEPS/$TOTAL_STEPS)*100}")% |

EOF

# Determinar resultado general
if [[ $FAILED_STEPS -eq 0 ]]; then
    cat >> "$OUTPUT_FILE" <<EOF
## ✅ Pipeline CI - EXITOSO

Todos los pasos del pipeline se completaron correctamente.

### Próximos pasos:
1. Revisar la documentación generada en \`docs/_site/\`
2. Verificar que todos los cambios estén commitados
3. Considerar ejecutar \`make release\` si corresponde

EOF
    EXIT_CODE=0
else
    cat >> "$OUTPUT_FILE" <<EOF
## ❌ Pipeline CI - FALLÓ

El pipeline encontró $FAILED_STEPS error(es) que deben corregirse.

### Acciones recomendadas:
1. Revisar los errores detallados arriba
2. Corregir los problemas identificados
3. Re-ejecutar el pipeline: \`make ci\`
4. Consultar \`docs/TROUBLESHOOTING.md\` si necesitas ayuda

EOF
    EXIT_CODE=1
fi

# Agregar información de logs
cat >> "$OUTPUT_FILE" <<EOF
---

**Comando manual**: \`cd $PROJECT_ROOT && make ci\`
**Logs completos**: Revisa la salida en la terminal para más detalles

EOF

# Leer resultado y enviar
RESULT=$(cat "$OUTPUT_FILE")
mcp_tool_success "$RESULT"

exit $EXIT_CODE
