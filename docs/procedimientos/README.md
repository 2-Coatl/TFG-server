# Índice Maestro de Procedimientos

Documentación operativa completa del proyecto TFG-server. Este índice organiza
todos los procedimientos por categoría y fase del desarrollo.

## 🚀 Inicio Rápido

### Para Nuevos Desarrolladores

**Comienza aquí:**

1. [Onboarding Completo](procedimiento_onboarding.md) - Guía completa día por día
2. [Instalación del Entorno](procedimiento_instalacion_entorno.md) - Setup inicial
3. [Verificación de Dependencias](procedimiento_verificacion_dependencias.md) - Check de herramientas

### Para Desarrolladores Existentes

**Consultas rápidas:**

- [Desarrollo Local](procedimiento_desarrollo_local.md) - Workflow diario
- [CI/CD](procedimiento_ci_cd.md) - Pipeline de integración continua
- [Testing con BATS](testing-bats.md) - Crear y ejecutar tests

## 📚 Procedimientos por Categoría

### 1. Setup y Configuración

| Procedimiento | Descripción | Cuándo Usar |
|---------------|-------------|-------------|
| [Onboarding](procedimiento_onboarding.md) | Guía completa para nuevos miembros | Primer día en el proyecto |
| [Instalación del Entorno](procedimiento_instalacion_entorno.md) | Configurar ambiente de desarrollo | Setup inicial o reinstalación |
| [Verificación de Dependencias](procedimiento_verificacion_dependencias.md) | Verificar herramientas instaladas | Después de setup, antes de CI |
| [Git Hooks](procedimiento_git_hooks.md) | Instalar y gestionar hooks | Al clonar o actualizar hooks |

### 2. Desarrollo Diario

| Procedimiento | Descripción | Cuándo Usar |
|---------------|-------------|-------------|
| [Desarrollo Local](procedimiento_desarrollo_local.md) | Workflow de desarrollo diario | Durante desarrollo activo |
| [Creación de Features](procedimiento_creacion_features.md) | Proceso completo de nueva feature | Al iniciar nueva funcionalidad |
| [Linting](procedimiento_linting.md) | Validación de código estático | Antes de commit, durante desarrollo |
| [Testing con BATS](testing-bats.md) | Crear y ejecutar tests | Al escribir código nuevo |

### 3. Integración y Calidad

| Procedimiento | Descripción | Cuándo Usar |
|---------------|-------------|-------------|
| [CI/CD](procedimiento_ci_cd.md) | Pipeline completo de CI | Antes de push, en PRs |
| [Generación de Documentación](procedimiento_generacion_docs.md) | Crear y publicar docs | Después de cambios en markdown |
| [Revisión Documental](procedimiento_revision_documental.md) | Proceso de review de docs | Antes de release, periódicamente |
| [Limpieza](procedimiento_limpieza.md) | Limpiar archivos generados | Problemas de build, liberar espacio |

### 4. Release y Deployment

| Procedimiento | Descripción | Cuándo Usar |
|---------------|-------------|-------------|
| [Release Local](procedimiento_release_local.md) | Proceso completo de release | Al preparar nueva versión |
| [Gestión de Cambios](procedimiento_gestion_cambios.md) | Documentar y aprobar cambios | Cambios significativos |

### 5. Mantenimiento y Soporte

| Procedimiento | Descripción | Cuándo Usar |
|---------------|-------------|-------------|
| [Triage de Issues](procedimiento_triage.md) | Clasificar y priorizar issues | Al recibir nuevos issues |
| [Limpieza](procedimiento_limpieza.md) | Mantener repositorio limpio | Periódicamente, problemas build |

## 🔍 Búsqueda Rápida por Tarea

### "Quiero hacer..."

#### ...mi primer setup

1. [Onboarding](procedimiento_onboarding.md)
2. [Instalación del Entorno](procedimiento_instalacion_entorno.md)
3. [Verificación de Dependencias](procedimiento_verificacion_dependencias.md)
4. [Git Hooks](procedimiento_git_hooks.md)

#### ...una nueva feature

1. [Creación de Features](procedimiento_creacion_features.md)
2. [Testing con BATS](testing-bats.md)
3. [CI/CD](procedimiento_ci_cd.md)

#### ...validar mi código

1. [Linting](procedimiento_linting.md)
2. [Testing con BATS](testing-bats.md)
3. [CI/CD](procedimiento_ci_cd.md)

#### ...hacer un release

1. [Release Local](procedimiento_release_local.md)
2. [Gestión de Cambios](procedimiento_gestion_cambios.md)
3. [Revisión Documental](procedimiento_revision_documental.md)

#### ...actualizar documentación

1. [Generación de Documentación](procedimiento_generacion_docs.md)
2. [Linting](procedimiento_linting.md)
3. [Revisión Documental](procedimiento_revision_documental.md)

#### ...resolver un problema

1. [Triage de Issues](procedimiento_triage.md)
2. [Limpieza](procedimiento_limpieza.md)
3. [Desarrollo Local](procedimiento_desarrollo_local.md)

## 📋 Checklist por Rol

### Desarrollador Junior

**Procedimientos esenciales:**

