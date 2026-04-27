# dotfiles

Modular dotfiles and machine setup scripts for Ubuntu/Debian systems.

## Quick Start

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
./setup.sh --all
```

Non-interactive (for automation):

```bash
GIT_USER_NAME="Your Name" GIT_USER_EMAIL="you@example.com" ./setup.sh --all --non-interactive
```

## Modules

Run all or pick specific modules:

```bash
./setup.sh base zsh git          # Only selected modules
./setup.sh --all                 # Everything
```

| Module | Description |
|--------|------------|
| `base` | Install essential packages, passwordless sudo, XDG directories |
| `git` | Git config from template (prompts for name/email) |
| `vim` | Vim config, molokai theme, vim-plug |
| `zsh` | Zsh, oh-my-zsh, plugins, shell configuration |
| `gnupg` | GnuPG config |
| `opencode` | OpenCode CLI |
| `xmodmap` | CapsLock → Mode_switch keyboard remap |
| `skills` | Install AI agent skills to Claude Code and OpenCode |

## Machine-Specific Configuration

Files that vary per machine are **not** tracked by git:

- `~/.config/zsh/env.local.zshrc` — API keys, local env vars (created from `zsh/env.local.zshrc.example`)
- `~/.config/git/config` — generated from `git/config.template` at setup time

## Project Structure

```
├── setup.sh              # Entry point
├── modules/              # One script per feature
├── git/config.template   # Git config with placeholders
├── vim/vimrc
├── gnupg/gpg.conf
├── zsh/                  # Shell configuration
│   ├── .zshrc            # Entry (copied to ~)
│   ├── default.zshrc     # oh-my-zsh + plugins (symlinked)
│   ├── alias.zshrc       # Aliases (symlinked)
│   ├── env.zshrc         # Environment variables (symlinked)
│   └── env.local.zshrc.example
├── skills/               # AI agent skills
├── xmodmap/.Xmodmap
└── .github/workflows/    # CI validation
```

## Dependencies

Only `git`, `wget`, and `sudo` are needed to bootstrap — the `base` module installs everything else.
