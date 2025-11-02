# Procedimiento - Instalación Base del Proyecto

**Propósito:** Garantizar una instalación mínima reproducible para ejecutar el servidor y las automatizaciones descritas en la documentación técnica.

## Alcance
Personas que necesitan preparar un entorno desde cero en estaciones Linux o WSL.

## Roles
- **Persona instaladora:** ejecuta y verifica cada paso.
- **Responsable técnico:** apoya en resolución de incidencias y valida prerequisitos corporativos.

## Prerrequisitos
- Acceso a Git y Python 3.11+.
- Permisos para instalar dependencias del sistema requeridas por los scripts (Shell, Make).

## Pasos
1. **Clonar el repositorio**
   - `git clone <url>` y `cd TFG-server`.
2. **Instalar el paquete en editable**
   - Ejecutar `pip install -e .` para disponer del módulo `tfg_server` y dependencias compartidas.
3. **Inicializar entorno de desarrollo**
   - Ejecutar `make setup` para instalar hooks, dependencias adicionales y preparar el armazón local.
4. **Verificación rápida**
   - Ejecutar `python -m tfg_server` para validar que la instalación es funcional.
   - En caso de error, consultar `docs/TROUBLESHOOTING.md`.

## Entregables
- Entorno local operativo con dependencias instaladas.
- Registro de comandos ejecutados y versiones utilizadas.

## Métricas sugeridas
- Tiempo transcurrido entre clonación y primera ejecución exitosa.
- Número de incidencias registradas durante la instalación.

## Referencias
- `docs/installation.md`
- `docs/quickstart.md`
- `docs/local-development.md`
