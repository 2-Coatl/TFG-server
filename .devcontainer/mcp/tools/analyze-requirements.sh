#!/usr/bin/env bash
# Herramienta MCP: Analizar Requisitos
# Analiza documentos de requisitos y valida contra ISO 29148

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
FILE_PATH=$(echo "$ARGS" | jq -r '.file_path // empty')

# Validar que se proporcionó file_path
if [[ -z "$FILE_PATH" ]]; then
    mcp_tool_error "El parámetro 'file_path' es requerido"
    exit 0
fi

# Construir ruta completa
FULL_PATH="$PROJECT_ROOT/docs/requisitos/$FILE_PATH"

# Verificar que el archivo existe
if [[ ! -f "$FULL_PATH" ]]; then
    mcp_tool_error "Archivo no encontrado: docs/requisitos/$FILE_PATH"
    exit 0
fi

mcp_log "Analyzing requirements file: $FILE_PATH"

# Analizar contenido del archivo
TOTAL_LINES=$(wc -l < "$FULL_PATH")
TOTAL_CHARS=$(wc -c < "$FULL_PATH")

# Contar diferentes tipos de elementos
REQ_BUSINESS=$(grep -c "REQ-BN-" "$FULL_PATH" || true)
REQ_STAKEHOLDER=$(grep -c "REQ-SH-" "$FULL_PATH" || true)
REQ_FUNCTIONAL=$(grep -c "REQ-FN-" "$FULL_PATH" || true)
REQ_NON_FUNCTIONAL=$(grep -c "REQ-NF-" "$FULL_PATH" || true)
REQ_TRANSITION=$(grep -c "REQ-TR-" "$FULL_PATH" || true)
USE_CASES=$(grep -c "UC-" "$FULL_PATH" || true)

TOTAL_REQ=$((REQ_BUSINESS + REQ_STAKEHOLDER + REQ_FUNCTIONAL + REQ_NON_FUNCTIONAL + REQ_TRANSITION))

# Análisis de calidad
ACCEPTANCE_CRITERIA=$(grep -c "Criterios de aceptación" "$FULL_PATH" || true)
TRACEABILITY_REFS=$(grep -c "Trazabilidad" "$FULL_PATH" || true)
PRIORITY_TAGS=$(grep -c -E "(Alta|Media|Baja) prioridad" "$FULL_PATH" || true)

# Detectar secciones estándar ISO 29148
HAS_INTRODUCTION=$(grep -c -i "introducción\|introduction" "$FULL_PATH" || true)
HAS_SCOPE=$(grep -c -i "alcance\|scope" "$FULL_PATH" || true)
HAS_DEFINITIONS=$(grep -c -i "definiciones\|definitions" "$FULL_PATH" || true)

# Calcular puntuación de calidad (0-100)
QUALITY_SCORE=0
[[ $TOTAL_REQ -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 20))
[[ $ACCEPTANCE_CRITERIA -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 15))
[[ $TRACEABILITY_REFS -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 15))
[[ $PRIORITY_TAGS -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 10))
[[ $HAS_INTRODUCTION -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 10))
[[ $HAS_SCOPE -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 10))
[[ $HAS_DEFINITIONS -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 10))
[[ $USE_CASES -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 10))

# Determinar nivel de calidad
if [[ $QUALITY_SCORE -ge 80 ]]; then
    QUALITY_LEVEL="Excelente ✅"
elif [[ $QUALITY_SCORE -ge 60 ]]; then
    QUALITY_LEVEL="Bueno ✓"
elif [[ $QUALITY_SCORE -ge 40 ]]; then
    QUALITY_LEVEL="Aceptable ⚠"
else
    QUALITY_LEVEL="Necesita mejoras ⚠️"
fi

