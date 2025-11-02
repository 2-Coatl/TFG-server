#!/usr/bin/env bash
################################################################################
# ci-local.sh - Pipeline de CI/CD local
#
# REEMPLAZA: Workflows lint.yml, docs.yml y test.yml de GitHub Actions
#
# PROPÓSITO:
#   Ejecuta de punta a punta las validaciones del proyecto antes de subir cambios.
#
# USO:
#   ./scripts/bash/ci-local.sh
#
# VARIABLES DE ENTORNO:
#   SKIP_LINT=1   Omitir linting
#   SKIP_TESTS=1  Omitir tests
#   SKIP_DOCS=1   Omitir generación de documentación
################################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

log() {
  printf "[ci-local] %s\n" "$*"
}

run_step() {
  local description="$1"
  shift
  log "Iniciando: ${description}"
  "$@"
  log "Completado: ${description}"
}

if [[ -z "${SKIP_LINT:-}" ]]; then
  run_step "Linting" "$ROOT_DIR/scripts/bash/lint-local.sh"
else
  log "Saltando linting (SKIP_LINT=1)"
fi

if [[ -z "${SKIP_TESTS:-}" ]]; then
  run_step "Tests" "$ROOT_DIR/scripts/bash/test-all.sh"
else
  log "Saltando tests (SKIP_TESTS=1)"
fi

if [[ -z "${SKIP_DOCS:-}" ]]; then
  run_step "Documentación" "$ROOT_DIR/scripts/bash/build-docs.sh"
else
  log "Saltando documentación (SKIP_DOCS=1)"
fi

log "CI local completado satisfactoriamente"
