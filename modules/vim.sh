#!/usr/bin/env bash
# Module: vim
# Set up vim configuration and color scheme.

vim_setup() {
    log_info "=== Vim setup ==="

    if ! is_executable "vim"; then
        log_info "vim is not installed. Skipping."
        return
    fi

    mkdir -p "${HOME}/.vim" "${HOME}/.vim/colors"

    deploy_file "${DOTFILES_DIR}/vim/vimrc" "${HOME}/.vim/vimrc" "link"

    _install_molokai_theme
}

_install_molokai_theme() {
    local theme_path="${HOME}/.vim/colors/molokai.vim"

    if [[ -f "$theme_path" ]]; then
        log_info "Molokai theme already installed."
        return
    fi

    log_info "Downloading molokai color scheme..."
    wget -qP "${HOME}/.vim/colors" "https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim"
}
