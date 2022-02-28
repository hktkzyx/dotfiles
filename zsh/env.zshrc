# system environment variables
export PATH="/snap/bin:/usr/local/bin:${HOME}/bin:${HOME}/.local/bin:${HOME}/.poetry/bin:${PATH}"

# XDG base directory
if [[ -z "${XDG_CONFIG_HOME}" ]]; then
    export XDG_CONFIG_HOME="${HOME}/.config"
fi
if [[ -z "${XDG_CACHE_HOME}" ]]; then
    export XDG_CACHE_HOME="${HOME}/.cache"
fi
if [[ -z "${XDG_DATA_HOME}" ]]; then
    export XDG_DATA_HOME="${HOME}/.local/share"
fi
if [[ -z "${XDG_STATE_HOME}" ]]; then
    export XDG_STATE_HOME="${HOME}/.local/state"
fi
if [[ -z "${XDG_DATA_DIRS}" ]]; then
    export XDG_DATA_DIRS="/usr/local/share:/usr/share"
fi
if [[ -z "${XDG_CONFIG_DIRS}" ]]; then
    export XDG_CONFIG_DIRS="/etc/xdg"
fi

# Zsh
export ZSH="${XDG_CONFIG_HOME}/zsh/oh-my-zsh"

# User defined
export MANPATH="/usr/local/man:${MANPATH}"
export GPG_TTY="$(tty)"
