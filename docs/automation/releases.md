# Proceso de Releases

Las releases se gestionan íntegramente con scripts locales para mantener el
control del proceso sin depender de un proveedor externo.

## Flujo general

```bash
./scripts/bash/release-local.sh
```

El script principal ejecuta cada fase en orden, permitiendo realizar un `dry run`
con `RELEASE_DRY_RUN=1` y omitir la publicación remota con `SKIP_PUBLISH=1`.

## Scripts involucrados

1. **check-release-exists.sh** – Verifica si la versión ya fue publicada.
2. **get-next-version.sh** – Calcula la siguiente versión semántica.
3. **update-version.sh** – Actualiza archivos como `pyproject.toml` y

   `CHANGELOG.md`.

4. **generate-release-notes.sh** – Genera el resumen de cambios.
5. **create-release-packages.sh** – Construye los artefactos distribuibles.
6. **create-github-release.sh** – Publica la release (puede adaptarse a cualquier

   proveedor).

Todos los scripts residen en `scripts/bash/release/` y comparten la variable de
entorno `RELEASE_DRY_RUN`.

## Prerrequisitos recomendados

- Python 3.11+
- `build` o `setuptools` según las necesidades de empaquetado
- Acceso a credenciales del proveedor de releases (si aplica)

## Consejos prácticos

- Ejecuta `./scripts/bash/test-all.sh` antes del release para asegurar la suite

  verde.

- Revisa el `CHANGELOG.md` para confirmar que contiene las entradas esperadas.
- Usa `SKIP_PUBLISH=1` cuando quieras revisar los artefactos sin subirlos.
