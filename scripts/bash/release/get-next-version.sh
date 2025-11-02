#!/usr/bin/env bash
################################################################################
# get-next-version.sh - Cálculo de la siguiente versión semántica
#
# PROPÓSITO:
#   Determinar la siguiente versión a publicar en base a los commits existentes.
#
# USO:
#   ./scripts/bash/release/get-next-version.sh
#
# VARIABLES DE ENTORNO:
#   RELEASE_DRY_RUN=1   Solo muestra el cálculo simulado sin modificar archivos
################################################################################

set -euo pipefail

if [[ -n "${RELEASE_DRY_RUN:-}" ]]; then
  echo "[get-next-version] DRY RUN: cálculo simulado de versión"
else
  echo "[get-next-version] Calculando próxima versión (placeholder)"
fi
