"""Pruebas para la interfaz de línea de comandos de Codex."""

from pathlib import Path
from typing import List

import pytest

from codex import cli


@pytest.fixture
def config_path(tmp_path: Path) -> Path:
    """Genera un archivo de configuración para las pruebas de la CLI."""
    contenido = """
version = 1

[[tareas]]
nombre = "pruebas"
descripcion = "Ejecuta la suite de pruebas"
comando = ["python", "-m", "pytest"]
"""
    ruta = tmp_path / "codex.toml"
    ruta.write_text(contenido, encoding="utf-8")
    return ruta


def test_listar_muestra_tareas_ordenadas(config_path: Path, capsys: pytest.CaptureFixture[str]) -> None:
    """La salida debe enumerar las tareas en orden alfabético."""
    codigo = cli.main(["--config", str(config_path), "listar"])
    salida = capsys.readouterr().out

    assert codigo == 0
    assert "[INFO]" in salida
    assert "pruebas" in salida


def test_ejecutar_invoca_subproceso(monkeypatch: pytest.MonkeyPatch, config_path: Path, capsys: pytest.CaptureFixture[str]) -> None:
    """La tarea debe ejecutar el comando configurado."""
    registros: List[List[str]] = []

    def falso_run(comando: List[str], cwd: str | None = None, check: bool = False) -> None:
        registros.append(comando)

    monkeypatch.setattr(cli.subprocess, "run", falso_run)

    codigo = cli.main(["--config", str(config_path), "ejecutar", "pruebas"])
    salida = capsys.readouterr().out

    assert codigo == 0
    assert registros == [["python", "-m", "pytest"]]
    assert "[RUNNING]" in salida
    assert "[SUCCESS]" in salida


def test_ejecutar_reporta_error_si_comando_falla(monkeypatch: pytest.MonkeyPatch, config_path: Path, capsys: pytest.CaptureFixture[str]) -> None:
    """Un error en el comando debe reportarse con el código adecuado."""
    def falso_run(comando: List[str], cwd: str | None = None, check: bool = False) -> None:
        raise cli.subprocess.CalledProcessError(returncode=5, cmd=comando)

    monkeypatch.setattr(cli.subprocess, "run", falso_run)

    codigo = cli.main(["--config", str(config_path), "ejecutar", "pruebas"])
    salida = capsys.readouterr()

    assert codigo == 5
    assert "[ERROR]" in salida.err
    assert "pruebas" in salida.err


def test_error_si_no_existe_configuracion(tmp_path: Path, capsys: pytest.CaptureFixture[str]) -> None:
    """La CLI debe avisar si el archivo de configuración no está presente."""
    ruta = tmp_path / "codex.toml"
    codigo = cli.main(["--config", str(ruta), "listar"])
    salida = capsys.readouterr()

    assert codigo == 2
    assert "[ERROR]" in salida.err
    assert "configuración" in salida.err


def test_error_si_tarea_desconocida(config_path: Path, capsys: pytest.CaptureFixture[str]) -> None:
    """Ejecutar una tarea inexistente debe devolver un error controlado."""
    codigo = cli.main(["--config", str(config_path), "ejecutar", "desconocida"])
    salida = capsys.readouterr()

    assert codigo == 1
    assert "[ERROR]" in salida.err
    assert "desconocida" in salida.err
