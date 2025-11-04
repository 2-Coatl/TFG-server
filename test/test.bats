#!/usr/bin/env bats

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR/../src:$PATH"
}

@test "muestra la versión del proyecto" {
    run project.sh --version
    assert_success
    assert_output --partial "TFG"
}

@test "estructura documental reorganizada" {
    project_root="${DIR}/.."

    [[ ! -d "${project_root}/memory" ]]
    [[ ! -d "${project_root}/templates" ]]

    [[ -f "${project_root}/docs/gobernanza/baselines/constitution.md" ]]
    [[ -d "${project_root}/docs/gobernanza/planificacion" ]]
    [[ -f "${project_root}/docs/gobernanza/planificacion/roadmap.md" ]]

    [[ -d "${project_root}/docs/plantillas/nivel_3_tareas/gestion_agentes" ]]
    [[ -f "${project_root}/docs/plantillas/nivel_3_tareas/gestion_agentes/agent-file-template.md" ]]
    [[ -d "${project_root}/docs/plantillas/nivel_3_tareas/gestion_agentes/commands" ]]

    [[ -f "${project_root}/docs/automation/migracion-github-actions.md" ]]
    [[ -f "${project_root}/docs/implementacion/backend/guias_desarrollo/spec-driven-development.md" ]]
}

@test "estructura MCP implementada correctamente" {
    project_root="${DIR}/.."

    # Servidor y librería MCP
    [[ -f "${project_root}/.devcontainer/mcp/server.sh" ]]
    [[ -x "${project_root}/.devcontainer/mcp/server.sh" ]]
    [[ -f "${project_root}/.devcontainer/mcp/lib/mcp-common.sh" ]]

    # Herramientas MCP
    [[ -f "${project_root}/.devcontainer/mcp/tools/analyze-requirements.sh" ]]
    [[ -f "${project_root}/.devcontainer/mcp/tools/run-ci.sh" ]]
    [[ -f "${project_root}/.devcontainer/mcp/tools/scan-shell.sh" ]]
    [[ -f "${project_root}/.devcontainer/mcp/tools/list-governance.sh" ]]
    [[ -f "${project_root}/.devcontainer/mcp/tools/validate-structure.sh" ]]

    # Documentación MCP
    [[ -f "${project_root}/.devcontainer/mcp/README.md" ]]
    [[ -f "${project_root}/docs/diseno_solucion/arquitectura_sistemas/adr/0003-servidor-mcp-shell.md" ]]
    [[ -f "${project_root}/docs/implementacion/infrastructure/mcp-server.md" ]]

    # Configuración devcontainer
    grep -q "mcp.servers" "${project_root}/.devcontainer/devcontainer.json"
}
