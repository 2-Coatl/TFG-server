# Scripts de Mantenimiento

## <a id="ci-local"></a> ci-local.sh

- **Reemplaza:** Workflows de CI en GitHub Actions
- **Propósito:** Ejecuta linting, tests y generación de documentación en cadena.
- **Uso básico:**

  ```bash
  ./scripts/bash/ci-local.sh
  ```

- **Variables de entorno:** `SKIP_LINT`, `SKIP_TESTS`, `SKIP_DOCS`.

## <a id="lint-local"></a> lint-local.sh

- **Propósito:** Ejecutar los linters de Markdown, Python y Shell.
- **Uso:** `./scripts/bash/lint-local.sh`
- **Variables:** `SKIP_MARKDOWN`, `SKIP_PYTHON`, `SKIP_SHELL`.

## <a id="test-all"></a> test-all.sh

- **Propósito:** Ejecutar la suite de `pytest`.
- **Uso:** `./scripts/bash/test-all.sh`
- **Variables:** `PYTEST_ARGS` para argumentos adicionales.

## <a id="build-docs"></a> build-docs.sh

- **Propósito:** Generar documentación con MkDocs y servirla localmente.
- **Uso:**

  ```bash
  ./scripts/bash/build-docs.sh       # solo genera
  ./scripts/bash/build-docs.sh --serve  # genera y sirve
  ```

- **Variables:** `DOCFX_SERVE_PORT` al usar `--serve`.

## <a id="release-local"></a> release-local.sh

- **Propósito:** Orquestar el pipeline de release local.
- **Uso:** `./scripts/bash/release-local.sh`
- **Variables:** `SKIP_PUBLISH`, `RELEASE_DRY_RUN`.

## <a id="release-scripts"></a> scripts auxiliares de release

Los siguientes scripts se encuentran en `scripts/bash/release/` y son invocados
por `release-local.sh`:

- `check-release-exists.sh`
- `get-next-version.sh`
- `update-version.sh`
- `generate-release-notes.sh`
- `create-release-packages.sh`
- `create-github-release.sh`

Cada script expone encabezados con información de uso y respeta la variable
`RELEASE_DRY_RUN` para simulaciones.
