#!/usr/bin/env bash
################################################################################
# build-docs.sh - Generación de documentación estática
#
# REEMPLAZA: Workflow docs.yml de GitHub Actions
#
# PROPÓSITO:
#   Construir la documentación con MkDocs y exponerla localmente si se desea.
#
# USO:
#   ./scripts/bash/build-docs.sh [--serve]
#
# OPCIONES:
#   --serve   Levanta servidor MkDocs con live reload (puerto 8000 por defecto)
#
# VARIABLES DE ENTORNO:
#   MKDOCS_SERVE_PORT=9000   Puerto a utilizar con --serve (default 8000)
#
# REQUISITOS:
#   - mkdocs
#   - mkdocs-material
#   - mkdocs-git-revision-date-localized-plugin
################################################################################

set -euo pipefail

# Verificar versión de Bash
if [[ ${BASH_VERSINFO[0]:-0} -lt 4 ]]; then
  echo "[build-docs] ERROR: Requiere Bash 4 o superior." >&2
  exit 2
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
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
  require_command mkdocs

  log "Generando documentación con MkDocs"
  cd "$ROOT_DIR" || { log "ERROR: No se pudo cambiar a $ROOT_DIR"; exit 1; }
  mkdocs build --strict
}

serve_site() {
  local port="${MKDOCS_SERVE_PORT:-8000}"

  require_command mkdocs

  log "Sirviendo documentación en http://localhost:${port}"
  cd "$ROOT_DIR" || { log "ERROR: No se pudo cambiar a $ROOT_DIR"; exit 1; }
  mkdocs serve --dev-addr "localhost:${port}"
}

build_site

if [[ "$SERVE" == "--serve" ]]; then
  serve_site
fi

log "Documentación generada"
