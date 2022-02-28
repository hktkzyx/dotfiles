source "${XDG_CONFIG_HOME:-${HOME}/.config}/zsh/env.zshrc"
source "${XDG_CONFIG_HOME:-${HOME}/.config}/zsh/alias.zshrc"
ZSH_THEME="ys"
plugins=(poetry docker docker-compose git z zsh-256color zsh-syntax-highlighting zsh-autosuggestions)
source "${ZSH}/oh-my-zsh.sh"
