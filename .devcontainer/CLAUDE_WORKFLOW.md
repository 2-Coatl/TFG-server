# Flujo de Trabajo de Claude - CHECKLIST OBLIGATORIO

Este archivo contiene el checklist que Claude DEBE seguir en CADA sesión cuando hace cambios al código o documentación.

## ⚠️ REGLA DE ORO: SIEMPRE EJECUTAR `make ci`

Según `docs/procedimientos/procedimiento_desarrollo_local.md`, **ANTES de hacer commit**, Claude DEBE:

```bash
make ci
```

Este comando ejecuta:
1. **Lint**: Valida código Shell y Markdown
2. **Test**: Ejecuta suite BATS y shUnit2
3. **Docs**: Genera documentación con MkDocs

## Checklist Obligatorio por Tipo de Cambio

### 📝 Cambios en Documentación (*.md, docs/)

- [ ] 1. Hacer cambios en archivos
- [ ] 2. **EJECUTAR**: `make docs` (genera MkDocs)
- [ ] 3. Verificar que `docs/_site` se generó correctamente
- [ ] 4. Commit con los cambios + documentación generada
- [ ] 5. Push

### 🔧 Cambios en Código Shell (*.sh, scripts/)

- [ ] 1. Hacer cambios en scripts
- [ ] 2. Crear/actualizar tests en `test/`
- [ ] 3. **EJECUTAR**: `make lint-shell` (shellcheck)
- [ ] 4. **EJECUTAR**: `make test-all` (BATS + shUnit2)
- [ ] 5. **EJECUTAR**: `make docs` (actualizar documentación)
- [ ] 6. Commit con todos los cambios
- [ ] 7. Push

### 🏗️ Cambios en Infraestructura (.devcontainer/, Makefile, etc.)

- [ ] 1. Hacer cambios
- [ ] 2. Actualizar ADR si corresponde (`docs/diseno_solucion/arquitectura_sistemas/adr/`)
- [ ] 3. Actualizar documentación técnica
- [ ] 4. **EJECUTAR**: `make ci` (pipeline completo)
- [ ] 5. Commit + Push

### 🧪 Solo Tests (test/)

- [ ] 1. Crear/modificar tests
- [ ] 2. **EJECUTAR**: `make test-all`
- [ ] 3. Verificar que todos los tests pasan
- [ ] 4. **EJECUTAR**: `make docs` (actualizar doc de tests)
- [ ] 5. Commit + Push

## 🚨 RECORDATORIO PERMANENTE

**NUNCA hacer commit sin ejecutar el pipeline correspondiente**

Si las herramientas no están instaladas:
1. Indicar al usuario que debe ejecutar `make ci` localmente antes de merge
2. Mencionar en el mensaje de commit: "⚠️ Requiere ejecutar 'make ci' antes de merge"
3. Actualizar el TODO con este recordatorio

## Comando Rápido de Verificación

```bash
# Verificar estado del proyecto
make check-deps   # Ver qué herramientas faltan
git status        # Ver archivos modificados
make ci           # Ejecutar pipeline completo
```

## Integración con TODO

Cada vez que Claude hace cambios, debe agregar al TODO:

```
- [ ] Ejecutar make ci antes de merge final
```

Y marcarlo solo cuando se haya ejecutado exitosamente.

---

**Este archivo es un contrato entre Claude y el equipo de desarrollo para mantener la calidad del proyecto.**
