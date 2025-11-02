#!/usr/bin/env bash
################################################################################
# update-version.sh - Actualización de artefactos de versión
#
# PROPÓSITO:
#   Actualizar archivos como pyproject.toml y CHANGELOG.md con la nueva versión.
#
# USO:
#   ./scripts/bash/release/update-version.sh
#
# VARIABLES DE ENTORNO:
#   RELEASE_DRY_RUN=1   Reporta las acciones sin modificar archivos
################################################################################

set -euo pipefail

if [[ -n "${RELEASE_DRY_RUN:-}" ]]; then
  echo "[update-version] DRY RUN: se omite la actualización de archivos"
else
  echo "[update-version] Actualizando archivos de versión (placeholder)"
fi
