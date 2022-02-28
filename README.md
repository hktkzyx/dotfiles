# dotfiles

This project contains my dotfiles and the automatic setup shell script.

## Installation

Git clone this repository to `~/.dotfiles` or other directory you want.

```python
git clone https://github.com/hktkzyx/dotfiles.git ~/.dotfiles
```

## Dependencies

- git
- vim
- wget
- zsh

## Usage

First, change the user info in [git/config](https://github.com/hktkzyx/dotfiles/blob/main/git/config).
Then, change the permission of shell script [setup.sh](https://github.com/hktkzyx/dotfiles/blob/main/setup.sh).

```bash
chmod u+x ~/.dotfiles/setup.sh
```

Finally, execute the shell script [setup.sh](https://github.com/hktkzyx/dotfiles/blob/main/setup.sh).

```bash
cd ~/.dotfiles
./setup.sh
```
