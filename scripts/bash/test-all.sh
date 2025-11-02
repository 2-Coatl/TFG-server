#!/usr/bin/env bash
################################################################################
# test-all.sh - Suite de tests local
#
# REEMPLAZA: Workflows de pruebas en GitHub Actions
#
# PROPÓSITO:
#   Ejecutar la suite de tests de Python de forma local con las mismas
#   garantías que en CI.
#
# USO:
#   ./scripts/bash/test-all.sh [pytest args]
#
# OPCIONES (variables de entorno):
#   PYTEST_ARGS="-k smoke"   Argumentos adicionales para pytest
#
# REQUISITOS:
#   - Python 3.11+
#   - pytest
################################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

log() {
  printf "[test-all] %s\n" "$*"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "ERROR: no se encontró el comando '$1'. Instálalo antes de continuar."
    exit 1
  fi
}

run_pytest() {
  require_command pytest

  local args=("--maxfail=1" "--disable-warnings" "-q")

  if [[ -n "${PYTEST_ARGS:-}" ]]; then
    # shellcheck disable=SC2206
    args+=(${PYTEST_ARGS})
  fi

  log "Ejecutando pytest ${args[*]}"
  pytest "${args[@]}"
}

run_pytest

log "Tests completados"
