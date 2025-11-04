#!/usr/bin/env bash
#
# Name: install-git-hooks.sh
# Description: Install git hooks for Shell Script validation
# Usage: install-git-hooks.sh [OPTIONS]
# Options:
#   -h, --help     Show this help message
#   -f, --force    Force reinstall (overwrite existing hooks)
#
# This script installs git hooks that enforce Shell Scripting Standards:
# - ADR 0005: docs/diseno_solucion/arquitectura_sistemas/adr/0005-estandar-shell-scripting.md
# - Guide: docs/gobernanza/estandares/shell-scripting-guide.md

set -euo pipefail

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
readonly GIT_HOOKS_DIR="$PROJECT_ROOT/.git/hooks"
readonly HOOKS_SOURCE_DIR="$PROJECT_ROOT/infrastructure/hooks"

FORCE=false

# -----------------------------------------------------------------------------
# LOGGING
# -----------------------------------------------------------------------------

log_info() {
    printf '[INFO] %s\n' "$*"
}

log_error() {
    printf '[ERROR] %s\n' "$*" >&2
}

log_success() {
    printf '[SUCCESS] %s\n' "$*"
}

# -----------------------------------------------------------------------------
# VALIDATION
# -----------------------------------------------------------------------------

validate_git_repo() {
    if [ ! -d "$PROJECT_ROOT/.git" ]; then
        log_error "Not a git repository: $PROJECT_ROOT"
        log_error "Please run this script from within a git repository"
        exit 1
    fi
}

validate_hooks_exist() {
    if [ ! -d "$HOOKS_SOURCE_DIR" ]; then
        log_error "Hooks source directory not found: $HOOKS_SOURCE_DIR"
        exit 1
    fi
}

# -----------------------------------------------------------------------------
# INSTALLATION FUNCTIONS
# -----------------------------------------------------------------------------

install_hook() {
    local hook_source="$1"
    local hook_name="$2"
    local hook_target="$GIT_HOOKS_DIR/$hook_name"

    # Check if hook already exists
    if [ -f "$hook_target" ] && [ "$FORCE" = false ]; then
        log_info "Hook already exists: $hook_name (use --force to overwrite)"
        return 0
    fi

    # Create symlink to hook
    log_info "Installing hook: $hook_name"
    ln -sf "$hook_source" "$hook_target"
    chmod +x "$hook_target"

    log_success "Installed: $hook_name"
}

# -----------------------------------------------------------------------------
# MAIN LOGIC
# -----------------------------------------------------------------------------

main() {
    log_info "Git Hooks Installation"
    printf '\n'

    # Validate
    validate_git_repo
    validate_hooks_exist

    # Ensure .git/hooks directory exists
    mkdir -p "$GIT_HOOKS_DIR"

    # Install pre-commit hook for shellcheck
    if [ -f "$HOOKS_SOURCE_DIR/pre-commit-shellcheck" ]; then
        install_hook "$HOOKS_SOURCE_DIR/pre-commit-shellcheck" "pre-commit"
    else
        log_error "Pre-commit hook not found: $HOOKS_SOURCE_DIR/pre-commit-shellcheck"
        exit 1
    fi

    printf '\n'
    log_success "Git hooks installed successfully"
    printf '\n'
    log_info "Installed hooks:"
    log_info "  - pre-commit: Validates shell scripts with ShellCheck"
    printf '\n'
    log_info "To bypass hooks (not recommended): git commit --no-verify"
    log_info "To uninstall: rm .git/hooks/pre-commit"
}

# -----------------------------------------------------------------------------
# ARGUMENT PARSING
# -----------------------------------------------------------------------------

show_help() {
    cat << 'EOF'
Git Hooks Installation Script

Installs git hooks for Shell Script validation.

USAGE:
    install-git-hooks.sh [OPTIONS]

OPTIONS:
    -h, --help     Show this help message
    -f, --force    Force reinstall (overwrite existing hooks)

EXAMPLES:
    # Install hooks
    ./scripts/bash/install-git-hooks.sh

    # Force reinstall
    ./scripts/bash/install-git-hooks.sh --force

HOOKS INSTALLED:
    pre-commit     Validates shell scripts with ShellCheck

SEE ALSO:
    docs/gobernanza/estandares/shell-scripting-guide.md
    docs/diseno_solucion/arquitectura_sistemas/adr/0005-estandar-shell-scripting.md
EOF
    exit 0
}

parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                show_help
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                printf 'Run with --help for usage information\n' >&2
                exit 2
                ;;
        esac
    done
}

# -----------------------------------------------------------------------------
# ENTRY POINT
# -----------------------------------------------------------------------------

parse_args "$@"
main
