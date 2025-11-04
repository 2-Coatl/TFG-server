#!/usr/bin/env bash
#
# Name: validate-shell-scripts.sh
# Description: Validate all shell scripts against Shell Scripting Guide v2.1
# Usage: validate-shell-scripts.sh [OPTIONS] [DIRECTORY]
# Options:
#   -h, --help         Show this help message
#   -v, --verbose      Enable verbose output
#   -s, --strict       Fail on warnings (not just errors)
#   -f, --fix          Automatically fix permissions
# Examples:
#   validate-shell-scripts.sh
#   validate-shell-scripts.sh --verbose scripts/
#   validate-shell-scripts.sh --strict --fix
#
# Dependencies: shellcheck, find
# Exit Codes:
#   0 - All scripts valid
#   1 - Validation errors found
#   2 - Invalid arguments

set -euo pipefail

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly VERSION="1.0.0"

# Default values
VERBOSE=false
STRICT=false
FIX_PERMISSIONS=false
TARGET_DIR="${1:-.}"

# Counters
TOTAL_SCRIPTS=0
VALID_SCRIPTS=0
INVALID_SCRIPTS=0
WARNINGS=0

# -----------------------------------------------------------------------------
# LOGGING FUNCTIONS
# -----------------------------------------------------------------------------

log_info() {
    printf '[INFO] %s\n' "$*"
}

log_error() {
    printf '[ERROR] %s\n' "$*" >&2
}

log_warn() {
    printf '[WARN] %s\n' "$*"
    WARNINGS=$((WARNINGS + 1))
}

log_debug() {
    if [ "$VERBOSE" = true ]; then
        printf '[DEBUG] %s\n' "$*"
    fi
}

log_success() {
    printf '[SUCCESS] %s\n' "$*"
}

log_fail() {
    printf '[FAIL] %s\n' "$*"
    INVALID_SCRIPTS=$((INVALID_SCRIPTS + 1))
}

# -----------------------------------------------------------------------------
# VALIDATION FUNCTIONS
# -----------------------------------------------------------------------------

# Validate shebang line
validate_shebang() {
    local file="$1"
    local shebang

    if [ ! -s "$file" ]; then
        log_fail "$file: Empty file"
        return 1
    fi

    shebang=$(head -n1 "$file")

    case "$shebang" in
        "#!/usr/bin/env sh"|"#!/usr/bin/env bash"|"#!/bin/sh"|"#!/bin/bash")
            log_debug "$file: Valid shebang: $shebang"
            return 0
            ;;
        *)
            log_fail "$file: Invalid or missing shebang: ${shebang:-<empty>}"
            log_info "  Expected: #!/usr/bin/env bash or #!/usr/bin/env sh"
            return 1
            ;;
    esac
}

# Validate file is executable
validate_executable() {
    local file="$1"

    if [ ! -x "$file" ]; then
        if [ "$FIX_PERMISSIONS" = true ]; then
            log_warn "$file: Not executable, fixing..."
            chmod +x "$file"
            log_info "  Fixed: Made file executable"
            return 0
        else
            log_fail "$file: Not executable (use --fix to auto-fix)"
            log_info "  Run: chmod +x $file"
            return 1
        fi
    fi

    log_debug "$file: Executable permission OK"
    return 0
}

# Validate script header documentation
validate_documentation() {
    local file="$1"
    local has_description=false
    local has_usage=false

    # Check for description comment in first 20 lines
    if head -n 20 "$file" | grep -qE '^#.*[Dd]escription:|^# .*:'; then
        has_description=true
    fi

    # Check for usage comment
    if head -n 20 "$file" | grep -qE '^#.*[Uu]sage:|^# [Uu]sage:'; then
        has_usage=true
    fi

    if [ "$has_description" = false ] || [ "$has_usage" = false ]; then
        log_warn "$file: Missing documentation header"
        [ "$has_description" = false ] && log_info "  Missing: Description comment"
        [ "$has_usage" = false ] && log_info "  Missing: Usage comment"

        if [ "$STRICT" = true ]; then
            log_fail "$file: Documentation required in strict mode"
            return 1
        fi
        return 0
    fi

    log_debug "$file: Documentation OK"
    return 0
}

