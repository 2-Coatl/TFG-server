#!/usr/bin/env bash
# Herramienta MCP: Analizar Calidad de Scripts Shell
# Analiza scripts con shellcheck y métricas de complejidad

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
SCRIPT_PATH=$(echo "$ARGS" | jq -r '.script_path // empty')

# Validar que se proporcionó script_path
if [[ -z "$SCRIPT_PATH" ]]; then
    mcp_tool_error "El parámetro 'script_path' es requerido"
    exit 0
fi

# Construir ruta completa
FULL_PATH="$PROJECT_ROOT/$SCRIPT_PATH"

# Verificar que el archivo existe
if [[ ! -f "$FULL_PATH" ]]; then
    mcp_tool_error "Script no encontrado: $SCRIPT_PATH"
    exit 0
fi

# Verificar que es un script shell
if [[ ! "$SCRIPT_PATH" =~ \.sh$ ]] && [[ ! -x "$FULL_PATH" ]]; then
    mcp_tool_error "El archivo no parece ser un script shell: $SCRIPT_PATH"
    exit 0
fi

mcp_log "Analyzing shell script: $SCRIPT_PATH"

# Métricas básicas
TOTAL_LINES=$(wc -l < "$FULL_PATH")
CODE_LINES=$(grep -c -v "^\s*#" "$FULL_PATH" | grep -c -v "^\s*$" || echo "$TOTAL_LINES")
COMMENT_LINES=$(grep -c "^\s*#" "$FULL_PATH" || true)
BLANK_LINES=$(grep -c "^\s*$" "$FULL_PATH" || true)

# Análisis de complejidad
FUNCTION_COUNT=$(grep -c "^[a-zA-Z_][a-zA-Z0-9_]*\s*()" "$FULL_PATH" || true)
IF_STATEMENTS=$(grep -c -E "^\s*if\s+" "$FULL_PATH" || true)
LOOPS=$(grep -c -E "^\s*(for|while)\s+" "$FULL_PATH" || true)
CASE_STATEMENTS=$(grep -c -E "^\s*case\s+" "$FULL_PATH" || true)

# Análisis de mejores prácticas
HAS_SHEBANG=$(head -1 "$FULL_PATH" | grep -c "^#!/" || true)
HAS_SET_E=$(grep -c "set -e" "$FULL_PATH" || true)
HAS_SET_U=$(grep -c "set -u" "$FULL_PATH" || true)
HAS_SET_PIPEFAIL=$(grep -c "set.*pipefail" "$FULL_PATH" || true)
HAS_STRICT_MODE=$([[ $HAS_SET_E -gt 0 && $HAS_SET_U -gt 0 && $HAS_SET_PIPEFAIL -gt 0 ]] && echo 1 || echo 0)

# Patrones problemáticos
EVAL_USAGE=$(grep -c "\beval\b" "$FULL_PATH" || true)
UNQUOTED_VARS=$(grep -c "\$[A-Z_][A-Z0-9_]*\b" "$FULL_PATH" | grep -c -v '"\$' || true)
BACKTICKS=$(grep -c '`' "$FULL_PATH" || true)

# Ejecutar shellcheck si está disponible
SHELLCHECK_OUTPUT=""
SHELLCHECK_ERRORS=0
SHELLCHECK_WARNINGS=0
SHELLCHECK_AVAILABLE=0

