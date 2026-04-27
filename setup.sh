#!/usr/bin/env bash
set -o errexit
set -o pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
export DOTFILES_DIR

# --- Logging ---
log_info() { echo "[INFO] $*"; }
log_error() { echo "[ERROR] $*" >&2; }

# --- Utilities ---
is_executable() { command -v "$@" &>/dev/null; }

# Deploy a file: copy or symlink, with backup if target exists
# Usage: deploy_file <source> <target> <copy|link>
deploy_file() {
    local src="$1" target="$2" mode="$3"

    if [[ -e "$target" || -L "$target" ]]; then
        if [[ "$mode" == "link" && -L "$target" && "$(readlink -f "$target")" == "$(readlink -f "$src")" ]]; then
            log_info "Already linked: ${target}"
            return
        fi
        if [[ "$NON_INTERACTIVE" == "true" ]]; then
            mv "$target" "${target}.backup"
            log_info "Backed up existing ${target}"
        else
            local option="n"
            read -rp "${target} exists. Override? (backup will be created) [y/N]: " -n 1 option
            echo
            if [[ "${option,,}" != "y" ]]; then
                log_info "Skipped: ${target}"
                return
            fi
            mv "$target" "${target}.backup"
            log_info "Backed up to ${target}.backup"
        fi
    fi

    case "$mode" in
        copy) cp "$src" "$target" && log_info "Copied: ${target}" ;;
        link) ln -sv "$src" "$target" && log_info "Linked: ${target}" ;;
        *) log_error "Unknown deploy mode: ${mode}" ;;
    esac
}

# --- Load modules ---
for mod in "${DOTFILES_DIR}"/modules/*.sh; do
    # shellcheck source=/dev/null
    source "$mod"
done

# --- Available modules (in dependency order) ---
ALL_MODULES=(base git vim zsh gnupg opencode xmodmap skills)

show_usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [MODULES...]

Set up a fresh machine with dotfiles and tools.

Options:
  --all              Run all modules in order
  --non-interactive  Skip all interactive prompts (requires env vars for git)
  -h, --help         Show this help

Available modules:
  base       Essential packages, passwordless sudo, XDG directories
  git        Git configuration (from template)
  vim        Vim config and color scheme
  zsh        Zsh, oh-my-zsh, plugins, and shell config
  gnupg      GnuPG configuration
  opencode   OpenCode CLI
  xmodmap    X keyboard remapping
  skills     Install AI agent skills (Claude Code, OpenCode)

Examples:
  ./setup.sh --all                           # Full setup
  ./setup.sh base zsh git                    # Only selected modules
  ./setup.sh --all --non-interactive         # Unattended (set GIT_USER_NAME, GIT_USER_EMAIL)
EOF
}

# --- Main ---
main() {
    local modules=()
    export NON_INTERACTIVE="false"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --all)
                modules=("${ALL_MODULES[@]}")
                shift ;;
            --non-interactive)
                export NON_INTERACTIVE="true"
                shift ;;
            -h|--help)
                show_usage
                exit 0 ;;
            -*)
                log_error "Unknown option: $1"
                show_usage
                exit 1 ;;
            *)
                modules+=("$1")
                shift ;;
        esac
    done

    if [[ ${#modules[@]} -eq 0 ]]; then
        show_usage
        exit 1
    fi

    log_info "Dotfiles directory: ${DOTFILES_DIR}"
    log_info "Modules to run: ${modules[*]}"
    echo

    for mod in "${modules[@]}"; do
        case "$mod" in
            base)    base_setup ;;
            git)     git_setup ;;
            vim)     vim_setup ;;
            zsh)     zsh_setup ;;
            gnupg)   gnupg_setup ;;
            opencode) opencode_setup ;;
            xmodmap) xmodmap_setup ;;
            skills)  skills_setup ;;
            *)
                log_error "Unknown module: ${mod}"
                show_usage
                exit 1 ;;
        esac
        echo
    done

    log_info "Setup complete!"
}

main "$@"
