# Zsh configuration: layered, cross-platform

This setup uses a loader-only `~/.zshrc` and modular files under `~/.config/shell`.

## Load order

1. Powerlevel10k instant prompt
2. `core.zsh`
3. `tools.zsh`
4. `plugins.zsh`
5. `prompt.zsh`
6. Platform layer (`mac.zsh` or `linux.zsh`)
7. Optional `work.zsh` (only when `~/.work_shell` exists)
8. Optional `local.zsh`

## File responsibilities

- `core.zsh` — shell options, history, editor, deterministic PATH framework.
- `tools.zsh` — aliases, helper functions, `fzf` helpers, `zoxide`, git shortcuts.
- `plugins.zsh` — Antidote/plugin bundle loading and `compinit` + completion styles.
- `prompt.zsh` — loads `~/.p10k.zsh`.
- `mac.zsh` — macOS paths and BSD-compatible `ls` aliases.
- `linux.zsh` — Linux/WSL paths and GNU-style `ls` aliases.
- `work.zsh` — work-only settings (opt-in).
- `local.zsh` — private overrides (not tracked by git).

## Runtime guarantees

- No network access during shell startup.
- No install or `git clone` actions during shell startup.
- PATH is managed through zsh `path` array with de-duplication.
- `~/.config/shell` is leaf-symlinked (via `--no-folding` in `.stowrc`), so other apps writing to `~/.config/` never touch the repo.

## Install shell tools

From the repo root, install all recommended CLI tools used by this zsh setup (fzf, fd/fdfind, ripgrep, bat, tree, zoxide, python3, archive tools, stow, etc.):

```bash
cd ~/.dotfile
make deps
```

## Bootstrap (run explicitly)

Use this once on a new machine (or when re-provisioning plugins/theme):

```bash
~/.config/shell/bootstrap.sh
```

Bootstrap installs:

- `~/.antidote` (if missing)
- `~/.p10k` (if missing)
- `~/.zsh_plugins.zsh` (bundled from `~/.zsh_plugins.txt`)

## Set zsh as default shell (WSL)

On new WSL environments, set zsh as the login shell:

```bash
chsh -s "$(which zsh)"
```

Then close all WSL sessions and start WSL again.

Verify:

```bash
echo "$SHELL"
echo "$0"
```

Fallback if `chsh` does not persist in your WSL distro:

```bash
grep -q 'exec zsh' ~/.profile || echo '[[ $- == *i* ]] && exec zsh' >> ~/.profile
```

## Work toggle

Enable work layer:

```bash
touch ~/.work_shell
```

Disable work layer:

```bash
rm -f ~/.work_shell
```

## Existing behavior preserved

- `fzf` helpers: `ff`, `ffh`, `fmv`, `fcp`, `frm`, `fh`, `fco`, `fkill`
- `zoxide` integration (`cd` → `z`, `cdbuiltin` fallback)
- git aliases (`gs`, `ga`, `gc`, `gp`, `gl`)
- history settings and completion UX
- Powerlevel10k prompt via `~/.p10k.zsh`
