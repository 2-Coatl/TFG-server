# Estrategia de pruebas con Bats

Este documento describe los pasos para migrar la suite de pruebas del proyecto hacia [Bats](<https://bats-core.readthedocs.i>o), siguiendo las recomendaciones del tutorial oficial. El objetivo es reemplazar la dependencia de pytest por un flujo basado en scripts Bash que podamos ejecutar tanto en entornos locales como en la integración continua.

## Estructura del repositorio

Añadiremos Bats y sus librerías de soporte como submódulos de Git para facilitar su actualización y reutilización:

```
test/
  bats/                    # Submódulo bats-core
  test_helper/
    bats-support/          # Submódulo bats-support
    bats-assert/           # Submódulo bats-assert
  test.bats                # Archivos de pruebas
```

Para añadirlos ejecuta:

```bash
git submodule add <https://github.com/bats-core/bats-core.git> test/bats
git submodule add <https://github.com/bats-core/bats-support.git> test/test_helper/bats-support
git submodule add <https://github.com/bats-core/bats-assert.git> test/test_helper/bats-assert
```

## Primer test

1. Crea un archivo `test/test.bats` con una primera prueba:

   ```bash
   @test "puede ejecutar el script" {
       ./src/project.sh
   }
   ```

2. Ejecuta las pruebas con:

   ```bash
   ./test/bats/bin/bats test/test.bats
   ```

3. Si el script aún no existe verás un error (`status 127`). Crea el archivo `src/project.sh`, dale permisos de ejecución y vuelve a lanzar las pruebas.

## Configuración de entorno en las pruebas

Utiliza la función `setup()` de Bats para preparar el entorno antes de cada prueba:

```bash
setup() {
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR/../src:$PATH"
}
```

Con esto podrás invocar los scripts ubicados en `src/` directamente (por ejemplo `project.sh`).

## Uso de bats-assert y bats-support

Carga las librerías en `setup()` para habilitar aserciones expresivas:

```bash
setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    # Resto de la configuración...
}
```

- `run <comando>` captura `stdout`, `stderr` y el código de salida sin fallar automáticamente.
- `assert_output` y `refute_output` permiten validar la salida almacenada en `$output`.
- Usa `--partial` para comprobar substrings sin repetir funciones auxiliares.

## Limpieza y reutilización

- Define `teardown()` para eliminar artefactos creados por cada prueba.
- Usa `setup_file()` y `teardown_file()` cuando necesites inicializar recursos costosos una sola vez por archivo.
- El comando `skip` permite omitir pruebas de forma controlada cuando falten dependencias externas.

## Organización de múltiples archivos

- Importa configuración compartida con `load 'test_helper/common-setup'` y centraliza la lógica repetida.
- Ejecuta todas las pruebas con `./test/bats/bin/bats test/`. Bats detectará automáticamente todos los archivos con extensión `.bats`.

## Próximos pasos

1. Eliminar la infraestructura de pytest y las pruebas antiguas basadas en Python.
2. Inicializar los submódulos y crear la primera prueba en Bats siguiendo los pasos anteriores.
3. Migrar gradualmente la cobertura de pruebas a Bats manteniendo el enfoque TDD (rojo → verde → refactor).

Este documento servirá como referencia durante la transición completa hacia la nueva estrategia de pruebas.
