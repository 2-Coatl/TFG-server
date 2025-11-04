# ADR 0003: Implementación de Servidor MCP (Model Context Protocol) en Shell

**Estado**: ACEPTADO

**Fecha**: 2025-11-04

**Contexto relacionado**: Complementa [ADR 0002: Migración a Makefile](0002-migracion-makefile.md)

## Contexto

El proyecto TFG Server es una plataforma de ingeniería de requisitos que sigue estándares ISO/IEC/IEEE 29148, BABOK v3 y PMBOK 7. Para mejorar la interacción con asistentes de IA (Claude Code, Cursor, etc.) y permitir análisis inteligente del repositorio, se requiere implementar el **Model Context Protocol (MCP)**.

### Necesidad identificada

Los asistentes de IA actuales pueden leer archivos pero carecen de:

1. **Contexto especializado**: No entienden automáticamente la estructura normativa ISO/BABOK/PMBOK
2. **Herramientas específicas**: No pueden analizar requisitos contra estándares sin instrucciones repetitivas
3. **Integración CI**: No pueden ejecutar el pipeline CI de forma estructurada
4. **Validación de calidad**: No tienen métricas específicas para validar scripts Shell o documentación

### Alternativas consideradas

| Alternativa | Ventajas | Desventajas | Decisión |
|-------------|----------|-------------|----------|
| **1. Servidor MCP en Node.js** | SDK oficial, ejemplos abundantes | Rompe filosofía "100% Shell", requiere npm | ❌ Rechazado |
| **2. Servidor MCP en Python** | Buena integración, SDK disponible | Inconsistente con ADR 0002, dependencias | ❌ Rechazado |
| **3. Servidor MCP en Shell** | Consistente con proyecto, sin deps nuevas | Requiere implementar JSON-RPC manualmente | ✅ **Seleccionado** |
| **4. No implementar MCP** | Sin cambios | Pierde oportunidad de IA avanzada | ❌ Rechazado |

### Análisis de factibilidad Shell

MCP usa JSON-RPC sobre stdio, lo cual es completamente factible en Shell:

- ✅ **jq** ya está instalado (procesamiento JSON)
- ✅ **Bash 4+** soporta todas las estructuras necesarias
- ✅ **stdio** es nativo en Shell
- ✅ **Integración** con scripts existentes es trivial

## Decisión

Se implementa un **servidor MCP completo en Shell/Bash** ubicado en `.devcontainer/mcp/` que:

### Arquitectura

```
.devcontainer/mcp/
├── server.sh              # Servidor JSON-RPC principal
├── lib/
│   └── mcp-common.sh     # Funciones comunes (JSON-RPC, logging)
└── tools/                 # Herramientas MCP (scripts Shell)
    ├── analyze-requirements.sh
    ├── run-ci.sh
    ├── scan-shell.sh
    ├── list-governance.sh
    └── validate-structure.sh
```

### Herramientas MCP implementadas

1. **analyze_requirements**: Analiza documentos de requisitos
   - Valida contra ISO 29148, BABOK v3, PMBOK 7
   - Calcula puntuación de calidad (0-100)
   - Identifica requisitos por tipo (REQ-BN, REQ-FN, REQ-NF, etc.)
   - Detecta criterios de aceptación y trazabilidad

2. **run_ci_pipeline**: Ejecuta pipeline CI completo
   - Verifica dependencias
   - Ejecuta linters (Markdown + Shell)
   - Ejecuta tests BATS
   - Genera documentación
   - Proporciona resumen con métricas

3. **scan_shell_quality**: Analiza calidad de scripts Shell
   - Integra shellcheck
   - Calcula métricas de complejidad
   - Verifica mejores prácticas (shebang, set -euo pipefail)
   - Detecta patrones problemáticos (eval, backticks)

4. **list_governance_docs**: Lista documentos de gobernanza
   - Inventario de docs/gobernanza/
   - Categorización por tipo

5. **validate_project_structure**: Valida estructura del proyecto
   - Verifica directorios esperados
   - Verifica archivos clave
   - Reporta elementos faltantes

### Integración con devcontainer

El servidor se configura automáticamente en `.devcontainer/devcontainer.json`:

