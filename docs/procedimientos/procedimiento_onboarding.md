# Procedimiento de Onboarding - Guía Completa para Nuevos Desarrolladores

## Objetivo

Guiar a nuevos desarrolladores a través del proceso completo de configuración,
desde el primer día hasta estar completamente productivos en el proyecto TFG-server.

## Tiempo Estimado

- **Setup inicial**: 1-2 horas
- **Familiarización**: 2-4 horas
- **Primera contribución**: 1 día
- **Productividad completa**: 1 semana

## Día 1: Setup Inicial

### Paso 1: Acceso al Proyecto (15 min)

#### 1.1 Acceso a GitHub

Solicitar acceso al repositorio:

- Contactar a: Tech Lead
- Proporcionar: Username de GitHub
- Esperar invitación al repositorio

#### 1.2 Clonar Repositorio

```bash
# SSH (recomendado)
git clone git@github.com:NestorMonroy/TFG-server.git
cd TFG-server

# HTTPS (alternativa)
git clone https://github.com/NestorMonroy/TFG-server.git
cd TFG-server
```

### Paso 2: Instalación de Dependencias (30 min)

Ver procedimiento completo:

```bash
# Abrir procedimiento de instalación
cat docs/procedimientos/procedimiento_instalacion_entorno.md
```

#### 2.1 Dependencias Sistema

**Linux/macOS:**

```bash
# Node.js y npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verificar
node --version
npm --version
```

**macOS (Homebrew):**

```bash
brew install node
```

#### 2.2 Dependencias del Proyecto

```bash
# Instalar herramientas globales
npm install -g markdownlint-cli2 bats

# Instalar shellcheck (ver procedimiento específico)
# Ver: docs/procedimientos/procedimiento_verificacion_dependencias.md
```

#### 2.3 Verificar Instalación

```bash
make check-deps
```

Debe mostrar ✓ para todas las dependencias.

### Paso 3: Configuración Inicial (15 min)

#### 3.1 Configurar Git

```bash
# Tu nombre y email
git config --global user.name "Tu Nombre"
git config --global user.email "tu.email@example.com"

# Editor preferido
git config --global core.editor "vim"  # o nano, code, etc.
```

#### 3.2 Instalar Git Hooks

```bash
make install-hooks
```

Ver detalles: `docs/procedimientos/procedimiento_git_hooks.md`

#### 3.3 Crear Rama Personal de Prueba

```bash
git checkout -b test/mi-nombre
```

### Paso 4: Primera Ejecución (15 min)

#### 4.1 Ejecutar Tests

```bash
make test
```

**Salida esperada:**

```
✓ muestra la versión del proyecto
✓ estructura documental reorganizada
```

#### 4.2 Ejecutar Linting

```bash
make lint
```

Debe completar sin errores.

#### 4.3 Generar Documentación

```bash
make docs-serve
```

Abrir: <http://localhost:8080>

Explorar la documentación generada.

### Paso 5: Familiarización con el Proyecto (30 min)

#### 5.1 Leer Documentación Esencial

**Orden recomendado:**

1. `README.md` - Overview del proyecto
2. `docs/automation/ci-cd.md` - Entender flujo de CI/CD
3. `docs/procedimientos/README.md` - Índice de procedimientos
4. `CHANGELOG.md` - Historia del proyecto

#### 5.2 Explorar Estructura

```bash
# Ver estructura del proyecto
tree -L 2

# Explorar scripts
ls -l scripts/bash/

# Ver tests
ls -l test/
```

#### 5.3 Ejecutar CI Completo

```bash
make ci
```

Esto ejecuta: lint + test + docs

Si todo pasa, tu ambiente está correctamente configurado.

## Día 2-3: Conocimiento del Proyecto

### Entender Arquitectura

#### 1. Scripts Principales

| Script | Propósito |
|--------|-----------|
| `ci-local.sh` | Pipeline de CI/CD |
| `lint-local.sh` | Validación de código |
| `test-all.sh` | Suite de tests |
| `build-docs.sh` | Generación de docs |
| `release-local.sh` | Proceso de release |

#### 2. Estructura de Documentación

```
docs/
├── procedimientos/       # Procedimientos operativos
├── requisitos/           # Requisitos del sistema
├── diseno_solucion/      # Arquitectura y diseño
├── implementacion/       # Guías de implementación
├── automation/           # CI/CD y automatización
└── validacion_evaluacion/ # Testing y QA
```

#### 3. Workflow de Desarrollo

```
Feature Request → Branch → Implement → Test → Doc → PR → Review → Merge
```

### Práctica: Primera Contribución (Tutorial)

#### Tarea Guiada: Actualizar Documentación

**Objetivo:** Hacer tu primera contribución al proyecto.

**Pasos:**

1. **Crear rama:**
   ```bash
   git checkout main
   git pull
   git checkout -b feature/actualizar-readme
   ```

2. **Hacer cambio menor:**
   ```bash
   # Agregar tu nombre a contributors (si existe sección)
   vim README.md
   ```

3. **Validar cambio:**
   ```bash
   make lint-markdown
   ```

4. **Commit:**
   ```bash
   git add README.md
   git commit -m "docs: agregar contributor"
   ```

5. **Push:**
   ```bash
   git push -u origin feature/actualizar-readme
   ```

6. **Crear PR:**
   ```bash
   gh pr create \
     --title "docs: agregar nuevo contributor" \
     --body "Primera contribución: agregando mi nombre a contributors"
   ```

7. **Esperar review y merge**

¡Felicitaciones! Has hecho tu primera contribución.

## Semana 1: Productividad Completa

### Tareas de Aprendizaje

#### Día 4-5: Tests y Calidad

