#!/usr/bin/env bash
# Module: opencode
# Install opencode CLI (standalone binary).

opencode_setup() {
    log_info "=== OpenCode setup ==="

    _install_opencode
    _ensure_opencode_path
}

_install_opencode() {
    if is_executable "opencode"; then
        log_info "opencode already installed: $(opencode --version)"
        return
    fi

    log_info "Installing opencode..."
    curl -fsSL https://opencode.ai/install | bash
}

_ensure_opencode_path() {
    local opencode_bin="${HOME}/.opencode/bin"

    if [[ ! -d "$opencode_bin" ]]; then
        log_info "opencode bin directory not found, skipping PATH setup."
        return
    fi

    # Add to local zsh config if not already present
    local local_config="${XDG_CONFIG_HOME}/zsh/env.local.zshrc"
    if [[ -f "$local_config" ]] && grep -q ".opencode/bin" "$local_config"; then
        log_info "opencode PATH already configured."
        return
    fi

    if [[ -f "$local_config" ]]; then
        log_info "Adding opencode to PATH in ${local_config}..."
        # shellcheck disable=SC2016
        printf '\n# opencode\nexport PATH="%s:${PATH}"\n' "$opencode_bin" >> "$local_config"
    else
        log_info "Note: Add 'export PATH=${opencode_bin}:\$PATH' to your shell config."
    fi
}
