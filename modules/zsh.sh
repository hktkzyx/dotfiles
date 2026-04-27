#!/usr/bin/env bash
# Module: zsh
# Install zsh, oh-my-zsh, plugins, and deploy configuration files.

zsh_setup() {
    log_info "=== Zsh setup ==="

    _ensure_zsh_installed
    _set_default_shell
    _install_oh_my_zsh
    _install_zsh_plugins
    _deploy_zsh_config
}

_ensure_zsh_installed() {
    if is_executable "zsh"; then
        log_info "zsh is already installed."
        return
    fi

    log_info "Installing zsh..."
    sudo apt-get install -y -qq zsh
}

_set_default_shell() {
    if [[ "${SHELL##*/}" == "zsh" ]]; then
        log_info "Default shell is already zsh."
        return
    fi

    log_info "Changing default shell to zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
}

_install_oh_my_zsh() {
    local omz_dir="${XDG_DATA_HOME}/oh-my-zsh"

    if [[ -d "$omz_dir" ]]; then
        log_info "oh-my-zsh already installed at ${omz_dir}."
        return
    fi

    log_info "Installing oh-my-zsh..."
    ZSH="$omz_dir" sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

_install_zsh_plugins() {
    local omz_custom="${XDG_DATA_HOME}/oh-my-zsh/custom"

    local -A plugins=(
        [zsh-256color]="https://github.com/chrissicool/zsh-256color"
        [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
        [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    )

    for name in "${!plugins[@]}"; do
        local dest="${omz_custom}/plugins/${name}"
        if [[ -d "$dest" ]]; then
            log_info "Plugin ${name} already installed."
        else
            log_info "Installing plugin ${name}..."
            git clone --depth 1 "${plugins[$name]}" "$dest"
        fi
    done
}

_deploy_zsh_config() {
    local zsh_config_dir="${XDG_CONFIG_HOME}/zsh"
    mkdir -p "$zsh_config_dir"

    # .zshrc: copy to home (user may customize per-machine)
    deploy_file "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc" "copy"

    # Config files: symlink (tracked by git)
    deploy_file "${DOTFILES_DIR}/zsh/default.zshrc" "${zsh_config_dir}/default.zshrc" "link"
    deploy_file "${DOTFILES_DIR}/zsh/alias.zshrc" "${zsh_config_dir}/alias.zshrc" "link"
    deploy_file "${DOTFILES_DIR}/zsh/env.zshrc" "${zsh_config_dir}/env.zshrc" "link"

    # Local config: create from example if not exists
    local local_config="${zsh_config_dir}/env.local.zshrc"
    if [[ ! -f "$local_config" ]]; then
        log_info "Creating ${local_config} from example template..."
        cp "${DOTFILES_DIR}/zsh/env.local.zshrc.example" "$local_config"
        log_info "Edit ${local_config} to add machine-specific environment variables."
    fi
}
