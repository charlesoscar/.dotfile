# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

##### POWERLEVEL10K INSTANT PROMPT (must be first) #############################
# Duplicate instant prompt removed; top block already sources it.

##### SHELL BASICS #############################################################
export EDITOR="code"
setopt auto_cd interactivecomments
setopt hist_ignore_all_dups share_history inc_append_history
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# Paths
# Prepend directories to PATH if they exist. `typeset -U path` will handle duplicates.
local -a path_dirs
path_dirs=(
  ~/.cargo/bin
  ~/.local/bin
  /opt/homebrew/bin  # For macOS
)

for dir in "${path_dirs[@]}"; do
  if [[ -d "$dir" ]]; then
    PATH="$dir:$PATH"
  fi
done
unset path_dirs
export PATH

##### PATH improvements ########################################################
# Optionally dedupe PATH entries while preserving order
typeset -U path

##### COMPLETION (deferred until after plugins) ################################
autoload -Uz compinit
zmodload zsh/complist
# fzf-tab works best without zsh's menucompletion. Disable it to let fzf capture
# the completion list and UI rendering.
unsetopt menucomplete

##### SAFE CORE ALIASES ########################################################
alias cp='cp -i'; alias mv='mv -i'; alias rm='rm -i'

# Enhanced ls commands
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias lt='ls -altrh --color=auto'  # Sort by time, newest last
alias lh='ls -alh --color=auto'    # Human readable sizes
alias tree='tree -C'               # Colorized tree if available

alias ..='cd ..'
alias ...='cd ../..'

# Prefer bat; if only batcat exists (Ubuntu), alias it as bat
command -v bat >/dev/null 2>&1 || { command -v batcat >/dev/null 2>&1 && alias bat='batcat'; }
# Pretty cat if bat is available
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --style=numbers,changes --pager=never'
fi
# Smarter grep when ripgrep is available
if command -v rg >/dev/null 2>&1; then
  alias grep='rg -n --smart-case --hidden --follow --glob "!.git"'
fi

##### FZF + FD + RIPGREP #######################################################
# Resolve a real fd/fdfind binary; aliases won't expand in subshells
if command -v fd >/dev/null 2>&1; then
  _fd_bin=fd
elif command -v fdfind >/dev/null 2>&1; then
  _fd_bin=fdfind
  alias fd='fdfind'
else
  _fd_bin=''
fi

if [[ -n $_fd_bin ]]; then
  export FZF_DEFAULT_COMMAND="$_fd_bin --type f --hidden --follow --exclude .git"
else
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
  --height 99%
  --layout=reverse
  --border
  --info=inline
  --preview-window=right:50%
  --preview="if [ -d {} ]; then ls -la --color=always {}; else (command -v bat >/dev/null && bat --style=numbers --color=always --line-range=1:300 {} || sed -n '\''1,300p'\'' {}); fi"
'
unset _fd_bin

# Load fzf key-bindings (prefer system on Linux, fallback to Homebrew)
if [[ -r /usr/share/fzf/shell/key-bindings.zsh ]]; then
  source /usr/share/fzf/shell/key-bindings.zsh
elif command -v brew >/dev/null 2>&1; then
  [[ -r "$(brew --prefix 2>/dev/null)/opt/fzf/shell/key-bindings.zsh" ]] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
fi
# Handy fuzzy helpers + keybindings
ff() { local f; f=$(fzf) && ${EDITOR:-vi} "$f"; }