```json
{
  "customizations": {
    "vscode": {
      "settings": {
        "mcp.servers": {
          "tfg-requirements": {
            "command": "bash",
            "args": ["${workspaceFolder}/.devcontainer/mcp/server.sh"]
          }
        }
      }
    }
  }
}
```

## Consecuencias

### Positivas

✅ **Consistencia**: 100% Shell, alineado con ADR 0002 y filosofía del proyecto
✅ **Sin dependencias nuevas**: Solo requiere `jq` (ya instalado)
✅ **Portabilidad**: Funciona en cualquier sistema POSIX con Bash 4+
✅ **Integración natural**: Herramientas MCP llaman a scripts existentes
✅ **Bajo mantenimiento**: Código Shell simple y directo
✅ **Auto-configuración**: Se activa automáticamente en devcontainer
✅ **Extensibilidad**: Fácil agregar nuevas herramientas MCP

### Positivas (específicas del dominio)

✅ **Inteligencia ISO/BABOK/PMBOK**: IA ahora entiende estándares del proyecto
✅ **Análisis automatizado**: Validación de requisitos en segundos
✅ **Calidad mejorada**: Métricas objetivas para scripts y documentación
✅ **Productividad**: Asistentes de IA pueden ejecutar CI, analizar código, etc.

### Negativas

⚠️ **Implementación manual JSON-RPC**: No usa SDK oficial (pero es simple)
⚠️ **Menos ejemplos**: Pocos servidores MCP en Shell como referencia
⚠️ **Requiere jq**: Dependencia crítica (pero ya instalada)

### Neutrales

- Ubicación en `.devcontainer/` es estándar para herramientas de desarrollo
- El servidor solo se activa en devcontainer, no afecta producción
- Compatible con Claude Code, Cursor, VSCode y cualquier cliente MCP

## Notas de implementación

### Protocolo JSON-RPC

El servidor implementa MCP 2024-11-05 con los siguientes métodos:

- `initialize`: Handshake inicial con cliente
- `tools/list`: Lista herramientas disponibles
- `tools/call`: Ejecuta una herramienta específica
- `notifications/initialized`: Confirmación de inicialización

### Manejo de stdio

- **stdout**: Solo JSON-RPC (comunicación con cliente)
- **stderr**: Logs y debugging (no interfiere con protocolo)

### Formato de respuestas

Todas las herramientas retornan Markdown para mejor legibilidad:

```json
{
  "content": [{
    "type": "text",
    "text": "# Resultado en Markdown..."
  }]
}
```

### Testing

Pruebas realizadas:

```bash
# Inicialización
echo '{"jsonrpc":"2.0","id":"1","method":"initialize","params":{}}' | \
  .devcontainer/mcp/server.sh

# Listar herramientas
echo '{"jsonrpc":"2.0","id":"2","method":"tools/list","params":{}}' | \
  .devcontainer/mcp/server.sh

# Ejecutar análisis
echo '{"jsonrpc":"2.0","id":"3","method":"tools/call","params":{...}}' | \
  .devcontainer/mcp/server.sh
```

Todas las herramientas probadas y funcionando correctamente.

## Extensiones futuras

### Corto plazo (1-2 meses)

- Herramienta MCP para generar documentación desde plantillas
- Herramienta MCP para validar trazabilidad de requisitos
- Métricas más avanzadas en `analyze_requirements`

### Medio plazo (3-6 meses)

- Integración con matriz de trazabilidad
- Generador de casos de prueba desde requisitos
- Validador de compliance BABOK/PMBOK/ISO

### Largo plazo (6+ meses)

- MCP Resources para acceso read-only a requisitos
- MCP Prompts para plantillas de análisis
- Integración con herramientas externas (Jira, etc.)

## Referencias

- [Model Context Protocol Specification](https://modelcontextprotocol.io/)
- [JSON-RPC 2.0 Specification](https://www.jsonrpc.org/specification)
- [ADR 0002: Migración a Makefile](0002-migracion-makefile.md)
- [ISO/IEC/IEEE 29148:2018](https://www.iso.org/standard/72089.html)
- [BABOK v3](https://www.iiba.org/standards-and-resources/babok/)
- [PMBOK Guide 7](https://www.pmi.org/pmbok-guide-standards)

## Historial de revisiones

| Fecha | Autor | Cambio |
|-------|-------|--------|
| 2025-11-04 | Claude Code | Creación inicial del ADR |
