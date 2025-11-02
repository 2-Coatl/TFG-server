#!/usr/bin/env bash
set -euo pipefail

VERSION="${PROJECT_VERSION:-1.0.0}"

case "${1:-}" in
  --version)
    echo "TFG Project ${VERSION}"
    ;;
  "")
    echo "usage: project.sh [--version]" >&2
    exit 1
    ;;
  *)
    echo "unknown option: $1" >&2
    echo "usage: project.sh [--version]" >&2
    exit 1
    ;;
esac
