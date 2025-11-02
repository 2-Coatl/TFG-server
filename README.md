# TFG Codex Server

Herramienta monolítica para ejecutar tareas de soporte al desarrollo mediante la interfaz `codex`.

## Requisitos

- Python 3.11 o superior.
- Entorno virtual recomendado.
- Dependencias de desarrollo opcionales: `pytest` para pruebas y `ruff` para análisis estático.

## Instalación

```bash
python -m venv .venv
source .venv/bin/activate
pip install -e .[dev]
```

> Nota: Si no se desea instalar dependencias adicionales, puede omitirse el sufijo `[dev]` y gestionar manualmente las herramientas.

## Uso de Codex

El archivo `codex.toml` define las tareas disponibles. Ejemplos:

```bash
python -m codex listar
python -m codex ejecutar pruebas
```

La salida utiliza prefijos como `[INFO]`, `[RUNNING]`, `[SUCCESS]` y `[ERROR]` siguiendo la guía de mensajes sin emojis.

## Desarrollo

1. Trabaja siguiendo TDD: escribe primero las pruebas en `tests/`.
2. Ejecuta la suite completa con `codex ejecutar pruebas`.
3. Añade nuevas tareas en `codex.toml` cuando incorpores herramientas.

## Documentación de decisiones

Las decisiones arquitectónicas se registran en `docs/adr`. Consulta `docs/adr/0001-ejecucion-codex.md` para detalles sobre la CLI.
