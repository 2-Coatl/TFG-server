# ADR 0004: Migración de DocFX a MkDocs para Generación de Documentación

**Estado**: ACEPTADO

**Fecha**: 2025-11-04

**Contexto relacionado**: Complementa [ADR 0002: Migración a Makefile](0002-migracion-makefile.md)

## Contexto

El proyecto TFG Server utiliza DocFX para generar documentación estática a partir de archivos Markdown. Sin embargo, DocFX presenta limitaciones técnicas y de alineación con el ecosistema tecnológico del proyecto.

### Problemas identificados con DocFX

1. **Desalineación tecnológica**: DocFX requiere .NET runtime (~500MB) en un proyecto 100% Shell/Bash
2. **Complejidad de instalación**: Requiere instalación de .NET SDK que no es trivial en todos los entornos
3. **Ecosistema limitado**: DocFX está diseñado principalmente para proyectos .NET/C#, no para documentación técnica general
4. **Plugins escasos**: Menos opciones para extender funcionalidad (diagramas, admonitions, tabs)
5. **Barrera de entrada**: Contribuyentes deben instalar .NET solo para generar documentación
6. **Inconsistencia**: El proyecto ya usa Python (potencialmente), pero requiere .NET solo para docs

### Necesidades documentales actuales

El proyecto requiere:

- ✅ Renderizado de Markdown a HTML estático
- ✅ Tabla de contenidos jerárquica (navegación)
- ✅ Búsqueda integrada
- ✅ Soporte para BABOK/ISO/PMBOK (documentación estructurada)
- ✅ Live reload durante desarrollo (`--serve`)
- ✅ Generación local y en CI/CD
- ✅ Temas profesionales y personalizables
- ✅ Soporte para diagramas (Mermaid)

### Configuración actual de DocFX

```json
// docs/docfx.json (13 líneas)
{
  "build": {
    "content": [
      {
        "files": ["*.md", "**/*.md"]
      }
    ],
    "dest": "_site"
  }
}
```

**Análisis**: Configuración mínima, sin customizaciones profundas = migración de bajo riesgo.

### Alternativas consideradas

| Alternativa | Ventajas | Desventajas | Decisión |
|-------------|----------|-------------|----------|
| **1. Mantener DocFX** | Sin cambios, ya configurado | Requiere .NET, barrera de entrada alta | ❌ Rechazado |
| **2. MkDocs + Material** | Python (ligero), ecosistema rico, fácil instalación | Requiere migración de `toc.yml` a `mkdocs.yml` | ✅ **Seleccionado** |
| **3. Sphinx** | Estándar en Python, potente | Más complejo, orientado a APIs | ❌ Rechazado |
| **4. Docusaurus** | Moderno, React-based | Requiere Node.js, overkill para este proyecto | ❌ Rechazado |
| **5. Jekyll** | GitHub Pages nativo | Ruby, menos features que MkDocs | ❌ Rechazado |
| **6. Hugo** | Rápido, Go-based | Configuración compleja, menos plugins | ❌ Rechazado |

### Comparación técnica: DocFX vs MkDocs

| Aspecto | DocFX | MkDocs + Material |
|---------|-------|-------------------|
| **Runtime requerido** | .NET (~500MB) | Python (ya común) |
| **Instalación** | Compleja (SDK .NET) | `pip install mkdocs-material` |
| **Configuración** | JSON | YAML (más legible) |
| **Ecosistema proyecto** | ❌ No usa .NET | ✅ Puede usar Python |
| **Themes** | Limitados | Material Design (profesional) |
| **Búsqueda** | Básica | Avanzada (lunr.js) |
| **Live reload** | Limitado | `mkdocs serve` (excelente) |
| **Plugins disponibles** | ~10-20 | 100+ (Mermaid, tabs, admonitions, git-revision-date) |
| **Deployment** | Manual | `mkdocs gh-deploy` (automático) |
| **Curva de aprendizaje** | Media-Alta | Baja |
| **Community** | Pequeña (.NET-focused) | Grande (multi-lenguaje) |
| **Documentación** | Buena | Excelente |

