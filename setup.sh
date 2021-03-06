#!/usr/bin/env bash
set -o errexit
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Error handler
err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

# Return whether a command is installed or not
is_executable() {
    command -v "$@" &>/dev/null
}

# Copy or make link dotfile
# $1 dotfile on the host
# $2 cp or ln command
cp_ln_action() {
    if [[ -e "$1" || -L "$1" ]]; then
        option="n"
        read -p "$1 exists. Override? (previous file will be backup) [y/n]:" -n 1 option
        echo
        if [[ "${option,,}" == "y" ]]; then
            mv "$1" "$1.backup"
            echo "Backup exist file to $1.backup"
            $2
        else
            echo "Skip setup $1"
        fi
    else
        $2
    fi
}

# Enable XDG base directory
xdg_base_directory_setup() {
    if [[ -z "${XDG_CONFIG_HOME}" ]]; then
        mkdir -p "${HOME}/.config"
        XDG_CONFIG_HOME="${HOME}/.config"
    fi
    if [[ -z "${XDG_CACHE_HOME}" ]]; then
        mkdir -p "${HOME}/.cache"
        XDG_CACHE_HOME="${HOME}/.cache"
    fi
    if [[ -z "${XDG_DATA_HOME}" ]]; then
        mkdir -p "${HOME}/.local/share"
        XDG_DATA_HOME="${HOME}/.local/share"
    fi
    if [[ -z "${XDG_STATE_HOME}" ]]; then
        mkdir -p "${HOME}/.local/state"
        XDG_STATE_HOME="${HOME}/.local/state"
    fi
}

# Git
git_setup() {
    if is_executable "git"; then
        mkdir -p "${XDG_CONFIG_HOME}/git"
        cp_ln_action "${XDG_CONFIG_HOME}/git/config" "cp ./git/config ${XDG_CONFIG_HOME}/git"
        option="n"
        read -p "Use VSCode instead of Vim as default editor? [y/n]" -n 1 option
        echo
        if [[ "${option,,}" == "y" ]]; then
            git config --global core.editor "code --wait"
        fi
    else
        err "git is not found"
        exit 1
    fi
}

# Check wget installed or not
ensure_wget_installed() {
    if is_executable "wget"; then
        echo "wget is installed"
    else
        err "wget is not installed"
        exit 1
    fi
}

# Vim
vim_setup() {
    if is_executable "vim"; then
        mkdir -p "${HOME}/.vim" "${HOME}/.vim/colors"
        cp_ln_action "${HOME}/.vim/vimrc" "ln -sv ${SCRIPT_DIR}/vim/vimrc ${HOME}/.vim"
        option="n"
        read -p "Update molokai.vim? [y/n]:" -n 1 option
        echo
        if [[ "${option,,}" == "y" ]]; then
            rm "${HOME}/.vim/colors/molokai.vim" || true
            wget -P "${HOME}/.vim/colors" "https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim"
        fi
    fi
}

# Zsh
zsh_setup() {
    if is_executable "zsh"; then
        echo "zsh is installed"
        if [[ ${SHELL:(-3)} != "zsh" ]]; then
            echo "Change default shell to zsh"
            chsh -s "$(which zsh)"
        fi
        option="n"
        read -p "Install/reinstall oh-my-zsh? [y/n]:" -n 1 option
        echo
        if [[ "${option,,}" == "y" ]]; then
            if [[ -d "${ZSH:-${HOME}/.oh-my-zsh}" ]]; then
                echo "Remove ${ZSH:-${HOME}/.oh-my-zsh}"
                rm -rf "${ZSH:-${HOME}/.oh-my-zsh}"
            fi
            ZSH="${XDG_DATA_HOME}/oh-my-zsh"
            ZSH_CUSTOM="${ZSH}/custom"
            ZSH_COMPDUMP="${ZSH_CACHE_DIR:-${ZSH}/cache}/.zcompdump"
            ZSH="${XDG_DATA_HOME}/oh-my-zsh" sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            git clone "https://github.com/chrissicool/zsh-256color" "${ZSH_CUSTOM}/plugins/zsh-256color"
            git clone "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
            git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
        fi
        cp_ln_action "${HOME}/.zshrc" "cp ./zsh/.zshrc ${HOME}"
        mkdir -p "${XDG_CONFIG_HOME}/zsh"
        cp_ln_action "${XDG_CONFIG_HOME}/zsh/default.zshrc" "ln -sv ${SCRIPT_DIR}/zsh/default.zshrc ${XDG_CONFIG_HOME}/zsh"
        cp_ln_action "${XDG_CONFIG_HOME}/zsh/alias.zshrc" "ln -sv ${SCRIPT_DIR}/zsh/alias.zshrc ${XDG_CONFIG_HOME}/zsh"
        cp_ln_action "${XDG_CONFIG_HOME}/zsh/env.zshrc" "ln -sv ${SCRIPT_DIR}/zsh/env.zshrc ${XDG_CONFIG_HOME}/zsh"
        exec zsh -l
    else
        err "zsh is not installed"
        exit 1
    fi
}

# GnuPG
gnupg_setup() {
    option="n"
    read -p "Setup GnuPG? [y/n]:" -n 1 option && echo
    if [[ "${option,,}" == "y" ]]; then
        if is_executable "gpg"; then
            mkdir -p "${HOME}/.gnupg"
            cp_ln_action "${HOME}/.gnupg/gpg.conf" "ln -sv ${SCRIPT_DIR}/gnupg/gpg.conf ${HOME}/.gnupg"
        else
            err "GnuPG is not installed."
            exit 1
        fi
    fi
}

main() {
    xdg_base_directory_setup
    git_setup
    ensure_wget_installed
    vim_setup
    # Optional setup
    gnupg_setup
    # Shell setup
    zsh_setup
}

main