# Search from $HOME, return absolute paths, and fall back to ripgrep if fd/fdfind is missing
_ff_pick_home_file() {
  local f
  if command -v fd >/dev/null 2>&1; then
    f=$(fd -a --type f --hidden --follow --exclude .git . "$HOME" 2>/dev/null | fzf) || return 1
  elif command -v fdfind >/dev/null 2>&1; then
    f=$(fdfind -a --type f --hidden --follow --exclude .git . "$HOME" 2>/dev/null | fzf) || return 1
  else
    f=$(rg --files --hidden --follow --glob "!.git" "$HOME" 2>/dev/null | fzf) || return 1
    [[ -n "$f" && "$f" != /* ]] && f="$HOME/$f"
  fi
  [[ -z "$f" ]] && return 1
  printf '%s\n' "$f"
}

ffh() {
  local f; f=$(_ff_pick_home_file) || return
  ${EDITOR:-vi} "$f"
}

fmv() {
  local f; f=$(_ff_pick_home_file) || return
  mv "$f" "${1:-.}"
}

fcp() {
  local f; f=$(_ff_pick_home_file) || return
  cp "$f" "${1:-.}"
}

frm()  { local f; f=$(fzf) && [ -n "$f" ] && rm -i "$f"; }
fh()   {
  local cmd
  cmd=$(print -r -l ${(u)history[@]} | fzf --tac --no-sort --no-preview | sed 's/^ *[0-9]\+ *//') || return
  [[ -z $cmd ]] && return
  print -s -- "$cmd"
  eval "$cmd"
}
fco()  { local br; br=$(git for-each-ref --format='%(refname:short)' refs/heads refs/tags | fzf) || return; git checkout "$br"; }
fkill(){
  local pid
  pid=$(ss -tulpn 2>/dev/null | sed 1d | fzf --no-preview | awk '{gsub(/.*pid=|,.*$/, ""); print $1}') || return
  [[ -z "$pid" ]] && return
  if ! kill "$pid"; then
    read -q "REPLY?SIGTERM failed. Send SIGKILL to $pid? (y/n) " && echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      kill -9 "$pid"
    fi
  else
    echo "SIGTERM sent to PID $pid."
  fi
}

bindkey -s '^r' 'fh\n'   # Ctrl-r: fuzzy search history

##### ZOXIDE (better cd) #######################################################
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd='z'
  cdbuiltin(){ builtin cd "$@"; }
fi

##### ANTIDOTE (PLUGIN MANAGER) ################################################
# Ensure Antidote exists
[[ -f ~/.antidote/antidote.zsh ]] || git clone --depth=1 https://github.com/mattmc3/antidote ~/.antidote
source ~/.antidote/antidote.zsh

# Load plugins from ~/.zsh_plugins.txt (create it if missing)
if [[ ! -f ~/.zsh_plugins.txt ]]; then
  cat > ~/.zsh_plugins.txt <<'PLUGS'
# Theme
~/.p10k

# Plugins
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
djui/alias-tips
ohmyzsh/ohmyzsh path:plugins/git
# Optional:
# zsh-vi-more/vi-more
# lukechilds/zsh-nvm
PLUGS
fi

# Bundle + load
antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh
source ~/.zsh_plugins.zsh

# Initialize completion after plugins are loaded (safer than compinit -u)
if compaudit_out=$(compaudit 2>/dev/null) && [[ -n $compaudit_out ]]; then
  : # run `compaudit` manually if needed; using secure compinit by default
fi
compinit -d ~/.zcompdump

# fzf-tab tweaks (after compinit and plugin load)
# Don't show zsh's own selection menu; let fzf-tab handle UI
zstyle ':completion:*' menu no
# Set descriptions format (avoid escape sequences – fzf-tab ignores them)
zstyle ':completion:*:descriptions' format '[%d]'
# Optional: enable filename colorizing in lists (used by fzf-tab preview)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Switch group with comma and dot
zstyle ':fzf-tab:*' switch-group ',' '.'

##### POWERLEVEL10K ############################################################
# Install theme repo if missing
[[ -d ~/.p10k ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.p10k
# User config (created by `p10k configure`)
[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh

##### GIT SHORTCUTS ############################################################
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit -v'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -n 30'

##### MISC QOL #################################################################
x(){ if [ -f "$1" ]; then case "$1" in
  *.tar.bz2) tar xjf "$1";; *.tar.gz) tar xzf "$1";; *.bz2) bunzip2 "$1";;
  *.rar) unrar x "$1";; *.gz) gunzip "$1";; *.tar) tar xf "$1";;
  *.tbz2) tar xjf "$1";; *.tgz) tar xzf "$1";; *.zip) unzip "$1";;
  *.Z) uncompress "$1";; *.7z) 7z x "$1";; *) echo "'$1' cannot be extracted via x()";;
esac else echo "'$1' is not a valid file"; fi }
alias serve='python3 -m http.server'
alias mark='zoxide add "$(pwd)"'