# Validate error handling (set -e, set -u, set -euo pipefail)
validate_error_handling() {
    local file="$1"
    local shebang
    local has_set_e=false
    local has_set_u=false
    local has_pipefail=false

    shebang=$(head -n1 "$file")

    # Check for set -e or set -eu or set -euo pipefail
    if grep -qE '^set -[a-z]*e' "$file"; then
        has_set_e=true
        log_debug "$file: Has 'set -e'"
    fi

    if grep -qE '^set -[a-z]*u' "$file"; then
        has_set_u=true
        log_debug "$file: Has 'set -u'"
    fi

    if grep -qE '^set -[a-z]*o pipefail' "$file"; then
        has_pipefail=true
        log_debug "$file: Has 'set -o pipefail'"
    fi

    # For bash scripts, recommend pipefail
    if [[ "$shebang" == *"bash"* ]] && [ "$has_pipefail" = false ]; then
        log_warn "$file: Bash script without 'set -o pipefail'"
        log_info "  Recommended: set -euo pipefail"
    fi

    # For POSIX sh, pipefail is not available
    if [[ "$shebang" == *"/sh"* ]] && [ "$has_pipefail" = true ]; then
        log_warn "$file: POSIX sh script uses 'set -o pipefail' (not portable)"
        log_info "  Note: pipefail is not in POSIX standard"
    fi

    # At minimum, should have set -e
    if [ "$has_set_e" = false ]; then
        log_fail "$file: Missing 'set -e' (minimum error handling)"
        log_info "  Add: set -eu (POSIX) or set -euo pipefail (bash)"
        return 1
    fi

    log_debug "$file: Error handling OK"
    return 0
}

# Run ShellCheck
run_shellcheck() {
    local file="$1"

    if ! command -v shellcheck >/dev/null 2>&1; then
        log_warn "ShellCheck not installed, skipping static analysis"
        log_info "  Install: apt-get install shellcheck (or brew install shellcheck)"
        return 0
    fi

    log_debug "$file: Running ShellCheck"

    local severity="error"
    [ "$STRICT" = true ] && severity="warning"

    if shellcheck --severity="$severity" "$file" 2>&1 | grep -v "^$"; then
        log_fail "$file: ShellCheck found issues"
        return 1
    fi

    log_debug "$file: ShellCheck passed"
    return 0
}

# Validate a single script file
validate_script() {
    local file="$1"
    local status=0

    TOTAL_SCRIPTS=$((TOTAL_SCRIPTS + 1))

    log_info "Validating: $file"

    # Run all validations
    validate_shebang "$file" || status=1
    validate_executable "$file" || status=1
    validate_documentation "$file" || status=1
    validate_error_handling "$file" || status=1
    run_shellcheck "$file" || status=1

    if [ $status -eq 0 ]; then
        VALID_SCRIPTS=$((VALID_SCRIPTS + 1))
        log_success "$file: All checks passed"
    else
        log_error "$file: Validation failed"
    fi

    printf '\n'
    return $status
}

# -----------------------------------------------------------------------------
# SUMMARY REPORT
# -----------------------------------------------------------------------------

