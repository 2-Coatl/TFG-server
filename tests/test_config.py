"""Pruebas para la carga del archivo de configuración de Codex."""

from pathlib import Path

import pytest

from codex.config import CodexConfig


@pytest.fixture
def config_path(tmp_path: Path) -> Path:
    """Crea un archivo de configuración básico para las pruebas."""
    contenido = """
version = 1

[[tareas]]
nombre = "pruebas"
descripcion = "Ejecuta la suite de pruebas"
comando = ["python", "-m", "pytest"]
directorio = "tests"

[[tareas]]
nombre = "lint"
descripcion = "Analiza el código"
comando = ["python", "-m", "flake8"]
"""
    ruta = tmp_path / "codex.toml"
    ruta.write_text(contenido, encoding="utf-8")
    return ruta


def test_carga_tareas_desde_archivo(config_path: Path) -> None:
    """Verifica que se carguen las tareas declaradas en el archivo."""
    configuracion = CodexConfig.from_file(config_path)

    tarea = configuracion.get_task("pruebas")
    assert tarea.nombre == "pruebas"
    assert tarea.descripcion == "Ejecuta la suite de pruebas"
    assert tarea.comando == ["python", "-m", "pytest"]
    assert tarea.directorio.name == "tests"

    tareas = configuracion.list_tasks()
    assert [t.nombre for t in tareas] == ["lint", "pruebas"]


def test_error_por_tareas_repetidas(tmp_path: Path) -> None:
    """Dos tareas con el mismo nombre deben generar un error."""
    contenido = """
version = 1

[[tareas]]
nombre = "duplicada"
comando = ["python"]

[[tareas]]
nombre = "duplicada"
comando = ["python"]
"""
    ruta = tmp_path / "codex.toml"
    ruta.write_text(contenido, encoding="utf-8")

    with pytest.raises(ValueError) as error:
        CodexConfig.from_file(ruta)

    assert "duplicada" in str(error.value)


def test_error_por_campo_incompleto(tmp_path: Path) -> None:
    """Una tarea sin comando debe generar un error descriptivo."""
    contenido = """
version = 1

[[tareas]]
nombre = "invalida"
"""
    ruta = tmp_path / "codex.toml"
    ruta.write_text(contenido, encoding="utf-8")

    with pytest.raises(ValueError) as error:
        CodexConfig.from_file(ruta)

    assert "comando" in str(error.value)