1. **Leer procedimiento de testing:**
   ```bash
   cat docs/procedimientos/testing-bats.md
   ```

2. **Crear un test simple:**
   ```bash
   # Crear test de ejemplo
   vim test/test_ejemplo.bats
   ```

3. **Ejecutar y validar:**
   ```bash
   bats test/test_ejemplo.bats
   ```

#### Día 6-7: Features y CI/CD

1. **Leer procedimiento de CI/CD:**
   ```bash
   cat docs/procedimientos/procedimiento_ci_cd.md
   ```

2. **Ejecutar CI múltiples veces:**
   ```bash
   make ci
   ```

3. **Entender cada paso del pipeline**

### Proyecto de Práctica: Mini Feature

**Asignación:** Crear un script simple que se integre al proyecto.

**Ejemplo: Script de Verificación de Enlaces**

1. **Planificar:**
   - Crear issue en GitHub
   - Documentar requisitos

2. **Implementar:**
   ```bash
   git checkout -b feature/check-links
   vim scripts/bash/check-links.sh
   ```

3. **Crear test:**
   ```bash
   vim test/test_check_links.bats
   ```

4. **Documentar:**
   ```bash
   vim docs/procedimientos/procedimiento_check_links.md
   ```

5. **CI y PR:**
   ```bash
   make ci
   git commit -m "feat: agregar script de verificación de enlaces"
   git push
   gh pr create
   ```

## Recursos de Aprendizaje

### Procedimientos Críticos

**Debes leer (en orden):**

1. `procedimiento_instalacion_entorno.md` ✓
2. `procedimiento_verificacion_dependencias.md`
3. `procedimiento_git_hooks.md`
4. `procedimiento_linting.md`
5. `procedimiento_ci_cd.md`
6. `testing-bats.md`
7. `procedimiento_creacion_features.md`
8. `procedimiento_desarrollo_local.md`

### Documentación Externa

- **Bash Scripting:** <https://www.gnu.org/software/bash/manual/>
- **BATS Testing:** <https://bats-core.readthedocs.io/>
- **Git Workflows:** <https://git-scm.com/book/en/v2>
- **Markdown:** <https://www.markdownguide.org/>

### Canales de Comunicación

- **GitHub Issues:** Para bugs y features
- **Pull Requests:** Para code reviews
- **Slack/Discord:** Para comunicación diaria (si aplica)
- **Daily Standups:** Horario y formato (si aplica)

## Checklist de Onboarding Completo

### Semana 1

- [ ] Acceso a GitHub configurado
- [ ] Repositorio clonado
- [ ] Todas las dependencias instaladas
- [ ] Git hooks instalados
- [ ] CI ejecutado exitosamente
- [ ] Documentación explorada
- [ ] Primera contribución mergeada

### Semana 2

- [ ] Test creado y ejecutado
- [ ] Feature completa implementada
- [ ] PR reviewed y merged
- [ ] Procedimientos entendidos
- [ ] Autonomía en tareas simples

### Mes 1

- [ ] Feature compleja implementada
- [ ] Participación activa en code reviews
- [ ] Contribución a documentación
- [ ] Resolución independiente de issues
- [ ] Mentoría a nuevos miembros (opcional)

## Preguntas Frecuentes (FAQ)

### ¿Qué hago si make check-deps falla?

Ver: `docs/procedimientos/procedimiento_verificacion_dependencias.md`

### ¿Cómo arreglo errores de git hooks?

Ver: `docs/procedimientos/procedimiento_git_hooks.md`

### ¿Puedo usar mi editor favorito?

Sí. VSCode, Vim, Emacs, etc. son todos compatibles.

### ¿Necesito usar Docker?

No es obligatorio, pero puede simplificar el setup.

### ¿Cómo pido ayuda?

1. Revisar documentación primero
2. Buscar en issues de GitHub
3. Preguntar en canal del equipo
4. Hacer pregunta específica con contexto

## Mentoring

### Tu Mentor

Durante las primeras semanas, tendrás asignado un mentor que:

- Responderá preguntas
- Revisará tus PRs
- Te guiará en tu primera feature
- Te ayudará con problemas técnicos

**Contactar a:** [Nombre del Mentor]

### Sesiones de Onboarding

- **Día 1:** Setup y overview (1 hora)
- **Día 3:** Deep dive técnico (1 hora)
- **Semana 2:** Review de progreso (30 min)
- **Mes 1:** Evaluación final (30 min)

## Próximos Pasos

Una vez completado el onboarding:

1. **Elegir primera feature real:**
   - Buscar issues con label `good-first-issue`
   - Asignar el issue a ti mismo
   - Seguir procedimiento de features

2. **Participar en code reviews:**
   - Revisar PRs de otros
   - Dar feedback constructivo
   - Aprender de reviews que recibes

3. **Contribuir a documentación:**
   - Mejorar procedimientos
   - Agregar ejemplos
   - Corregir errores

4. **Explorar áreas de interés:**
   - Testing
   - CI/CD
   - Documentación
   - Arquitectura

## Contactos

| Rol | Nombre | Contacto |
|-----|--------|----------|
| Tech Lead | [Nombre] | [Email/Slack] |
| DevOps | [Nombre] | [Email/Slack] |
| QA Lead | [Nombre] | [Email/Slack] |
| Project Manager | [Nombre] | [Email/Slack] |

## Feedback

Tu feedback sobre este proceso de onboarding es valioso.

Por favor, completar: [Encuesta de Onboarding] (enlace)

O crear issue: `feedback: onboarding experience`

---

¡Bienvenido al equipo! 🎉

## Historial de Cambios

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-11-03 | 1.0 | Creación inicial del procedimiento |
