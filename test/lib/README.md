# Test Libraries

Este directorio contiene frameworks de testing para el proyecto.

## shUnit2

[shUnit2](https://github.com/kward/shunit2) es un framework de testing xUnit para scripts shell.

**Versión**: 2.1.9pre
**Licencia**: Apache 2.0
**Autor**: Kate Ward

### Características

- Framework de testing completo basado en xUnit
- Soporta assertions comunes (assertEquals, assertTrue, assertFalse, etc.)
- No requiere instalación externa (un solo archivo shell)
- Compatible con Bash, Dash, Ksh, Zsh
- Generación de reportes con color
- Soporte para JUnit XML output

### Uso Básico

Crear un archivo de test que termine con `_test.sh`:

```bash
#!/usr/bin/env bash

# Test functions (deben empezar con 'test')
testSomething() {
    assertEquals "mensaje" "valor_esperado" "valor_actual"
}

testAnotherThing() {
    assertTrue "mensaje" "[ -f '/path/to/file' ]"
}

# Setup/Teardown
setUp() {
    # Ejecutado antes de cada test
}

tearDown() {
    # Ejecutado después de cada test
}

oneTimeSetUp() {
    # Ejecutado una vez antes de todos los tests
}

oneTimeTearDown() {
    # Ejecutado una vez después de todos los tests
}

# Cargar shUnit2
. ./test/lib/shunit2
```

### Assertions Disponibles

| Assertion | Descripción |
|-----------|-------------|
| `assertEquals [message] expected actual` | Verifica que dos valores sean iguales |
| `assertNotEquals [message] expected actual` | Verifica que dos valores NO sean iguales |
| `assertSame [message] expected actual` | Alias de assertEquals |
| `assertNotSame [message] expected actual` | Alias de assertNotEquals |
| `assertTrue [message] condition` | Verifica que la condición sea verdadera |
| `assertFalse [message] condition` | Verifica que la condición sea falsa |
| `assertNull [message] value` | Verifica que el valor sea null (vacío) |
| `assertNotNull [message] value` | Verifica que el valor NO sea null |
| `assertContains [message] container content` | Verifica que container contenga content |
| `assertNotContains [message] container content` | Verifica que container NO contenga content |
| `fail [message]` | Marca el test como fallido |

### Ejecutar Tests

```bash
# Ejecutar un test específico
./test/mcp_shunit2_test.sh

# Ejecutar con make
make test-shunit2

# Ejecutar todos los tests (BATS + shUnit2)
make test-all
```

### Opciones de Ejecución

```bash
# Generar reporte JUnit XML
./test/mcp_shunit2_test.sh --output-junit-xml=output.xml

# Ejecutar tests específicos
./test/mcp_shunit2_test.sh testServerRespondsToInitialize testValidateProjectStructureViaJsonRpc

# Personalizar nombre de suite
./test/mcp_shunit2_test.sh --suite-name="Mi Suite Personalizada"
```

### Comparación: shUnit2 vs BATS

| Característica | shUnit2 | BATS |
|----------------|---------|------|
| **Instalación** | No requiere (un archivo) | Requiere instalación |
| **Sintaxis** | xUnit (funciones) | TAP (bloques @test) |
| **Assertions** | Más variedad nativa | Básicas (assert_success, etc.) |
| **Helpers** | setUp/tearDown/oneTime* | setup/teardown |
| **JUnit XML** | Incluido | Requiere plugins |
| **Portabilidad** | Alta (POSIX) | Media (requiere BATS) |
| **Legibilidad** | Buena | Excelente |

## Por Qué Dos Frameworks

El proyecto usa **ambos** frameworks por las siguientes razones:

1. **BATS**: Mejor integración con CI/CD tradicional, sintaxis más legible
2. **shUnit2**: Más portable, no requiere instalación, ideal para pruebas rápidas

Ambos frameworks complementan la estrategia de testing del proyecto.

## Actualización de shUnit2

Para actualizar shUnit2 a la última versión:

```bash
cd test/lib
curl -sSL https://raw.githubusercontent.com/kward/shunit2/master/shunit2 -o shunit2
chmod +x shunit2
```

## Referencias

- [shUnit2 GitHub](https://github.com/kward/shunit2)
- [shUnit2 Documentation](https://github.com/kward/shunit2/wiki)
- [BATS Documentation](https://bats-core.readthedocs.io/)