if command -v shellcheck >/dev/null 2>&1; then
    SHELLCHECK_AVAILABLE=1
    SHELLCHECK_TEMP=$(mktemp)

    if shellcheck -f json "$FULL_PATH" > "$SHELLCHECK_TEMP" 2>&1; then
        SHELLCHECK_OUTPUT="✅ Sin problemas detectados por shellcheck"
    else
        # Contar errores y warnings
        SHELLCHECK_ERRORS=$(jq '[.[] | select(.level == "error")] | length' "$SHELLCHECK_TEMP" 2>/dev/null || echo 0)
        SHELLCHECK_WARNINGS=$(jq '[.[] | select(.level == "warning")] | length' "$SHELLCHECK_TEMP" 2>/dev/null || echo 0)

        # Obtener top 5 problemas
        TOP_ISSUES=$(jq -r '.[:5] | .[] | "- [\(.level)] Línea \(.line): \(.message) (SC\(.code))"' "$SHELLCHECK_TEMP" 2>/dev/null || echo "")

        if [[ -n "$TOP_ISSUES" ]]; then
            SHELLCHECK_OUTPUT=$(cat <<EOF
⚠️ Shellcheck encontró $SHELLCHECK_ERRORS errores y $SHELLCHECK_WARNINGS warnings

**Top 5 problemas:**
$TOP_ISSUES

Para ver todos los problemas, ejecuta: \`shellcheck $SCRIPT_PATH\`
EOF
)
        else
            SHELLCHECK_OUTPUT="✅ Sin problemas detectados por shellcheck"
        fi
    fi

    rm -f "$SHELLCHECK_TEMP"
else
    SHELLCHECK_OUTPUT="ℹ️ shellcheck no está instalado - instálalo para análisis más detallado"
fi

# Calcular puntuación de calidad (0-100)
QUALITY_SCORE=0

# Mejores prácticas (40 puntos)
[[ $HAS_SHEBANG -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 10))
[[ $HAS_STRICT_MODE -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 20))
[[ $COMMENT_LINES -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE + 10))

# Complejidad (20 puntos) - menos es mejor
if [[ $FUNCTION_COUNT -gt 0 ]]; then
    QUALITY_SCORE=$((QUALITY_SCORE + 10))  # Código modular
fi
if [[ $CODE_LINES -lt 200 ]]; then
    QUALITY_SCORE=$((QUALITY_SCORE + 10))  # Script no muy largo
fi

# Shellcheck (40 puntos)
if [[ $SHELLCHECK_AVAILABLE -eq 1 ]]; then
    if [[ $SHELLCHECK_ERRORS -eq 0 && $SHELLCHECK_WARNINGS -eq 0 ]]; then
        QUALITY_SCORE=$((QUALITY_SCORE + 40))
    elif [[ $SHELLCHECK_ERRORS -eq 0 ]]; then
        QUALITY_SCORE=$((QUALITY_SCORE + 30))
    elif [[ $SHELLCHECK_ERRORS -lt 5 ]]; then
        QUALITY_SCORE=$((QUALITY_SCORE + 20))
    else
        QUALITY_SCORE=$((QUALITY_SCORE + 10))
    fi
fi

# Penalizar prácticas problemáticas
[[ $EVAL_USAGE -gt 0 ]] && QUALITY_SCORE=$((QUALITY_SCORE - 10))
[[ $BACKTICKS -gt 3 ]] && QUALITY_SCORE=$((QUALITY_SCORE - 5))

# Asegurar que no sea negativo
[[ $QUALITY_SCORE -lt 0 ]] && QUALITY_SCORE=0

# Determinar nivel
if [[ $QUALITY_SCORE -ge 80 ]]; then
    QUALITY_LEVEL="Excelente ✅"
elif [[ $QUALITY_SCORE -ge 60 ]]; then
    QUALITY_LEVEL="Bueno ✓"
elif [[ $QUALITY_SCORE -ge 40 ]]; then
    QUALITY_LEVEL="Aceptable ⚠"
else
    QUALITY_LEVEL="Necesita mejoras ⚠️"
fi

# Construir resultado
RESULT=$(cat <<EOF
# 🔍 Análisis de Calidad: $SCRIPT_PATH

## Métricas de Código

| Métrica | Valor |
|---------|-------|
| Total de líneas | $TOTAL_LINES |
| Líneas de código | $CODE_LINES |
| Líneas de comentarios | $COMMENT_LINES |
| Líneas en blanco | $BLANK_LINES |
| Funciones definidas | $FUNCTION_COUNT |

## Complejidad

| Elemento | Cantidad |
|----------|----------|
| Declaraciones if | $IF_STATEMENTS |
| Bucles (for/while) | $LOOPS |
| Case statements | $CASE_STATEMENTS |
| Complejidad ciclomática estimada | $((IF_STATEMENTS + LOOPS + CASE_STATEMENTS + 1)) |

## Mejores Prácticas

| Práctica | Estado |
|----------|--------|
| Shebang presente | $([[ $HAS_SHEBANG -gt 0 ]] && echo "✅ Sí" || echo "❌ No") |
| \`set -e\` (exit on error) | $([[ $HAS_SET_E -gt 0 ]] && echo "✅ Sí" || echo "❌ No") |
| \`set -u\` (undefined vars) | $([[ $HAS_SET_U -gt 0 ]] && echo "✅ Sí" || echo "❌ No") |
| \`set -o pipefail\` | $([[ $HAS_SET_PIPEFAIL -gt 0 ]] && echo "✅ Sí" || echo "❌ No") |
| Modo estricto completo | $([[ $HAS_STRICT_MODE -gt 0 ]] && echo "✅ Sí" || echo "❌ No") |
| Tiene comentarios | $([[ $COMMENT_LINES -gt 0 ]] && echo "✅ Sí ($COMMENT_LINES)" || echo "❌ No") |

## Análisis Shellcheck

$SHELLCHECK_OUTPUT

## Patrones Problemáticos

| Patrón | Ocurrencias | Recomendación |
|--------|-------------|---------------|
| Uso de \`eval\` | $EVAL_USAGE | $([[ $EVAL_USAGE -gt 0 ]] && echo "⚠️ Evitar eval, usar alternativas más seguras" || echo "✅ No encontrado") |
| Backticks \`\` | $BACKTICKS | $([[ $BACKTICKS -gt 0 ]] && echo "ℹ️ Preferir \\\$() en lugar de backticks" || echo "✅ No encontrado") |

## Puntuación de Calidad

**Puntuación**: $QUALITY_SCORE/100 - **Nivel**: $QUALITY_LEVEL

## Recomendaciones

EOF
)

# Agregar recomendaciones específicas
if [[ $HAS_SHEBANG -eq 0 ]]; then
    RESULT="$RESULT"$'\n'"- Agregar shebang al inicio: \`#!/usr/bin/env bash\`"
fi

if [[ $HAS_STRICT_MODE -eq 0 ]]; then
    RESULT="$RESULT"$'\n'"- Habilitar modo estricto: \`set -euo pipefail\`"
fi

if [[ $COMMENT_LINES -eq 0 ]]; then
    RESULT="$RESULT"$'\n'"- Agregar comentarios para explicar la lógica del script"
fi

if [[ $FUNCTION_COUNT -eq 0 && $CODE_LINES -gt 50 ]]; then
    RESULT="$RESULT"$'\n'"- Considerar refactorizar en funciones para mejor modularidad"
fi

if [[ $SHELLCHECK_ERRORS -gt 0 ]]; then
    RESULT="$RESULT"$'\n'"- Corregir los $SHELLCHECK_ERRORS errores reportados por shellcheck"
fi

if [[ $EVAL_USAGE -gt 0 ]]; then
    RESULT="$RESULT"$'\n'"- Eliminar usos de \`eval\` por razones de seguridad"
fi

# Agregar footer
RESULT="$RESULT"$'\n\n'"---"$'\n'
RESULT="$RESULT"$'\n'"**Comando manual**: \`shellcheck $SCRIPT_PATH\`"
RESULT="$RESULT"$'\n'"**Archivo analizado**: \`$FULL_PATH\`"$'\n'

# Enviar resultado
mcp_tool_success "$RESULT"
