# Procedimiento de Generación de Documentación

## Objetivo

Generar y publicar la documentación técnica del proyecto en formato estático
utilizando DocFX, asegurando que toda la documentación esté actualizada y
accesible.

## Alcance

Este procedimiento cubre:

- Generación de documentación estática con DocFX
- Servir documentación localmente
- Validación de enlaces y estructura
- Publicación de documentación

## Responsables

- **Ejecutor**: Desarrollador/Tech Writer
- **Validador**: Tech Lead
- **Aprobador**: Project Manager

## Prerequisitos

### Dependencias

- DocFX (generador de documentación)
- Python 3.11+ (para servidor local)
- Make

### Verificación

```bash
# Verificar DocFX
docfx --version

# Verificar Python
python3 --version
```

### Instalación de DocFX

**Linux/macOS:**

```bash
# Descargar última versión
wget https://github.com/dotnet/docfx/releases/download/v2.70.0/docfx-linux-x64-v2.70.0.zip

# Extraer
unzip docfx-linux-x64-v2.70.0.zip -d ~/docfx

# Agregar al PATH
export PATH=$PATH:~/docfx
echo 'export PATH=$PATH:~/docfx' >> ~/.bashrc
```

**Windows:**

```powershell
choco install docfx
```

## Estructura de Documentación

```
docs/
├── docfx.json              # Configuración de DocFX
├── index.md                # Página principal
├── procedimientos/         # Procedimientos operativos
├── requisitos/             # Requisitos del sistema
├── diseno_solucion/        # Diseño y arquitectura
├── implementacion/         # Guías de implementación
├── automation/             # Documentación de automatización
└── _site/                  # Sitio generado (git-ignored)
```

## Procedimiento

### 1. Generación Básica

```bash
make docs
```

**Proceso:**

1. Lee configuración de `docs/docfx.json`
2. Procesa todos los archivos markdown
3. Genera sitio estático en `docs/_site/`
4. Valida enlaces internos

**Salida esperada:**

```
[docs] Generando documentación...
[build-docs] Generando documentación con DocFX
Build succeeded.
[build-docs] Documentación generada
[docs] Documentación generada en docs/_site
```

### 2. Generación y Servidor Local

```bash
make docs-serve
```

**O directamente:**

```bash
./scripts/bash/build-docs.sh --serve
```

**Resultado:**

- Genera documentación
- Inicia servidor HTTP en `http://localhost:8080`
- Documentación accesible en el navegador

**Salida:**

```
[build-docs] Generando documentación con DocFX
[build-docs] Sirviendo documentación en http://localhost:8080
Serving HTTP on 0.0.0.0 port 8080 (http://0.0.0.0:8080/) ...
```

### 3. Servidor en Puerto Personalizado

```bash
DOCFX_SERVE_PORT=9000 make docs-serve
```

**O:**

```bash
DOCFX_SERVE_PORT=9000 ./scripts/bash/build-docs.sh --serve
```

### 4. Solo Servidor (Sin Regenerar)

```bash
cd docs/_site
python3 -m http.server 8080
```

Útil cuando solo quieres revisar la documentación ya generada.

## Configuración de DocFX

### Archivo: docs/docfx.json

```json
{
  "metadata": [],
  "build": {
    "content": [
      {
        "files": ["**/*.md"],
        "exclude": ["_site/**", "node_modules/**"]
      }
    ],
    "resource": [
      {
        "files": ["images/**"]
      }
    ],
    "dest": "_site",
    "template": ["default"],
    "globalMetadata": {
      "_appTitle": "TFG Server Documentation",
      "_enableSearch": true
    }
  }
}
```

### Personalización

Para modificar configuración:

1. Editar `docs/docfx.json`
2. Regenerar: `make docs`
3. Validar cambios

## Estructura del Sitio Generado

```
docs/_site/
├── index.html                    # Página principal
├── procedimientos/
│   ├── procedimiento_linting.html
│   ├── procedimiento_ci_cd.html
│   └── ...
├── requisitos/
│   ├── casos_de_uso.html
│   └── ...
├── styles/                       # CSS generado
├── scripts/                      # JavaScript generado
└── manifest.json                 # Manifiesto del sitio
```

## Validación de Documentación

### Verificar Enlaces Rotos

DocFX valida automáticamente:

- ✓ Enlaces internos entre documentos
- ✓ Referencias a archivos
- ✓ Imágenes y recursos

**Errores comunes:**

```
[Warning] Invalid file link:(~/docs/archivo-inexistente.md)
```

**Solución:**

1. Corregir la ruta del enlace
2. Crear el archivo faltante
3. Regenerar documentación

