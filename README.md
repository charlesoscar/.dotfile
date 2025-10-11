# Dotfiles

## About
This repository contains my development environment dotfiles. I manage them with GNU Stow to create symlinks into $HOME, making it easy to keep multiple machines in sync.

## Requirements
- GNU Stow
- git

On Debian/Ubuntu:
```bash
sudo apt update
sudo apt install -y stow git
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
- `git/.gitconfig` → `~/.gitconfig`
- `nvim/.config/nvim` → `~/.config/nvim`

## Notes
- If Stow reports conflicts, move or back up existing files in $HOME, then run Stow again.
