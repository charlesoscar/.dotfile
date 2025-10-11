# Zsh configuration: fast, fuzzy, friendly

This setup aims for a snappy shell with smart defaults, rich completions, and fuzzy-powered workflows. It combines Powerlevel10k for a clean, fast prompt, Antidote for speedy plugin loading, and deep `fzf` integration.

## Highlights

- Instant prompt and lean theme via Powerlevel10k.
- Fuzzy everything: file search, history, git branches, process kill.
- Sensible safety defaults (`cp`, `mv`, `rm` are interactive).
- Ergonomic key bindings: Tab is context-aware; Ctrl-r opens fuzzy history.
- Minimal PATH boilerplate with de-dupe.

## Plugins (managed by Antidote)

Listed in `~/.zsh_plugins.txt` and bundled by Antidote:

- `zsh-users/zsh-autosuggestions` — inline history-based suggestions.
- `zsh-users/zsh-syntax-highlighting` — command-line syntax highlighting.
- `Aloxaf/fzf-tab` — fuzzy completion UI for Tab.
- `djui/alias-tips` — suggests existing aliases as you type.
- `ohmyzsh/ohmyzsh path:plugins/git` — extra git aliases/functions.

Optional entries are commented in `~/.zsh_plugins.txt` (e.g., `zsh-vi-more`, `zsh-nvm`).

## Prompt: Powerlevel10k

- Instant prompt enabled at the top of `~/.zshrc` to minimize startup latency.
- Theme repo auto-installed at `~/.p10k` if missing; user config lives in `~/.p10k.zsh`.
- Reconfigure anytime with: `p10k configure`.

## Completion and key bindings

- `compinit` is run securely; `fzf-tab` styles are applied:
  - `zstyle ':completion:*' menu yes select`
  - `zstyle ':completion:*:descriptions' format '%F{yellow} -- %d -- %f'`
  - `zstyle ':fzf-tab:*' switch-group ',' '.'`
- Tab (`^I`) is bound to a custom widget `ls_or_complete` in both Emacs and Vi insert modes:
  - If the command line is empty: print a newline and `ls -alF` (colorized), then refresh the prompt.
  - Otherwise: try to accept an autosuggestion; if none, trigger `fzf-tab` when available, else default completion.
- Ctrl-r is bound to `fh` (fuzzy search in history).

## History

- Large, shared history across sessions with immediate append.
  - Options: `hist_ignore_all_dups`, `share_history`, `inc_append_history`.
  - Files/limits: `HISTFILE=~/.zsh_history`, `HISTSIZE=100000`, `SAVEHIST=100000`.

## PATH handling

- A small allowlist prepends common user bins (deduped with `typeset -U path`):
  - `~/.cargo/bin`, `~/.local/bin`, `/opt/homebrew/bin` (macOS/Homebrew).

## Fuzzy search and helpers

Environment:

- `FZF_DEFAULT_COMMAND` prefers `fd`/`fdfind`, falls back to `rg --files`.
- `FZF_DEFAULT_OPTS` configures a reverse layout, borders, and rich preview (uses `bat` when available, falls back to `sed`).
- System `fzf` key bindings are sourced when found.

Functions:

- `ls_or_complete` — context-aware Tab behavior (see “Completion and key bindings”).
- `ff` — pick a file with `fzf` and open it in `$EDITOR`.
- `ffh` — fuzzy-pick a file anywhere under `$HOME` and open in `$EDITOR` (uses `fd`/`fdfind`/`rg`).
- `fmv` — fuzzy-pick a file under `$HOME` and move it to the current or given directory.
- `fcp` — fuzzy-pick a file under `$HOME` and copy it to the current or given directory.
- `frm` — fuzzy-pick a file and remove it interactively.
- `fh` — fuzzy-search command history; the chosen command is added back to history and executed.
- `fco` — fuzzy-pick a git branch or tag and `git checkout` it.
- `fkill` — list sockets with `ss -tulpn`, fuzzy-pick a PID, send SIGTERM; optionally confirm SIGKILL if needed.
- `x` — universal extractor for `.tar.gz`, `.tgz`, `.zip`, `.rar`, `.7z`, `.Z`, `.bz2`, `.tar.bz2`, etc.
- `serve` — quick static HTTP server in the current directory via `python3 -m http.server`.
- `mark` — add the current directory to zoxide’s database (`zoxide add "$PWD"`).

## Aliases

- Safety: `alias cp='cp -i'`, `alias mv='mv -i'`, `alias rm='rm -i'`.
- Navigation: `..` → `cd ..`, `...` → `cd ../..`.
- Lists: `ls` (color), `ll`, `la`, `l`, `lt` (time), `lh` (human), `tree -C`.
- Git: `gs`, `ga`, `gc`, `gp`, `gl`.
- Tool upgrades (conditional): `cat` → `bat` (if present), `grep` → `rg` (if present).
- Zoxide: `cd` is replaced by `z` (when zoxide is installed); `cdbuiltin` provides access to the original builtin `cd`.

## Zoxide integration (better cd)

If `zoxide` is present, it’s initialized and `cd` is aliased to `z` for fast directory jumping. Use `mark` to bookmark the current directory. Use `cdbuiltin` when you need the original `cd` behavior.

## Dependencies

Core:

- zsh ≥ 5.1, git
- fzf
- One of: `fd` or `fdfind` (recommended), else `ripgrep` as fallback for file lists
- `bat`/`batcat` (optional, for previews)
- `zoxide` (optional, for smarter `cd`)
- `tree` (optional)
- `python3` (for `serve` alias)
- `iproute2` (for `ss`, used by `fkill`)
- Archive tools for `x`: `tar`, `gzip`, `bzip2`, `unzip`, `p7zip`/`7z`, `unrar`, `ncompress` (for `.Z`)

On Debian/Ubuntu (examples):

```bash
sudo apt update
sudo apt install zsh git fzf fd-find ripgrep bat tree zoxide python3 iproute2 p7zip-full unzip unrar ncompress
# Make `bat` and `fd` names consistent
[[ -x /usr/bin/batcat ]] && sudo update-alternatives --install /usr/local/bin/bat bat /usr/bin/batcat 10
[[ -x /usr/bin/fdfind ]] && sudo update-alternatives --install /usr/local/bin/fd fd /usr/bin/fdfind 10
```

On macOS (Homebrew):

```bash
brew install zsh git fzf fd ripgrep bat tree zoxide python p7zip unzip
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
```

## Quick start

1) Ensure dependencies you want are installed (see above).
2) Symlink or copy these files:

- `zsh/.zshrc` → `~/.zshrc`
- `zsh/.zsh_plugins.txt` → `~/.zsh_plugins.txt`
- `zsh/.p10k.zsh` → `~/.p10k.zsh` (optional; will be used if present)

3) Start a new shell. The first run will auto-install Antidote and Powerlevel10k (if missing) and bundle plugins.

## Notes & troubleshooting

- If `compaudit` reports insecure directories, fix them or run `compaudit` manually. This config avoids `compinit -u` for safety.
- `ff`/`ffh` use `$EDITOR` (defaults to `vi` if `EDITOR` is unset). Set `EDITOR` to your preferred editor, e.g., `code`.
- If `fzf-tab` isn’t affecting completion, ensure the plugin is bundled and loaded; the custom Tab binding is re-applied after plugin load.
- On Ubuntu, `bat` is named `batcat` and `fd` is `fdfind`. The README shows how to standardize names.

