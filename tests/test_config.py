"""Pruebas sobre la validación del archivo de configuración en Shell."""

from __future__ import annotations

import subprocess
from pathlib import Path


CLI_PATH = Path(__file__).resolve().parents[1] / "bin" / "codex"


def ejecutar(*argumentos: str, config: Path | None = None, cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
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


def test_error_si_no_hay_version(tmp_path: Path) -> None:
    """La configuración debe declarar explícitamente la versión."""

    ruta = tmp_path / "codex.toml"
    ruta.write_text(
        """
[[tareas]]
nombre = "demo"
comando = ["echo", "hola"]
""".strip(),
        encoding="utf-8",
    )

    resultado = ejecutar("listar", config=ruta)

    assert resultado.returncode == 2
    assert "version" in resultado.stderr.lower()


def test_error_si_version_incorrecta(tmp_path: Path) -> None:
    """Las versiones distintas de 1 deben rechazarse."""

    ruta = tmp_path / "codex.toml"
    ruta.write_text(
        """
version = 2

[[tareas]]
nombre = "demo"
comando = ["echo", "hola"]
""".strip(),
        encoding="utf-8",
    )

    resultado = ejecutar("listar", config=ruta)

    assert resultado.returncode == 2
    assert "version" in resultado.stderr.lower()


def test_ejecucion_con_directorio_relativo(tmp_path: Path) -> None:
    """El comando debe ejecutarse en el directorio indicado en la configuración."""

    destino = tmp_path / "subdir"
    destino.mkdir()
    marcador = destino / "registro.txt"

    ruta = tmp_path / "codex.toml"
    ruta.write_text(
        """
version = 1

[[tareas]]
nombre = "guardar"
comando = ["bash", "-c", "echo ok > registro.txt"]
directorio = "subdir"
""".strip(),
        encoding="utf-8",
    )

    resultado = ejecutar("ejecutar", "guardar", config=ruta, cwd=tmp_path)

    assert resultado.returncode == 0
    assert marcador.read_text(encoding="utf-8").strip() == "ok"