### Análisis de impacto de migración

**Archivos afectados** (6 archivos):

1. `docs/docfx.json` → **ELIMINAR**
2. `docs/toc.yml` → **CONVERTIR** a `mkdocs.yml`
3. `scripts/bash/build-docs.sh` → **ACTUALIZAR** (docfx → mkdocs)
4. `Makefile` → **ACTUALIZAR** (check-deps)
5. `README.md` → **ACTUALIZAR** (menciones de DocFX)
6. `.devcontainer/CLAUDE_WORKFLOW.md` → **ACTUALIZAR** (referencias)

**Esfuerzo estimado**: 2-3 horas

**Riesgo**: BAJO (configuración mínima actual, sin customizaciones profundas)

## Decisión

Se migra la generación de documentación de **DocFX** a **MkDocs con Material Theme** por las siguientes razones:

### Razones técnicas

1. ✅ **Alineación tecnológica**: Elimina dependencia de .NET en proyecto Shell
2. ✅ **Simplicidad**: `pip install mkdocs-material` vs instalación de .NET SDK
3. ✅ **Ecosistema superior**: 100+ plugins vs ~20 de DocFX
4. ✅ **Mejor UX**: Material Design es más moderno y accesible
5. ✅ **Menor barrera**: Más contribuyentes tienen Python que .NET
6. ✅ **Deployment simplificado**: `mkdocs gh-deploy` es automático

### Razones de mantenibilidad

7. ✅ **Configuración declarativa**: YAML es más legible que JSON para configs grandes
8. ✅ **Hot reload superior**: Desarrollo de docs más fluido
9. ✅ **Comunidad activa**: Soporte y plugins en constante crecimiento
10. ✅ **Documentación excelente**: Material for MkDocs tiene docs de clase mundial

### Configuración MkDocs resultante

```yaml
# mkdocs.yml
site_name: TFG Server - Ingeniería de Requisitos
site_description: Herramienta monolítica para ingeniería de requisitos según ISO 29148, BABOK v3 y PMBOK 7
site_author: Equipo TFG
docs_dir: docs
site_dir: docs/_site

theme:
  name: material
  language: es
  features:
    - navigation.instant
    - navigation.tracking
    - navigation.tabs
    - navigation.sections
    - navigation.expand
    - navigation.top
    - search.suggest
    - search.highlight
    - content.code.copy
  palette:
    - scheme: default
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-7
        name: Cambiar a modo oscuro
    - scheme: slate
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-4
        name: Cambiar a modo claro

plugins:
  - search:
      lang: es
  - git-revision-date-localized:
      enable_creation_date: true

markdown_extensions:
  - admonition
  - pymdownx.details
  - pymdownx.superfences:
      custom_fences:
        - name: mermaid
          class: mermaid
          format: !!python/name:pymdownx.superfences.fence_code_format
  - pymdownx.tabbed:
      alternate_style: true
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.inlinehilite
  - pymdownx.snippets
  - tables
  - footnotes
  - attr_list
  - md_in_html

nav:
  - Introducción: index.md
  - Instalación: installation.md
  - Desarrollo Local: local-development.md
  # ... (resto de navegación convertida desde toc.yml)
```

### Script de generación actualizado

```bash
# scripts/bash/build-docs.sh
require_command mkdocs

build_site() {
  log "Generando documentación con MkDocs"
  mkdocs build --strict
}

serve_site() {
  log "Sirviendo documentación en http://localhost:${port}"
  mkdocs serve --dev-addr "localhost:${port}"
}
```

### Plugins MkDocs a utilizar

1. **mkdocs-material**: Theme principal
2. **mkdocs-git-revision-date-localized-plugin**: Fechas de modificación
3. **pymdown-extensions**: Admonitions, tabs, Mermaid, syntax highlighting

```bash
pip install mkdocs-material \
            mkdocs-git-revision-date-localized-plugin \
            pymdown-extensions
```

## Consecuencias

### Positivas

