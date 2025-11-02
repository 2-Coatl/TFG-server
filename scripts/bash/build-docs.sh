#!/usr/bin/env bash
################################################################################
# build-docs.sh - Generación de documentación estática
#
# REEMPLAZA: Workflow docs.yml de GitHub Actions
#
# PROPÓSITO:
#   Construir la documentación con DocFX y exponerla localmente si se desea.
#
# USO:
#   ./scripts/bash/build-docs.sh [--serve]
#
# OPCIONES:
#   --serve   Levanta un servidor HTTP simple en docs/_site (puerto 8080 por defecto)
#
# VARIABLES DE ENTORNO:
#   DOCFX_SERVE_PORT=9000   Puerto a utilizar con --serve (default 8080)
#
# REQUISITOS:
#   - docfx
#   - Python 3.11+ (solo para --serve)
################################################################################

set -euo pipefail

# Verificar versión de Bash
if [[ ${BASH_VERSINFO[0]:-0} -lt 4 ]]; then
  echo "[build-docs] ERROR: Requiere Bash 4 o superior." >&2
  exit 2
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOCS_DIR="$ROOT_DIR/docs"
SITE_DIR="$DOCS_DIR/_site"
SERVE=${1:-}

log() {
  printf "[build-docs] %s\n" "$*"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "ERROR: no se encontró el comando '$1'. Instálalo antes de continuar."
    exit 1
  fi
}

build_site() {
  require_command docfx

  log "Generando documentación con DocFX"
  docfx build "$DOCS_DIR/docfx.json"
}

serve_site() {
  local port="${DOCFX_SERVE_PORT:-8080}"

  if [[ ! -d "$SITE_DIR" ]]; then
    log "ERROR: la carpeta $SITE_DIR no existe. Ejecuta primero la generación."
    exit 1
  fi

  require_command python3

  log "Sirviendo documentación en http://localhost:${port}"
  (cd "$SITE_DIR" || { log "ERROR: No se pudo cambiar a $SITE_DIR"; exit 1; }; python3 -m http.server "$port")
}

build_site

if [[ "$SERVE" == "--serve" ]]; then
  serve_site
fi

log "Documentación generada"
