# ADR 0001: Reimplementación de la herramienta Codex CLI en Shell

## Contexto

El proyecto necesitaba una forma estandarizada de orquestar tareas de desarrollo (pruebas, análisis estático, etc.) sin depender de scripts dispersos. Además, se solicitó habilitar la ejecución de "codex" dentro del monolito utilizando exclusivamente Shell y PostScript.

## Decisión

Se reemplazó la implementación en Python por un script Bash (`bin/codex`) que:

- Lee un archivo `codex.toml` para descubrir tareas configuradas.
- Permite listar las tareas disponibles mediante `codex listar`.
- Ejecuta tareas específicas con `codex ejecutar <nombre>` utilizando utilidades POSIX estándar.
- Emplea un formato de salida uniforme con prefijos `[INFO]`, `[RUNNING]`, `[SUCCESS]` y `[ERROR]`, evitando emojis o iconografía especial.

La configuración se valida estrictamente con Bash para garantizar que cada tarea tenga nombre y comando definidos, y se resuelven los directorios relativos respecto al archivo de configuración empleando utilidades del sistema.

## Consecuencias

- Las tareas de desarrollo quedan centralizadas y documentadas en `codex.toml`.
- Cualquier miembro del equipo puede descubrir las tareas disponibles ejecutando `codex listar`.
- La dependencia en Bash elimina la necesidad de mantener un entorno Python para ejecutar Codex, alineándose con los estándares solicitados.
- Es necesario mantener actualizada la configuración conforme se agreguen nuevas tareas.
