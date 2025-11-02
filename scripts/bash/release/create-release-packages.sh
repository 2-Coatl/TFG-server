#!/usr/bin/env bash
################################################################################
# create-release-packages.sh - Empaquetado de artefactos de release
#
# PROPÓSITO:
#   Construir los paquetes distribuibles de la aplicación (wheel y sdist).
#
# USO:
#   ./scripts/bash/release/create-release-packages.sh
#
# VARIABLES DE ENTORNO:
#   RELEASE_DRY_RUN=1   Solo simula la construcción de paquetes
################################################################################

set -euo pipefail

if [[ -n "${RELEASE_DRY_RUN:-}" ]]; then
  echo "[create-release-packages] DRY RUN: construcción simulada de paquetes"
else
  echo "[create-release-packages] Construyendo paquetes de release (placeholder)"
fi
