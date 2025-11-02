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
