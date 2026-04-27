#!/usr/bin/env bash
# Module: gnupg
# Set up GnuPG configuration.

gnupg_setup() {
    log_info "=== GnuPG setup ==="

    if ! is_executable "gpg"; then
        log_info "gpg is not installed. Skipping."
        return
    fi

    mkdir -p "${HOME}/.gnupg"
    chmod 700 "${HOME}/.gnupg"

    deploy_file "${DOTFILES_DIR}/gnupg/gpg.conf" "${HOME}/.gnupg/gpg.conf" "link"
}