# Recomendaciones
RECOMMENDATIONS=""
[[ $ACCEPTANCE_CRITERIA -eq 0 ]] && RECOMMENDATIONS="$RECOMMENDATIONS\n- Agregar criterios de aceptación para los requisitos"
[[ $TRACEABILITY_REFS -eq 0 ]] && RECOMMENDATIONS="$RECOMMENDATIONS\n- Incluir referencias de trazabilidad"
[[ $PRIORITY_TAGS -eq 0 ]] && RECOMMENDATIONS="$RECOMMENDATIONS\n- Definir prioridades para los requisitos"
[[ $HAS_INTRODUCTION -eq 0 ]] && RECOMMENDATIONS="$RECOMMENDATIONS\n- Agregar sección de introducción (ISO 29148)"
[[ $HAS_SCOPE -eq 0 ]] && RECOMMENDATIONS="$RECOMMENDATIONS\n- Definir el alcance del documento (ISO 29148)"
[[ $USE_CASES -eq 0 ]] && RECOMMENDATIONS="$RECOMMENDATIONS\n- Considerar agregar casos de uso relacionados"

# Construir resultado en formato Markdown
RESULT=$(cat <<EOF
# 📊 Análisis de Requisitos: $FILE_PATH

## Estadísticas Generales
- **Total de líneas**: $TOTAL_LINES
- **Total de caracteres**: $TOTAL_CHARS
- **Total de requisitos**: $TOTAL_REQ

## Distribución de Requisitos por Tipo

| Tipo | Código | Cantidad |
|------|--------|----------|
| Requisitos de Negocio | REQ-BN-* | $REQ_BUSINESS |
| Requisitos de Stakeholders | REQ-SH-* | $REQ_STAKEHOLDER |
| Requisitos Funcionales | REQ-FN-* | $REQ_FUNCTIONAL |
| Requisitos No Funcionales | REQ-NF-* | $REQ_NON_FUNCTIONAL |
| Requisitos de Transición | REQ-TR-* | $REQ_TRANSITION |
| Casos de Uso | UC-* | $USE_CASES |

## Validación ISO 29148 / BABOK v3

| Criterio | Estado |
|----------|--------|
| Introducción | $([[ $HAS_INTRODUCTION -gt 0 ]] && echo "✅ Presente" || echo "❌ Ausente") |
| Alcance definido | $([[ $HAS_SCOPE -gt 0 ]] && echo "✅ Presente" || echo "❌ Ausente") |
| Definiciones | $([[ $HAS_DEFINITIONS -gt 0 ]] && echo "✅ Presente" || echo "❌ Ausente") |
| Criterios de aceptación | $([[ $ACCEPTANCE_CRITERIA -gt 0 ]] && echo "✅ $ACCEPTANCE_CRITERIA encontrados" || echo "❌ Ninguno") |
| Trazabilidad | $([[ $TRACEABILITY_REFS -gt 0 ]] && echo "✅ Referencias presentes" || echo "❌ Sin referencias") |
| Priorización | $([[ $PRIORITY_TAGS -gt 0 ]] && echo "✅ $PRIORITY_TAGS elementos priorizados" || echo "❌ Sin prioridades") |

## Puntuación de Calidad
**Puntuación**: $QUALITY_SCORE/100 - **Nivel**: $QUALITY_LEVEL

## Recomendaciones
$(if [[ -z "$RECOMMENDATIONS" ]]; then
    echo "✅ El documento cumple con las mejores prácticas"
else
    echo -e "$RECOMMENDATIONS"
fi)

## Próximos Pasos
1. Revisar y completar las recomendaciones indicadas
2. Actualizar matriz de trazabilidad en \`docs/requisitos/matriz_trazabilidad.md\`
3. Vincular con casos de uso en \`docs/requisitos/casos_de_uso.md\`
4. Validar con stakeholders según \`docs/gobernanza/\`

---
*Análisis generado por TFG MCP Server*
*Archivo analizado*: \`$FULL_PATH\`
EOF
)

# Enviar resultado
mcp_tool_success "$RESULT"
