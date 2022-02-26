# system environment variables
export PATH="/snap/bin:/usr/local/bin:$HOME/bin:$HOME/.local/bin:$HOME/.poetry/bin:$PATH"

# XDG base directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# Zsh
export ZSH="$HOME/.oh-my-zsh"

# User defined
export MANPATH="/usr/local/man:$MANPATH"
export GPG_TTY=$(tty)