"""Interfaz de línea de comandos para Codex."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path
from typing import Sequence

from .config import CodexConfig


def construir_argumentos() -> argparse.ArgumentParser:
    """Crea el analizador de argumentos para la CLI."""

    parser = argparse.ArgumentParser(
        prog="codex",
        description="Ejecuta tareas definidas en un archivo codex.toml",
    )
    parser.add_argument(
        "--config",
        dest="config",
        help="Ruta al archivo de configuración codex.toml",
        default=None,
    )

    subparsers = parser.add_subparsers(dest="accion", required=True)

    subparsers.add_parser("listar", help="Muestra las tareas disponibles")

    ejecutar = subparsers.add_parser("ejecutar", help="Ejecuta una tarea")
    ejecutar.add_argument("tarea", help="Nombre de la tarea a ejecutar")

    return parser


def cargar_configuracion(ruta: str | None) -> CodexConfig:
    """Carga la configuración indicada o la predeterminada."""

    ruta_config = Path(ruta) if ruta else Path.cwd() / "codex.toml"
    try:
        return CodexConfig.from_file(ruta_config)
    except FileNotFoundError:
        print(f"[ERROR] No se encontró el archivo de configuración en {ruta_config}", file=sys.stderr)
        raise SystemExit(2) from None
    except ValueError as error:
        print(f"[ERROR] Configuración inválida: {error}", file=sys.stderr)
        raise SystemExit(2) from None


def ejecutar_tarea(config: CodexConfig, nombre: str) -> int:
    """Ejecuta la tarea indicada y devuelve el código de salida."""

    try:
        tarea = config.get_task(nombre)
    except KeyError:
        print(f"[ERROR] La tarea '{nombre}' no existe en la configuración.", file=sys.stderr)
        return 1

    print(f"[RUNNING] Ejecutando '{tarea.nombre}' ...")
    try:
        subprocess.run(tarea.comando, cwd=str(tarea.directorio), check=True)
    except subprocess.CalledProcessError as error:
        codigo = error.returncode or 1
        print(
            f"[ERROR] La tarea '{tarea.nombre}' finalizó con errores (código {codigo}).",
            file=sys.stderr,
        )
        return codigo

    print(f"[SUCCESS] La tarea '{tarea.nombre}' finalizó correctamente.")
    return 0


def listar_tareas(config: CodexConfig) -> None:
    """Imprime las tareas disponibles."""

    tareas = config.list_tasks()
    if not tareas:
        print("[INFO] No hay tareas configuradas.")
        return

    for tarea in tareas:
        descripcion = tarea.descripcion or "Sin descripción"
        print(f"[INFO] {tarea.nombre}: {descripcion}")


def main(argv: Sequence[str] | None = None) -> int:
    """Punto de entrada principal para la CLI."""

    parser = construir_argumentos()
    args = parser.parse_args(argv)

    try:
        config = cargar_configuracion(args.config)
    except SystemExit as error:
        return int(error.code)

    if args.accion == "listar":
        listar_tareas(config)
        return 0

    if args.accion == "ejecutar":
        return ejecutar_tarea(config, args.tarea)

    return 1


if __name__ == "__main__":  # pragma: no cover - entrada de consola
    sys.exit(main())
