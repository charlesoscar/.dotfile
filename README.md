# Dotfiles: zsh setup

This repository contains my zsh configuration. It’s optimized for speed, fuzzy search, and a clean prompt. Use the Makefile only to install prerequisites; link files with GNU Stow manually (instructions below).

If you want the nitty‑gritty details of the zsh config itself, see `zsh/README.md`.

## What you get
# Dotfiles: setup (personal; zsh + others)
- Powerlevel10k prompt (fast and configurable)
- Antidote plugin manager (fast startup)
- Fuzzy helpers and previews via fzf + fd/rg + bat
This repository is for my own machines. It manages my zsh setup and can hold other dotfiles (git, tmux, nvim, terminal, etc.). The Makefile helps me install zsh safely and repeatably; the layout also supports adding and linking more configs.
If you want the nitty‑gritty details of the zsh config itself, see `zsh/README.md`.
- Optional zoxide integration for smarter `cd`

## What you get

- Zsh setup:
	- Powerlevel10k prompt (fast and configurable)
	- Antidote plugin manager (fast startup)
	- Fuzzy helpers and previews via fzf + fd/rg + bat
	- Sensible aliases and history handling
	- Optional zoxide integration for smarter `cd`
- Extensible dotfiles layout: add more subfolders (e.g., `git/`, `tmux/`, `nvim/`, `alacritty/`) and link them into `$HOME` manually or with GNU Stow (optional).
```bash
sudo apt update
# Make `bat` and `fd` names consistent (optional but helpful)
[[ -x /usr/bin/batcat ]] && sudo update-alternatives --install /usr/local/bin/bat bat /usr/bin/batcat 10
2) Back up any existing files and link the zsh dotfiles into your HOME, then bootstrap plugins and theme:
```

- link: creates zsh-related symlinks from this repo to your HOME

## Step-by-step (Makefile)
The Makefile automates backups, symlinks, and bootstrapping plugins/theme.
# Symlink zsh files from this repo (adjust path if necessary)
# Dotfiles: setup (personal; zsh + others)

This repository is for my own machines. It manages my zsh setup and can hold other dotfiles (git, tmux, nvim, terminal, etc.). The Makefile helps install zsh safely and repeatably; the layout also supports adding and linking more configs.

For deeper details of the zsh config itself, see `zsh/README.md`.

## What you get

- Zsh setup:
  - Powerlevel10k prompt (fast and configurable)
  - Antidote plugin manager (fast startup)
  - Fuzzy helpers and previews via fzf + fd/rg + bat
  - Sensible aliases and history handling
  - Optional zoxide integration for smarter `cd`
- Extensible dotfiles layout: add more subfolders (e.g., `git/`, `tmux/`, `nvim/`, `alacritty/`) and link them into `$HOME` manually or with GNU Stow (optional).

## Prerequisites

- zsh, git
- Recommended CLI tools: fzf, fd (or fdfind), ripgrep, bat (or batcat), tree, zoxide, python3, iproute2, p7zip/unzip/unrar

On Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y zsh git fzf fd-find ripgrep bat tree zoxide python3 iproute2 p7zip-full unzip unrar ncompress
# Make `bat` and `fd` names consistent (optional but helpful)
[[ -x /usr/bin/batcat ]] && sudo update-alternatives --install /usr/local/bin/bat bat /usr/bin/batcat 10
[[ -x /usr/bin/fdfind ]] && sudo update-alternatives --install /usr/local/bin/fd fd /usr/bin/fdfind 10
```

Nerd Font for prompt icons (optional but recommended):
- Install a Nerd Font (e.g., MesloLGS NF, FiraCode Nerd Font) and select it in your terminal profile.

## Step-by-step

The Makefile is intentionally minimal and only installs prerequisites. Use GNU Stow to create symlinks, then bootstrap zsh.

1) Install prerequisites:

```bash
make deps
```

2) (Optional) Make zsh your default shell:

```bash
make default-shell
```

3) Start a new terminal or run an interactive zsh once to finish plugin bundling and instant prompt cache:

```bash
zsh -ic 'true'
```

5) Configure Powerlevel10k prompt (optional):

```bash
zsh -ic 'p10k configure'
```

6) Verify everything:

```bash
zsh --version
```

## What “install” does

- backup: copies existing `~/.zshrc`, `~/.zsh_plugins.txt`, and `~/.p10k.zsh` into `~/.dotfile_backup/<timestamp>` if they exist
- link: creates zsh-related symlinks from this repo to your HOME
- bootstrap: ensures Antidote (plugin manager) and Powerlevel10k theme repos are cloned to `~/.antidote` and `~/.p10k`
- bundle: triggers plugin bundling once by invoking an interactive zsh startup
- verify: runs a few sanity checks

No destructive changes are made to your existing files without a backup. Symlinks are force-updated to point to this repo.

## Link dotfiles with GNU Stow (manual)

Organize each tool in its own folder using real home-relative paths inside, then run stow from the repo root. Example for zsh and others:

```bash
mkdir -p ~/.dotfile_backup
cp -a ~/.zshrc ~/.zsh_plugins.txt ~/.p10k.zsh 2>/dev/null ~/.dotfile_backup/ || true

# Install stow (Debian/Ubuntu)
sudo apt install -y stow

# From repo root, stow one or more packages
stow zsh
# stow git tmux nvim alacritty
```

(Optionally) change your default shell:

```bash
chsh -s "$(command -v zsh)"
```

## Managing additional dotfiles (beyond zsh)

This repo can hold more than zsh. Mirror home paths under subfolders to keep things tidy. Examples:

- `git/.gitconfig` → `~/.gitconfig`
- `tmux/.tmux.conf` → `~/.tmux.conf`
- `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`
- `alacritty/.config/alacritty/alacritty.yml` → `~/.config/alacritty/alacritty.yml`

Link them with Stow from the repo root, e.g.:

```bash
stow git tmux nvim alacritty
```

To remove links:

```bash
stow -D git tmux nvim alacritty
```

## Troubleshooting

- Missing icons/garbled prompt: switch your terminal font to a Nerd Font.
- fzf-tab not showing: ensure plugins bundled correctly (`~/.zsh_plugins.zsh` exists) and restart the shell.
- compaudit warnings: fix insecure directories, or run `compaudit` to see details. This setup avoids `compinit -u` by default.
- Ubuntu-specific names: if `fd` or `bat` not found, check `fdfind`/`batcat` or use the `update-alternatives` lines above.
- For non-zsh dotfiles, if a symlink doesn’t appear to work, verify the target exists in the repo, parent directories in `$HOME` are created (e.g., `~/.config/...`), and the symlink points to the right path (`ls -l`).

## Structure

- `zsh/.zshrc` → main zsh configuration
- `zsh/.zsh_plugins.txt` → plugin list read by Antidote
- `zsh/.p10k.zsh` → Powerlevel10k prompt config (optional)
- `zsh/README.md` → deeper details about functions and tweaks
- `git/.gitconfig` (optional) → global git config
- `tmux/.tmux.conf` (optional) → tmux config
- `nvim/.config/nvim` (optional) → Neovim configuration
- `alacritty/.config/alacritty` (optional) → terminal config
