#!/usr/bin/env bash
################################################################################
# release-local.sh - Orquestación de releases locales
#
# REEMPLAZA: Workflow release.yml de GitHub Actions
#
# PROPÓSITO:
#   Ejecutar de forma local el proceso completo de release, reutilizando los
#   mismos scripts que se usaban en CI.
#
# USO:
#   ./scripts/bash/release-local.sh
#
# VARIABLES DE ENTORNO:
#   SKIP_PUBLISH=1   No invocar create-github-release.sh (útil para pruebas)
#   RELEASE_DRY_RUN=1   Ejecuta cada paso en modo informativo (si el script lo soporta)
################################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RELEASE_DIR="$ROOT_DIR/scripts/bash/release"

log() {
  printf "[release-local] %s\n" "$*"
}

run_release_step() {
  local script_name="$1"
  local script_path="$RELEASE_DIR/$script_name"

  if [[ ! -x "$script_path" ]]; then
    log "ERROR: no se encontró el script ${script_name} en ${RELEASE_DIR}"
    exit 1
  fi

  log "Ejecutando ${script_name}"
  "${script_path}"
}

run_release_step "check-release-exists.sh"
run_release_step "get-next-version.sh"
run_release_step "update-version.sh"
run_release_step "generate-release-notes.sh"
run_release_step "create-release-packages.sh"

if [[ -z "${SKIP_PUBLISH:-}" ]]; then
  run_release_step "create-github-release.sh"
else
  log "Saltando publicación remota (SKIP_PUBLISH=1)"
fi

log "Proceso de release finalizado"
