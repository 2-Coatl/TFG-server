.PHONY: help test lint lint-markdown lint-shell docs ci release clean install-hooks version

# Variables
SHELL := /bin/bash
ROOT_DIR := $(shell pwd)
SCRIPTS_DIR := $(ROOT_DIR)/scripts/bash
TEST_DIR := $(ROOT_DIR)/test
DOCS_DIR := $(ROOT_DIR)/docs

# Configuración
BATS_FILES := $(shell find $(TEST_DIR) -name "*.bats" 2>/dev/null)
SHELL_FILES := $(shell find $(SCRIPTS_DIR) -name "*.sh" 2>/dev/null)

# Colores para output
COLOR_RESET := \033[0m
COLOR_INFO := \033[36m
COLOR_SUCCESS := \033[32m
COLOR_ERROR := \033[31m

# Target por defecto
.DEFAULT_GOAL := help

## help: Muestra esta ayuda
help:
	@echo "Tareas disponibles:"
	@echo ""
	@grep -E '^## [a-zA-Z_-]+:' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = "## |:"}; {printf "  $(COLOR_INFO)%-15s$(COLOR_RESET) %s\n", $$2, $$3}'

## version: Muestra la versión del proyecto
version:
	@$(ROOT_DIR)/src/project.sh --version

## test: Ejecuta la suite de tests con BATS
test:
	@echo -e "$(COLOR_INFO)[test] Ejecutando suite de tests BATS...$(COLOR_RESET)"
	@if command -v bats >/dev/null 2>&1; then \
		bats $(TEST_DIR)/test.bats; \
		echo -e "$(COLOR_SUCCESS)[test] Tests completados$(COLOR_RESET)"; \
	else \
		echo -e "$(COLOR_ERROR)[test] ERROR: bats no está instalado$(COLOR_RESET)"; \
		exit 1; \
	fi

## lint: Ejecuta todos los linters (markdown + shell)
lint: lint-markdown lint-shell
	@echo -e "$(COLOR_SUCCESS)[lint] Linting completado$(COLOR_RESET)"

## lint-markdown: Valida archivos Markdown
lint-markdown:
	@echo -e "$(COLOR_INFO)[lint-markdown] Ejecutando markdownlint-cli2...$(COLOR_RESET)"
	@if command -v markdownlint-cli2 >/dev/null 2>&1; then \
		markdownlint-cli2 \
			"**/*.md" \
			"#docs/_site/**" \
			"#media/**" \
                        "#venv/**" \
			"#.venv/**" \
			"#node_modules/**"; \
	else \
		echo -e "$(COLOR_ERROR)[lint-markdown] ERROR: markdownlint-cli2 no está instalado$(COLOR_RESET)"; \
		exit 1; \
	fi

## lint-shell: Valida scripts de shell con shellcheck
lint-shell:
	@echo -e "$(COLOR_INFO)[lint-shell] Ejecutando shellcheck...$(COLOR_RESET)"
	@if command -v shellcheck >/dev/null 2>&1; then \
		find $(SCRIPTS_DIR) -name "*.sh" -print0 | xargs -0 -r shellcheck; \
		shellcheck $(ROOT_DIR)/src/project.sh; \
	else \
		echo -e "$(COLOR_ERROR)[lint-shell] ERROR: shellcheck no está instalado$(COLOR_RESET)"; \
		exit 1; \
	fi

## docs: Genera la documentación con DocFX
docs:
	@echo -e "$(COLOR_INFO)[docs] Generando documentación...$(COLOR_RESET)"
	@$(SCRIPTS_DIR)/build-docs.sh
	@echo -e "$(COLOR_SUCCESS)[docs] Documentación generada en docs/_site$(COLOR_RESET)"

## docs-serve: Genera y sirve la documentación localmente
docs-serve:
	@echo -e "$(COLOR_INFO)[docs-serve] Generando y sirviendo documentación...$(COLOR_RESET)"
	@$(SCRIPTS_DIR)/build-docs.sh --serve

## ci: Ejecuta el pipeline completo de CI (lint + test + docs)
ci:
	@echo -e "$(COLOR_INFO)[ci] Iniciando pipeline de CI local...$(COLOR_RESET)"
	@$(SCRIPTS_DIR)/ci-local.sh
	@echo -e "$(COLOR_SUCCESS)[ci] Pipeline CI completado$(COLOR_RESET)"

## release: Ejecuta el proceso de release
release:
	@echo -e "$(COLOR_INFO)[release] Iniciando proceso de release...$(COLOR_RESET)"
	@$(SCRIPTS_DIR)/release-local.sh
	@echo -e "$(COLOR_SUCCESS)[release] Release completado$(COLOR_RESET)"

## install-hooks: Instala los git hooks del proyecto
install-hooks:
	@echo -e "$(COLOR_INFO)[install-hooks] Instalando git hooks...$(COLOR_RESET)"
	@$(SCRIPTS_DIR)/spec-hooks-install.sh
	@echo -e "$(COLOR_SUCCESS)[install-hooks] Git hooks instalados$(COLOR_RESET)"

## clean: Limpia archivos generados y temporales
clean:
	@echo -e "$(COLOR_INFO)[clean] Limpiando archivos generados...$(COLOR_RESET)"
	@rm -rf $(DOCS_DIR)/_site
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -type d -name ".pytest_cache" -delete
	@echo -e "$(COLOR_SUCCESS)[clean] Limpieza completada$(COLOR_RESET)"

## check-deps: Verifica que todas las dependencias estén instaladas
check-deps:
	@echo -e "$(COLOR_INFO)[check-deps] Verificando dependencias...$(COLOR_RESET)"
	@missing=0; \
	for cmd in bats shellcheck markdownlint-cli2 docfx; do \
		if ! command -v $$cmd >/dev/null 2>&1; then \
			echo -e "$(COLOR_ERROR)  ✗ $$cmd no encontrado$(COLOR_RESET)"; \
			missing=$$((missing + 1)); \
		else \
			echo -e "$(COLOR_SUCCESS)  ✓ $$cmd$(COLOR_RESET)"; \
		fi; \
	done; \
	if [ $$missing -eq 0 ]; then \
		echo -e "$(COLOR_SUCCESS)[check-deps] Todas las dependencias están instaladas$(COLOR_RESET)"; \
	else \
		echo -e "$(COLOR_ERROR)[check-deps] Faltan $$missing dependencia(s)$(COLOR_RESET)"; \
		exit 1; \
	fi
