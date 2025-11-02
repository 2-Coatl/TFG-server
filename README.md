# TFG Codex Server

Herramienta monolítica para ejecutar tareas de soporte al desarrollo mediante la interfaz `codex`, implementada íntegramente con Shell.

## Requisitos

- Bash 4 o superior.
- Herramientas estándar POSIX (awk, sort, etc.).
- Dependencias de desarrollo: `pytest` para ejecutar la suite de pruebas automatizadas.

## Instalación

No es necesario crear entornos virtuales ni instalar paquetes. Basta con clonar el repositorio y garantizar que `bin/codex` tiene permisos de ejecución:

```bash
chmod +x bin/codex
```

## Uso de Codex

El archivo `codex.toml` define las tareas disponibles. Ejemplos:

```bash
./bin/codex listar
./bin/codex ejecutar pruebas
```

La salida utiliza prefijos como `[INFO]`, `[RUNNING]`, `[SUCCESS]` y `[ERROR]` siguiendo la guía de mensajes sin emojis.

## Desarrollo

1. Trabaja siguiendo TDD: escribe primero las pruebas en `tests/` y ejecútalas con `pytest`.
2. Añade nuevas tareas en `codex.toml` cuando incorpores herramientas.
3. Mantén sincronizada la documentación en PostScript (`docs/estandares-shell-postscript.ps`).

## Documentación de decisiones

Las decisiones arquitectónicas se registran en `docs/adr`. Consulta `docs/adr/0001-ejecucion-codex.md` para detalles sobre la CLI en Shell.
