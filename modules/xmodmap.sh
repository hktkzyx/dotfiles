#!/usr/bin/env bash
# Module: xmodmap
# Set up X keyboard remapping (CapsLock as Mode_switch for vim-like navigation).

xmodmap_setup() {
    log_info "=== Xmodmap setup ==="

    if ! is_executable "xmodmap"; then
        log_info "xmodmap is not available. Skipping."
        return
    fi

    deploy_file "${DOTFILES_DIR}/xmodmap/.Xmodmap" "${HOME}/.Xmodmap" "link"
    log_info "Run 'xmodmap ~/.Xmodmap' to apply, or it will load on next X session."
}
