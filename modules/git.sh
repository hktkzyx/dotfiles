#!/usr/bin/env bash
# Module: git
# Generate git config from template with user-provided values.

git_setup() {
    log_info "=== Git setup ==="

    if ! is_executable "git"; then
        log_error "git is not installed. Run base module first."
        return 1
    fi

    _generate_git_config
    _deploy_git_config
}

_generate_git_config() {
    local template="${DOTFILES_DIR}/git/config.template"
    local output="${DOTFILES_DIR}/git/config"

    if [[ ! -f "$template" ]]; then
        log_error "Git config template not found: ${template}"
        return 1
    fi

    # Read values from environment or prompt interactively
    local git_name="${GIT_USER_NAME:-}"
    local git_email="${GIT_USER_EMAIL:-}"
    local git_signing_key="${GIT_SIGNING_KEY:-}"

    if [[ -z "$git_name" ]]; then
        if [[ "$NON_INTERACTIVE" == "true" ]]; then
            log_error "GIT_USER_NAME not set. Set it or run interactively."
            return 1
        fi
        read -rp "Git user name: " git_name
    fi

    if [[ -z "$git_email" ]]; then
        if [[ "$NON_INTERACTIVE" == "true" ]]; then
            log_error "GIT_USER_EMAIL not set. Set it or run interactively."
            return 1
        fi
        read -rp "Git user email: " git_email
    fi

    if [[ -z "$git_signing_key" ]]; then
        git_signing_key="$git_email"
    fi

    sed -e "s/__GIT_USER_NAME__/${git_name}/" \
        -e "s/__GIT_USER_EMAIL__/${git_email}/" \
        -e "s/__GIT_SIGNING_KEY__/${git_signing_key}/" \
        "$template" > "$output"

    log_info "Git config generated."
}

_deploy_git_config() {
    local git_config_dir="${XDG_CONFIG_HOME}/git"
    mkdir -p "$git_config_dir"

    deploy_file "${DOTFILES_DIR}/git/config" "${git_config_dir}/config" "copy"

    # Optional: use vscode as editor
    if [[ "$NON_INTERACTIVE" != "true" ]]; then
        local option="n"
        read -rp "Use VSCode as default git editor? [y/N]: " -n 1 option
        echo
        if [[ "${option,,}" == "y" ]]; then
            git config --global core.editor "code --wait"
        fi
    fi
}