- ✅ Onboarding
- ✅ Instalación del Entorno
- ✅ Desarrollo Local
- ✅ Linting
- ✅ Testing con BATS
- ✅ Git Hooks

**Procedimientos opcionales:**

- CI/CD
- Creación de Features

### Desarrollador Senior

**Todos los anteriores más:**

- ✅ CI/CD
- ✅ Creación de Features
- ✅ Generación de Documentación
- ✅ Revisión Documental
- ✅ Triage de Issues

### Tech Lead

**Todos los anteriores más:**

- ✅ Release Local
- ✅ Gestión de Cambios
- ✅ Revisión de todos los procedimientos

### DevOps Engineer

**Foco en:**

- ✅ CI/CD
- ✅ Verificación de Dependencias
- ✅ Git Hooks
- ✅ Release Local
- ✅ Limpieza

## 🎯 Workflows Completos

### Workflow: Primera Contribución

```
1. Onboarding
2. Instalación del Entorno
3. Verificación de Dependencias
4. Git Hooks
5. Desarrollo Local
6. Creación de Features (práctica)
```

### Workflow: Desarrollo Diario

```
1. Desarrollo Local
2. Linting (durante desarrollo)
3. Testing (escribir tests)
4. CI/CD (antes de push)
```

### Workflow: Feature Completa

```
1. Creación de Features (planificación)
2. Desarrollo Local (implementación)
3. Testing con BATS (validación)
4. Linting (calidad)
5. Generación de Documentación
6. CI/CD (integración)
```

### Workflow: Release

```
1. Gestión de Cambios
2. Revisión Documental
3. CI/CD (validación final)
4. Release Local
```

## 📊 Matriz de Procedimientos

| Procedimiento | Frecuencia | Tiempo | Complejidad | Prioridad |
|---------------|------------|--------|-------------|-----------|
| Onboarding | Una vez | 8h | Media | Alta |
| Instalación del Entorno | Una vez | 2h | Baja | Alta |
| Verificación de Dependencias | Semanal | 5min | Baja | Media |
| Git Hooks | Una vez | 10min | Baja | Alta |
| Desarrollo Local | Diario | Variable | Media | Alta |
| Creación de Features | Por feature | 1-5 días | Alta | Alta |
| Linting | Múltiple/día | 30seg | Baja | Alta |
| Testing con BATS | Por feature | Variable | Media | Alta |
| CI/CD | Por commit | 2min | Media | Alta |
| Generación de Documentación | Por cambio | 30seg | Baja | Media |
| Revisión Documental | Mensual | 1h | Media | Media |
| Release Local | Por release | 30min | Alta | Alta |
| Gestión de Cambios | Por cambio mayor | 1h | Media | Alta |
| Triage de Issues | Semanal | 30min | Baja | Media |
| Limpieza | Semanal | 5min | Baja | Baja |

## 🔄 Mantenimiento de Procedimientos

### Actualización de Procedimientos

Los procedimientos se actualizan cuando:

- Cambia una herramienta o dependencia
- Se agrega nueva funcionalidad al proyecto
- Se recibe feedback de los usuarios
- Se detectan errores o información desactualizada

### Proponer Cambios

Para actualizar un procedimiento:

1. Crear issue: `docs: actualizar procedimiento X`
2. Hacer cambios en tu rama
3. Seguir [Creación de Features](procedimiento_creacion_features.md)
4. PR con label `documentation`

### Versionado

Cada procedimiento mantiene su propia tabla de historial al final del documento.

## 📞 Soporte

### ¿No encuentras lo que buscas?

1. **Buscar en documentación:**
   ```bash
   grep -r "término de búsqueda" docs/
   ```

2. **Revisar Issues de GitHub:**
   Buscar issues con label `documentation`

3. **Preguntar al equipo:**
   - Slack/Discord: Canal #documentación
   - GitHub Discussions

4. **Crear nueva documentación:**
   Si falta un procedimiento, ¡créalo!
   Ver: [Creación de Features](procedimiento_creacion_features.md)

## 🔗 Enlaces Relacionados

### Documentación Técnica

- [Automatización (CI/CD)](../automation/ci-cd.md)
- [Git Hooks](../automation/git-hooks.md)
- [Testing BATS](testing-bats.md)

### Documentación de Diseño

- [ADR 0002: Migración a Makefile](../diseno_solucion/arquitectura_sistemas/adr/0002-migracion-makefile.md)
- [Arquitectura del Sistema](../diseno_solucion/arquitectura_sistemas/README.md)

### Recursos Externos

- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [BATS Documentation](https://bats-core.readthedocs.io/)
- [Git Book](https://git-scm.com/book)
- [Markdown Guide](https://www.markdownguide.org/)

## 📈 Métricas de Uso

### Procedimientos Más Consultados

1. Onboarding
2. Desarrollo Local
3. CI/CD
4. Testing con BATS
5. Creación de Features

### Feedback

Si un procedimiento fue útil (o no), por favor:

- ⭐ Dale star al repo
- 💬 Deja comentario en el issue relacionado
- 🐛 Reporta errores o mejoras

## Historial de Cambios

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-11-03 | 1.0 | Creación inicial del índice maestro |
| 2025-11-03 | 1.1 | Agregados 7 procedimientos nuevos |
