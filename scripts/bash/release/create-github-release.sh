#!/usr/bin/env bash
################################################################################
# create-github-release.sh - Publicación de release
#
# PROPÓSITO:
#   Publicar la release generada en el proveedor remoto. Puede sustituirse por
#   cualquier canal de distribución necesario.
#
# USO:
#   ./scripts/bash/release/create-github-release.sh
#
# VARIABLES DE ENTORNO:
#   RELEASE_DRY_RUN=1   Evita cualquier acción remota
################################################################################

set -euo pipefail

if [[ -n "${RELEASE_DRY_RUN:-}" ]]; then
  echo "[create-github-release] DRY RUN: se omite la publicación remota"
else
  echo "[create-github-release] Publicando release (placeholder, reemplazar según proveedor)"
fi
