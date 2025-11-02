#!/usr/bin/env bash
################################################################################
# test-all.sh - Suite de tests local
#
# REEMPLAZA: Workflows de pruebas en GitHub Actions
#
# PROPÓSITO:
#   Ejecutar la suite de tests con BATS de forma local con las mismas
#   garantías que en CI.
#
# USO:
#   ./scripts/bash/test-all.sh [bats args]
#
# OPCIONES (variables de entorno):
#   BATS_ARGS="--filter smoke"   Argumentos adicionales para bats
#
# REQUISITOS:
#   - Bash 4.0+
#   - bats-core
################################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR" || exit 1

log() {
  printf "[test-all] %s\n" "$*"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "ERROR: no se encontró el comando '$1'. Instálalo antes de continuar."
    exit 1
  fi
}

run_bats() {
  require_command bats

  local args=()

  if [[ -n "${BATS_ARGS:-}" ]]; then
    # Expandir BATS_ARGS correctamente sin word splitting
    IFS=' ' read -ra bats_array <<< "${BATS_ARGS}"
    args+=("${bats_array[@]}")
  fi

  log "Ejecutando bats ${args[*]}"
  bats "${args[@]}" test/test.bats
}

run_bats

log "Tests completados"