print_summary() {
    printf '\n'
    printf '============================================\n'
    printf 'Shell Script Validation Summary\n'
    printf '============================================\n'
    printf 'Total scripts checked:   %d\n' "$TOTAL_SCRIPTS"
    printf 'Valid scripts:           %d\n' "$VALID_SCRIPTS"
    printf 'Invalid scripts:         %d\n' "$INVALID_SCRIPTS"
    printf 'Warnings:                %d\n' "$WARNINGS"
    printf '============================================\n'
    printf '\n'

    if [ $INVALID_SCRIPTS -eq 0 ]; then
        if [ $WARNINGS -eq 0 ]; then
            printf 'Status: [SUCCESS] All scripts are compliant\n'
            return 0
        elif [ "$STRICT" = true ]; then
            printf 'Status: [FAIL] Scripts have warnings (strict mode)\n'
            return 1
        else
            printf 'Status: [SUCCESS] All scripts passed (with warnings)\n'
            printf '\n'
            printf 'Note: Run with --strict to treat warnings as errors\n'
            return 0
        fi
    else
        printf 'Status: [FAIL] Found %d invalid script(s)\n' "$INVALID_SCRIPTS"
        printf '\n'
        printf 'Please fix the issues above and run validation again.\n'
        printf 'See: docs/gobernanza/estandares/shell-scripting-guide.md\n'
        return 1
    fi
}

# -----------------------------------------------------------------------------
# HELPER FUNCTIONS
# -----------------------------------------------------------------------------

show_help() {
    cat << 'EOF'
Shell Script Validator v1.0.0

Validates shell scripts against Shell Scripting Guide v2.1

USAGE:
    validate-shell-scripts.sh [OPTIONS] [DIRECTORY]

OPTIONS:
    -h, --help         Show this help message
    -v, --verbose      Enable verbose output
    -s, --strict       Fail on warnings (not just errors)
    -f, --fix          Automatically fix permissions

ARGUMENTS:
    DIRECTORY          Directory to search for scripts (default: current)

EXAMPLES:
    # Validate all scripts in current directory
    validate-shell-scripts.sh

    # Validate specific directory with verbose output
    validate-shell-scripts.sh --verbose scripts/

    # Strict validation with auto-fix
    validate-shell-scripts.sh --strict --fix

EXIT CODES:
    0 - All scripts valid
    1 - Validation errors found
    2 - Invalid arguments

REQUIREMENTS:
    - shellcheck (recommended): Install with apt/brew
    - find, grep, head (standard Unix tools)

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
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -s|--strict)
                STRICT=true
                shift
                ;;
            -f|--fix)
                FIX_PERMISSIONS=true
                shift
                ;;
            -*)
                log_error "Unknown option: $1"
                printf 'Run with --help for usage information\n' >&2
                exit 2
                ;;
            *)
                TARGET_DIR="$1"
                shift
                ;;
        esac
    done
}

# -----------------------------------------------------------------------------
# MAIN LOGIC
# -----------------------------------------------------------------------------

main() {
    log_info "Shell Script Validator v$VERSION"
    log_info "Target: $TARGET_DIR"
    [ "$VERBOSE" = true ] && log_info "Verbose mode: ON"
    [ "$STRICT" = true ] && log_info "Strict mode: ON"
    [ "$FIX_PERMISSIONS" = true ] && log_info "Auto-fix: ON"
    printf '\n'

    # Validate target directory
    if [ ! -d "$TARGET_DIR" ]; then
        log_error "Directory not found: $TARGET_DIR"
        exit 2
    fi

    # Find all .sh files
    log_info "Searching for shell scripts in: $TARGET_DIR"
    printf '\n'

    local failed=0
    while IFS= read -r -d '' file; do
        if ! validate_script "$file"; then
            failed=1
        fi
    done < <(find "$TARGET_DIR" -type f -name "*.sh" -print0 2>/dev/null | sort -z)

    # Check if no scripts were found
    if [ $TOTAL_SCRIPTS -eq 0 ]; then
        log_warn "No shell scripts (.sh) found in: $TARGET_DIR"
        printf '\n'
        printf 'If you have scripts without .sh extension, add the extension\n'
        printf 'or run this validator on individual files.\n'
        exit 0
    fi

    # Print summary
    if ! print_summary; then
        exit 1
    fi

    exit 0
}

# -----------------------------------------------------------------------------
# ENTRY POINT
# -----------------------------------------------------------------------------

parse_args "$@"
main
