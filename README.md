# Dotfiles

## About
This repository contains my development environment dotfiles. I manage them with GNU Stow to create symlinks into $HOME, making it easy to keep multiple machines in sync.

## Requirements
- GNU Stow
- git
- zsh

On Debian/Ubuntu:
```bash
sudo apt update
sudo apt install -y stow git zsh
```

## WSL quick path (fresh instance)
Run these in order:

```bash
sudo apt update
sudo apt install -y stow git zsh
git clone https://github.com/charlesoscar/.dotfile ~/.dotfile
cd ~/.dotfile
stow -R zsh
~/.config/shell/bootstrap.sh
exec zsh
```

Optional (make zsh your default login shell):
```bash
chsh -s "$(which zsh)"
```

## Quick start
Recommended location:
```bash
git clone https://github.com/charlesoscar/.dotfile ~/.dotfile
cd ~/.dotfile
```

Link one or more packages into your home directory:
```bash
stow zsh
# or multiple
stow zsh git tmux nvim
```

Bootstrap shell plugins/theme explicitly (no network at zsh startup):
```bash
~/.config/shell/bootstrap.sh
```

If your repo is not directly under $HOME, specify a target:
```bash
stow -t "$HOME" zsh git tmux nvim
```

Unlink (remove symlinks):
```bash
stow -D zsh git tmux nvim
```

Re-link after changes:
```bash
stow -R zsh git tmux nvim
```

## Layout
Each package folder mirrors your home directory structure. Examples:
- `zsh/.zshrc` → `~/.zshrc`
- `zsh/.config/shell` → `~/.config/shell`
- `git/.gitconfig` → `~/.gitconfig`
- `nvim/.config/nvim` → `~/.config/nvim`

## Notes
- If Stow reports conflicts, move or back up existing files in $HOME, then run Stow again.
- Common conflicts on first setup: `~/.zshrc` and `~/.config/shell`.