1. ✅ **Reducción de dependencias pesadas**: Elimina .NET runtime (~500MB)
2. ✅ **Instalación simplificada**: Una línea `pip install` vs proceso .NET SDK
3. ✅ **Mejor experiencia de desarrollo**: Live reload más rápido y estable
4. ✅ **Más features disponibles**: Diagramas Mermaid, tabs, admonitions nativas
5. ✅ **Deployment automático**: `mkdocs gh-deploy` para GitHub Pages
6. ✅ **Mejor búsqueda**: Integración superior de índice de búsqueda
7. ✅ **Temas modernos**: Material Design es estándar de facto
8. ✅ **Menor barrera de entrada**: Más contribuyentes tienen Python

### Negativas (mitigadas)

1. ⚠️ **Migración única**: Requiere convertir `toc.yml` → `mkdocs.yml` (1 hora)
   - **Mitigación**: Script de conversión semi-automático
2. ⚠️ **Aprendizaje nuevo**: Equipo debe aprender sintaxis MkDocs
   - **Mitigación**: Documentación excelente, curva de aprendizaje baja
3. ⚠️ **Cambio en CI/CD**: Actualizar scripts de generación
   - **Mitigación**: Cambios triviales (`docfx build` → `mkdocs build`)

### Neutras

- 🔄 **Salida equivalente**: Ambos generan HTML estático en `docs/_site`
- 🔄 **Estructura Markdown**: No requiere cambios en archivos `.md`

## Verificación de éxito

La migración se considera exitosa cuando:

1. ✅ `mkdocs build` genera docs/_site sin errores
2. ✅ `mkdocs serve` funciona con live reload
3. ✅ Navegación jerárquica se preserva correctamente
4. ✅ Búsqueda funciona en toda la documentación
5. ✅ `make docs` ejecuta MkDocs sin errores
6. ✅ `make ci` incluye generación MkDocs
7. ✅ Todos los links internos funcionan correctamente
8. ✅ ADRs, requisitos y procedimientos se renderizan correctamente

## Plan de migración

### Fase 1: Preparación (30 min)

- [x] Crear ADR 0004 documentando decisión
- [ ] Instalar MkDocs: `pip install mkdocs-material mkdocs-git-revision-date-localized-plugin`
- [ ] Crear `mkdocs.yml` convirtiendo desde `toc.yml`

### Fase 2: Conversión (1 hora)

- [ ] Convertir estructura de navegación `toc.yml` → `nav:` en `mkdocs.yml`
- [ ] Configurar theme Material con features deseadas
- [ ] Configurar plugins (search, git-revision-date)
- [ ] Configurar markdown_extensions (Mermaid, admonitions, tabs)

### Fase 3: Actualización de scripts (30 min)

- [ ] Actualizar `scripts/bash/build-docs.sh`
- [ ] Actualizar `Makefile` (check-deps: docfx → mkdocs)
- [ ] Actualizar `README.md` (referencias a DocFX)
- [ ] Actualizar `.devcontainer/CLAUDE_WORKFLOW.md`

### Fase 4: Validación (30 min)

- [ ] Ejecutar `mkdocs build --strict` (sin errores)
- [ ] Ejecutar `mkdocs serve` (verificar navegación)
- [ ] Validar todos los links internos
- [ ] Ejecutar `make docs` (verificar integración)
- [ ] Ejecutar `make ci` (verificar pipeline completo)

### Fase 5: Limpieza (15 min)

- [ ] Eliminar `docs/docfx.json`
- [ ] Actualizar `.gitignore` si es necesario
- [ ] Commit y push de cambios

## Referencias

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [PyMdown Extensions](https://facelessuser.github.io/pymdown-extensions/)
- [ADR 0002: Migración a Makefile](0002-migracion-makefile.md)
- [ADR 0003: Servidor MCP en Shell](0003-servidor-mcp-shell.md)

## Historial de cambios

| Fecha | Cambio | Responsable |
|-------|--------|-------------|
| 2025-11-04 | ADR creado y aceptado | Claude Code |

---

**Firmado**: Claude Code
**Revisado**: Pendiente
**Aprobado**: Pendiente
