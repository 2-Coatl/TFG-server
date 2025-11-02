"""Carga y validación de la configuración de Codex."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List

import tomllib


@dataclass(frozen=True)
class CodexTask:
    """Representa una tarea configurable de Codex."""

    nombre: str
    comando: List[str]
    descripcion: str | None
    directorio: Path


class CodexConfig:
    """Gestiona las tareas configuradas en un archivo ``codex.toml``."""

    def __init__(self, version: int, tareas: Dict[str, CodexTask], origen: Path) -> None:
        self._version = version
        self._tareas = tareas
        self._origen = origen

    @property
    def version(self) -> int:
        """Devuelve la versión declarada de la configuración."""

        return self._version

    @property
    def origen(self) -> Path:
        """Devuelve la ruta del archivo utilizado para construir la configuración."""

        return self._origen

    @classmethod
    def from_file(cls, ruta: Path) -> "CodexConfig":
        """Construye una configuración a partir del archivo indicado."""

        if not ruta.exists():
            raise FileNotFoundError(ruta)

        try:
            contenido = tomllib.loads(ruta.read_text(encoding="utf-8"))
        except tomllib.TOMLDecodeError as error:
            raise ValueError("No fue posible analizar el archivo TOML") from error

        version = contenido.get("version")
        if version != 1:
            raise ValueError("La versión de configuración debe ser 1")

        tareas_crudas = contenido.get("tareas")
        if not isinstance(tareas_crudas, list):
            raise ValueError("El archivo debe contener una lista 'tareas'")

        tareas: Dict[str, CodexTask] = {}
        base = ruta.parent
        for indice, tarea in enumerate(tareas_crudas, start=1):
            if not isinstance(tarea, dict):
                raise ValueError(f"La entrada {indice} de 'tareas' debe ser un objeto")

            nombre = tarea.get("nombre")
            if not nombre or not isinstance(nombre, str):
                raise ValueError("Cada tarea debe tener un nombre en formato texto")

            if nombre in tareas:
                raise ValueError(f"La tarea '{nombre}' está declarada más de una vez")

            comando = tarea.get("comando")
            if not _es_lista_de_cadenas(comando):
                raise ValueError("Cada tarea debe declarar un 'comando' con una lista de cadenas")

            descripcion = tarea.get("descripcion")
            if descripcion is not None and not isinstance(descripcion, str):
                raise ValueError("La descripción debe ser texto si está presente")

            directorio_crudo = tarea.get("directorio")
            if directorio_crudo is None:
                directorio = base
            elif isinstance(directorio_crudo, str) and directorio_crudo.strip():
                directorio = (base / directorio_crudo).resolve()
            else:
                raise ValueError("El directorio debe ser una cadena no vacía si se indica")

            tareas[nombre] = CodexTask(
                nombre=nombre,
                comando=list(comando),
                descripcion=descripcion,
                directorio=directorio,
            )

        return cls(version=version, tareas=tareas, origen=ruta)

    def list_tasks(self) -> List[CodexTask]:
        """Devuelve las tareas ordenadas por nombre."""

        return [self._tareas[nombre] for nombre in sorted(self._tareas)]

    def get_task(self, nombre: str) -> CodexTask:
        """Recupera una tarea existente."""

        if nombre not in self._tareas:
            raise KeyError(nombre)
        return self._tareas[nombre]


def _es_lista_de_cadenas(valor: Iterable[str] | None) -> bool:
    """Comprueba si el valor proporcionado es una lista de cadenas."""

    if not isinstance(valor, list):
        return False
    return all(isinstance(elemento, str) and elemento for elemento in valor)