### Verificar Sintaxis Markdown

```bash
make lint-markdown
```

Ejecutar antes de generar docs para asegurar sintaxis correcta.

## Integración con CI/CD

La documentación se genera automáticamente en el pipeline de CI:

```bash
make ci  # Incluye generación de docs
```

**Omitir en desarrollo:**

```bash
SKIP_DOCS=1 make ci
```

## Publicación de Documentación

### Opción 1: GitHub Pages (Recomendado)

```bash
# 1. Generar documentación
make docs

# 2. Configurar GitHub Pages
# En GitHub: Settings > Pages > Source: gh-pages branch

# 3. Publicar (si hay script de deploy)
./scripts/bash/deploy-docs.sh  # Si existe
```

### Opción 2: Servidor Web

```bash
# Copiar a servidor web
scp -r docs/_site/* user@server:/var/www/docs/
```

### Opción 3: Docker

```dockerfile
FROM nginx:alpine
COPY docs/_site /usr/share/nginx/html
EXPOSE 80
```

```bash
docker build -t tfg-docs .
docker run -p 8080:80 tfg-docs
```

## Actualización de Documentación

### Workflow Recomendado

```bash
# 1. Editar archivos markdown
vim docs/procedimientos/nuevo_procedimiento.md

# 2. Validar markdown
make lint-markdown

# 3. Regenerar docs
make docs

# 4. Revisar localmente
make docs-serve

# 5. Commit y push
git add docs/
git commit -m "docs: agregar nuevo procedimiento"
git push
```

### Frecuencia de Actualización

- **Diaria**: Durante desarrollo activo
- **Por PR**: Antes de merge a main
- **Por release**: Obligatorio en cada release

## Limpieza de Documentación

```bash
# Limpiar sitio generado
make clean

# O directamente
rm -rf docs/_site
```

Útil cuando:

- Cambios en configuración de DocFX
- Errores de generación persistentes
- Antes de regeneración completa

## Solución de Problemas

### Error: DocFX no encontrado

```
[build-docs] ERROR: no se encontró el comando 'docfx'
```

**Solución:**

```bash
# Verificar instalación
which docfx

# Reinstalar si necesario (ver sección Instalación)
```

### Error: Puerto en uso

```
OSError: [Errno 98] Address already in use
```

**Solución:**

```bash
# Usar puerto diferente
DOCFX_SERVE_PORT=9000 make docs-serve

# O matar proceso en puerto 8080
lsof -ti:8080 | xargs kill -9
```

### Documentación no se actualiza

```bash
# Limpiar y regenerar
make clean
make docs
```

### Enlaces rotos después de reorganización

```bash
# 1. Buscar referencias al archivo movido
grep -r "archivo-viejo.md" docs/

# 2. Actualizar todas las referencias
# 3. Regenerar y validar
make docs
```

## Mejores Prácticas

1. **Validar antes de generar:**
   ```bash
   make lint-markdown && make docs
   ```

2. **Revisar siempre localmente:**
   ```bash
   make docs-serve
   # Abrir http://localhost:8080 y navegar
   ```

3. **Mantener TOC actualizado:**
   - Agregar nuevos documentos a `index.md`
   - Mantener estructura lógica

4. **Usar enlaces relativos:**
   ```markdown
   # Incorrecto
   [Enlace](/docs/procedimientos/test.md)

   # Correcto
   [Enlace](../procedimientos/test.md)
   ```

5. **Incluir imágenes:**
   ```markdown
   ![Diagrama](../images/diagrama.png)
   ```

## Métricas de Calidad

### Criterios de Éxito

- ✅ 0 enlaces rotos
- ✅ Todos los procedimientos documentados
- ✅ TOC completo y organizado
- ✅ Imágenes y recursos accesibles

### Revisión

Antes de cada release:

```bash
# 1. Regenerar completamente
make clean
make docs

# 2. Revisar todos los enlaces
# 3. Verificar TOC
# 4. Validar navegación
```

## Herramientas Adicionales

### Visualización de Markdown

```bash
# VSCode con preview
code docs/procedimientos/nuevo.md

# Grip (GitHub markdown renderer)
grip docs/index.md
```

### Búsqueda en Documentación

```bash
# Buscar término en todos los docs
grep -r "término" docs/ --include="*.md"
```

## Referencias

- Configuración: `docs/docfx.json`
- Script: `scripts/bash/build-docs.sh`
- DocFX Docs: <https://dotnet.github.io/docfx/>
- Markdown Guide: <https://www.markdownguide.org/>

## Historial de Cambios

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-11-03 | 1.0 | Creación inicial del procedimiento |
