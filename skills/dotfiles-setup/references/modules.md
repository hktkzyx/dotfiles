# Module Reference

## Dependency Order

`base` → `git` → `vim` → `zsh` → `gnupg` → `opencode` → `xmodmap` → `skills`

`base` should always run first as it installs packages needed by other modules.

## Module Details

### base (modules/base.sh)
- Installs: curl, wget, git, zsh, vim, gpg
- Configures passwordless sudo via `/etc/sudoers.d/$USER`
- Creates XDG base directories and exports variables

### git (modules/git.sh)
- Reads `git/config.template`, replaces `__GIT_USER_NAME__`, `__GIT_USER_EMAIL__`, `__GIT_SIGNING_KEY__`
- Interactive: prompts for values; Non-interactive: reads from `GIT_USER_NAME`, `GIT_USER_EMAIL` env vars
- Generated `git/config` is gitignored

### vim (modules/vim.sh)
- Symlinks vimrc to `~/.vim/vimrc`
- Downloads molokai color scheme
- vim-plug auto-installs on first vim launch

### zsh (modules/zsh.sh)
- Installs zsh if missing, sets as default shell
- Installs oh-my-zsh to `$XDG_DATA_HOME/oh-my-zsh`
- Installs plugins: zsh-256color, zsh-autosuggestions, zsh-syntax-highlighting
- Config layout:
  - `~/.zshrc` (copied, per-machine)
  - `~/.config/zsh/default.zshrc` (symlinked, tracked)
  - `~/.config/zsh/alias.zshrc` (symlinked, tracked)
  - `~/.config/zsh/env.zshrc` (symlinked, tracked)
  - `~/.config/zsh/env.local.zshrc` (created from example, gitignored)

### gnupg (modules/gnupg.sh)
- Symlinks gpg.conf to `~/.gnupg/gpg.conf`

### opencode (modules/opencode.sh)
- Installs opencode CLI

### xmodmap (modules/xmodmap.sh)
- Symlinks .Xmodmap for CapsLock → Mode_switch navigation

### skills (modules/skills.sh)
- Symlinks each directory under `skills/` to `~/.claude/skills/` and `~/.config/opencode/skills/`
