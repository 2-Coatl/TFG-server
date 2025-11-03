# Migración desde GitHub Actions

## 📜 Historia

El proyecto utilizaba GitHub Actions para linting, pruebas, documentación y
releases. Con el objetivo de ejecutar los mismos procesos de forma independiente
al proveedor, se migró a una estrategia basada en scripts shell locales.

## 🔄 Equivalencias

| GitHub Actions | Script actual | Comando |
|----------------|---------------|---------|
| `.github/workflows/lint.yml` | `scripts/bash/lint-local.sh` | `./scripts/bash/lint-local.sh` |
| `.github/workflows/test.yml` | `scripts/bash/test-all.sh` | `./scripts/bash/test-all.sh` |
| `.github/workflows/docs.yml` | `scripts/bash/build-docs.sh` | `./scripts/bash/build-docs.sh` |
| `.github/workflows/release.yml` | `scripts/bash/release-local.sh` | `./scripts/bash/release-local.sh` |

## ¿Qué cambia?

- ❌ Se elimina la ejecución automática al hacer push o abrir PR.
- ❌ Ya no se dispone de la interfaz de GitHub Actions.
- ✅ Se gana ejecución offline y reproducible.
- ✅ Se puede integrar con cualquier proveedor de control de versiones.

## Nuevos flujos

Antes:

```bash
git push origin main

# Esperar los resultados en GitHub Actions

```

Ahora:

```bash
./scripts/bash/ci-local.sh

# Si todo pasa:

git push origin main
```

## Git hooks

Los git hooks automatizan parte del proceso:

- `pre-commit`: formato y verificación rápida.
- `pre-push`: ejecuta `ci-local.sh` o validaciones equivalentes.
- `post-commit`: sincroniza documentación y especificaciones.

Instálalos con `./scripts/bash/spec-hooks-install.sh`.

## Scripts auxiliares

Los scripts que antes vivían en `.github/workflows/scripts/` ahora están en
`scripts/bash/release/` y pueden reutilizarse o extenderse según el proveedor.

## Próximos pasos recomendados

1. Ejecutar `./scripts/bash/check-prerequisites.sh` para validar dependencias.
2. Añadir alias en tu shell, por ejemplo: `alias ci='./scripts/bash/ci-local.sh'`.
3. Documentar en PRs qué scripts se ejecutaron localmente.
