---
name: dotfiles-setup
description: Use when the user wants to set up a new machine, install development tools, configure shell environment, manage dotfiles, or troubleshoot system configuration issues. Handles sudo, zsh, git, vim, opencode, GnuPG, and AI agent skill installation.
---

# Dotfiles Setup Skill

This skill helps set up and configure a fresh Linux machine using the dotfiles project.

## When to Use

- User mentions "set up machine", "new machine", "dotfiles", "system init"
- User wants to install zsh, oh-my-zsh, vim, opencode, or other dev tools
- User asks about shell configuration, environment variables, or git config
- User needs to configure passwordless sudo
- User wants to install or manage AI agent skills

## Prerequisites

The dotfiles repo should be cloned to `~/.dotfiles`:

```bash
git clone <repo-url> ~/.dotfiles
```

## Available Modules

Run all modules:

```bash
~/.dotfiles/setup.sh --all
```

Run specific modules:

```bash
~/.dotfiles/setup.sh base zsh git
```

Non-interactive mode (for automation):

```bash
GIT_USER_NAME="Your Name" GIT_USER_EMAIL="you@example.com" ~/.dotfiles/setup.sh --all --non-interactive
```

### Module Reference

| Module | What it does |
|--------|-------------|
| `base` | apt install essentials, passwordless sudo (`/etc/sudoers.d/$USER`), XDG dirs |
| `git` | Generate `~/.config/git/config` from template (prompts for name/email) |
| `vim` | Symlink vimrc, install molokai theme, vim-plug bootstraps on first launch |
| `zsh` | Install zsh + oh-my-zsh + plugins, deploy config, create `env.local.zshrc` |
| `gnupg` | Symlink gpg.conf |
| `opencode` | Install opencode CLI |
| `xmodmap` | CapsLock → Mode_switch for vim-like navigation |
| `skills` | Symlink skills to `~/.claude/skills/` and `~/.config/opencode/skills/` |

## Key Design Decisions

- **Sensitive data**: API keys go in `~/.config/zsh/env.local.zshrc` (gitignored), NOT in tracked files
- **Git config**: Uses a template with placeholders; real config is generated at setup time and gitignored
- **Idempotent**: Every module checks existing state before acting; safe to re-run
- **Per-machine customization**: `~/.zshrc` is copied (not symlinked), `env.local.zshrc` holds machine-specific vars

## Troubleshooting

If a module fails, run it individually with verbose output:

```bash
bash -x ~/.dotfiles/setup.sh zsh
```

Check if prerequisites are met:

```bash
~/.dotfiles/setup.sh base   # Run base first to install packages
```
