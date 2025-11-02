"""Pruebas para la interfaz de línea de comandos de Codex en Shell."""

from __future__ import annotations

import subprocess
from pathlib import Path
from typing import Iterable

import pytest


CLI_PATH = Path(__file__).resolve().parents[1] / "bin" / "codex"


def escribir_configuracion(base: Path, lineas: Iterable[str]) -> Path:
    """Crea un archivo ``codex.toml`` con el contenido indicado."""

    contenido = "\n".join(lineas)
    ruta = base / "codex.toml"
    ruta.write_text(contenido, encoding="utf-8")
    return ruta


def ejecutar_codex(*argumentos: str, config: Path | None = None, cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    """Invoca el script de codex y captura su salida."""

    comando = [str(CLI_PATH)]
    if config is not None:
        comando.extend(["--config", str(config)])
    comando.extend(argumentos)
    return subprocess.run(
        comando,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=cwd,
    )


def test_listar_muestra_tareas_ordenadas(tmp_path: Path) -> None:
    """La salida debe enumerar las tareas en orden alfabético."""

    config = escribir_configuracion(
        tmp_path,
        [
            "version = 1",
            "",
            "[[tareas]]",
            "nombre = \"pruebas\"",
            "descripcion = \"Ejecuta pruebas\"",
            "comando = [\"echo\", \"hola\"]",
            "",
            "[[tareas]]",
            "nombre = \"analisis\"",
            "descripcion = \"Analiza el codigo\"",
            "comando = [\"echo\", \"adios\"]",
        ],
    )

    resultado = ejecutar_codex("listar", config=config)

    assert resultado.returncode == 0
    assert "[INFO] analisis" in resultado.stdout
    assert resultado.stdout.index("analisis") < resultado.stdout.index("pruebas")


def test_ejecutar_invoca_comando(tmp_path: Path) -> None:
    """La tarea debe ejecutar el comando configurado en el directorio indicado."""

    script = tmp_path / "registro.sh"
    script.write_text("#!/usr/bin/env bash\necho ejecutado >> salida.log\n", encoding="utf-8")
    script.chmod(0o755)

    config = escribir_configuracion(
        tmp_path,
        [
            "version = 1",
            "",
            "[[tareas]]",
            "nombre = \"registrar\"",
            "descripcion = \"Guarda un registro\"",
            f"comando = [\"{script}\"]",
            "directorio = \".\"",
        ],
    )

    resultado = ejecutar_codex("ejecutar", "registrar", config=config, cwd=tmp_path)

    assert resultado.returncode == 0
    assert "[RUNNING]" in resultado.stdout
    assert "[SUCCESS]" in resultado.stdout
    assert (tmp_path / "salida.log").read_text(encoding="utf-8").strip() == "ejecutado"


def test_ejecutar_reporta_error_si_comando_falla(tmp_path: Path) -> None:
    """Un comando con error debe propagar el código de salida y reportarlo."""

    config = escribir_configuracion(
        tmp_path,
        [
            "version = 1",
            "",
            "[[tareas]]",
            "nombre = \"fallar\"",
            "comando = [\"bash\", \"-c\", \"exit 5\"]",
        ],
    )

    resultado = ejecutar_codex("ejecutar", "fallar", config=config)

    assert resultado.returncode == 5
    assert "[ERROR]" in resultado.stderr
    assert "'fallar'" in resultado.stderr


def test_error_si_no_existe_configuracion(tmp_path: Path) -> None:
    """La CLI debe avisar si el archivo de configuración no está presente."""

    ruta = tmp_path / "inexistente.toml"
    resultado = ejecutar_codex("listar", config=ruta)

    assert resultado.returncode == 2
    assert "[ERROR]" in resultado.stderr
    assert "inexistente" in resultado.stderr


def test_error_si_tarea_desconocida(tmp_path: Path) -> None:
    """Ejecutar una tarea inexistente debe devolver un error controlado."""

    config = escribir_configuracion(
        tmp_path,
        [
            "version = 1",
            "",
            "[[tareas]]",
            "nombre = \"unica\"",
            "comando = [\"echo\", \"ok\"]",
        ],
    )

    resultado = ejecutar_codex("ejecutar", "desconocida", config=config)

    assert resultado.returncode == 1
    assert "[ERROR]" in resultado.stderr
    assert "desconocida" in resultado.stderr


def test_error_por_tareas_repetidas(tmp_path: Path) -> None:
    """Las tareas duplicadas deben generar un error descriptivo."""

    config = escribir_configuracion(
        tmp_path,
        [
            "version = 1",
            "",
            "[[tareas]]",
            "nombre = \"duplicada\"",
            "comando = [\"echo\", \"uno\"]",
            "",
            "[[tareas]]",
            "nombre = \"duplicada\"",
            "comando = [\"echo\", \"dos\"]",
        ],
    )

    resultado = ejecutar_codex("listar", config=config)

    assert resultado.returncode == 2
    assert "[ERROR]" in resultado.stderr
    assert "duplicada" in resultado.stderr


def test_error_por_comando_incompleto(tmp_path: Path) -> None:
    """Una tarea sin comando debe ser rechazada durante la carga."""

    config = escribir_configuracion(
        tmp_path,
        [
            "version = 1",
            "",
            "[[tareas]]",
            "nombre = \"sin_comando\"",
        ],
    )

    resultado = ejecutar_codex("listar", config=config)

    assert resultado.returncode == 2
    assert "[ERROR]" in resultado.stderr
    assert "sin_comando" in resultado.stderr
