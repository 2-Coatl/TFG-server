#!/usr/bin/env bash
################################################################################
# lint-local.sh - Local linting pipeline
#
# REEMPLAZA: Validaciones de linting en GitHub Actions
#
# PROPÓSITO:
#   Ejecuta todos los linters relevantes para el proyecto de forma local.
#
# USO:
#   ./scripts/bash/lint-local.sh
#
# OPCIONES (variables de entorno):
#   SKIP_MARKDOWN=1   Omitir validación de Markdown
#   SKIP_PYTHON=1     Omitir linting de código Python
#   SKIP_SHELL=1      Omitir análisis de scripts shell
#
# REQUISITOS:
#   - markdownlint-cli2 (Markdown)
#   - ruff (Python)
#   - shellcheck (Shell)
################################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

log() {
  printf "[lint-local] %s\n" "$*"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "ERROR: no se encontró el comando '$1'. Instálalo antes de continuar."
    exit 1
  fi
}

run_markdown_lint() {
  if [[ -n "${SKIP_MARKDOWN:-}" ]]; then
    log "Saltando linting de Markdown (SKIP_MARKDOWN=1)"
    return
  fi

  require_command markdownlint-cli2

  log "Ejecutando markdownlint-cli2"
  markdownlint-cli2 \
    "**/*.md" \
    "#docs/_site/**" \
    "#media/**" \
    "#memory/**" \
    "#templates/**" \
    "#venv/**" \
    "#.venv/**" \
    "#node_modules/**"
}

run_python_lint() {
  if [[ -n "${SKIP_PYTHON:-}" ]]; then
    log "Saltando linting de Python (SKIP_PYTHON=1)"
    return
  fi

  require_command ruff

  log "Ejecutando ruff"
  ruff check src tests
}

run_shell_lint() {
  if [[ -n "${SKIP_SHELL:-}" ]]; then
    log "Saltando análisis de shell (SKIP_SHELL=1)"
    return
  fi

  require_command shellcheck

  log "Ejecutando shellcheck"
  find scripts -name "*.sh" -print0 | xargs -0 -r shellcheck
}

run_markdown_lint
run_python_lint
run_shell_lint

log "Linting completado"
