# ADR 0001: Introducción de la herramienta Codex CLI

## Contexto

El proyecto necesitaba una forma estandarizada de orquestar tareas de desarrollo (pruebas, análisis estático, etc.) sin depender de scripts dispersos. Además, se solicitó habilitar la ejecución de "codex" dentro del monolito.

## Decisión

Se creó un paquete Python llamado `codex` con una interfaz de línea de comandos que:

- Lee un archivo `codex.toml` para descubrir tareas configuradas.
- Permite listar las tareas disponibles mediante `codex listar`.
- Ejecuta tareas específicas con `codex ejecutar <nombre>` utilizando `subprocess.run`.
- Emplea un formato de salida uniforme con prefijos `[INFO]`, `[RUNNING]`, `[SUCCESS]` y `[ERROR]`, evitando emojis o iconografía especial.

La configuración se valida estrictamente para garantizar que cada tarea tenga nombre y comando definidos, y se normalizan los directorios relativos para que se resuelvan respecto al archivo de configuración.

## Consecuencias

- Las tareas de desarrollo quedan centralizadas y documentadas en `codex.toml`.
- Cualquier miembro del equipo puede descubrir las tareas disponibles ejecutando `codex listar`.
- La implementación basada en Python facilita su extensión futura y se integra sin problemas con el monolito existente.
- Es necesario mantener actualizada la configuración conforme se agreguen nuevas tareas.
