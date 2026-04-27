#!/usr/bin/env bash
# Module: base
# Install essential packages, configure passwordless sudo, and set up XDG directories.

base_setup() {
    log_info "=== Base setup ==="

    _install_packages
    _setup_passwordless_sudo
    _setup_xdg_directories
}

_install_packages() {
    log_info "Installing essential packages..."
    local packages=(curl wget git zsh vim gpg)
    local to_install=()

    for pkg in "${packages[@]}"; do
        if ! dpkg -s "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -eq 0 ]]; then
        log_info "All essential packages already installed."
        return
    fi

    log_info "Installing: ${to_install[*]}"
    sudo apt-get update -qq
    sudo apt-get install -y -qq "${to_install[@]}"
}

_setup_passwordless_sudo() {
    local sudoers_file="/etc/sudoers.d/${USER}"

    if sudo test -f "$sudoers_file"; then
        log_info "Passwordless sudo already configured for ${USER}."
        return
    fi

    log_info "Configuring passwordless sudo for ${USER}..."
    local rule="${USER} ALL=(ALL:ALL) NOPASSWD: ALL"

    # Write to a temp file, validate with visudo, then move into place
    local tmpfile
    tmpfile=$(mktemp)
    echo "$rule" > "$tmpfile"
    chmod 0440 "$tmpfile"

    if sudo visudo -cf "$tmpfile" &>/dev/null; then
        sudo install -o root -g root -m 0440 "$tmpfile" "$sudoers_file"
        rm -f "$tmpfile"
        log_info "Passwordless sudo configured."
    else
        rm -f "$tmpfile"
        log_error "Failed to validate sudoers rule. Skipping."
    fi
}

_setup_xdg_directories() {
    log_info "Setting up XDG directories..."
    mkdir -p "${HOME}/.config" "${HOME}/.cache" "${HOME}/.local/share" "${HOME}/.local/state"

    export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
    export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
    export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
    export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"
}
