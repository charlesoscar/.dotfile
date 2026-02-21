alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias ..='cd ..'
alias ...='cd ../..'

command -v bat >/dev/null 2>&1 || {
  command -v batcat >/dev/null 2>&1 && alias bat='batcat'
}

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --style=numbers,changes --pager=never'
fi

if command -v rg >/dev/null 2>&1; then
  alias grep='rg -n --smart-case --hidden --follow --glob "!.git"'
fi

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

if [[ -r /usr/share/fzf/shell/key-bindings.zsh ]]; then
  source /usr/share/fzf/shell/key-bindings.zsh
elif [[ -r /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
elif [[ -r /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
fi

ff() { local f; f=$(fzf) && ${EDITOR:-vi} "$f"; }

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

frm() {
  local f
  f=$(fzf) && [[ -n "$f" ]] && rm -i "$f"
}

fh() {
  local cmd
  cmd=$(print -r -l ${(u)history[@]} | fzf --tac --no-sort --no-preview | sed 's/^ *[0-9]\+ *//') || return
  [[ -z $cmd ]] && return
  print -s -- "$cmd"
  eval "$cmd"
}

fco() {
  local br
  br=$(git for-each-ref --format='%(refname:short)' refs/heads refs/tags | fzf) || return
  git checkout "$br"
}

fkill() {
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

bindkey -s '^r' 'fh\n'

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd='z'
  cdbuiltin() {
    builtin cd "$@"
  }
fi

alias gs='git status -sb'
alias ga='git add'
alias gc='git commit -v'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -n 30'

x() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar)
        if command -v unrar >/dev/null 2>&1; then
          unrar x "$1"
        elif command -v unar >/dev/null 2>&1; then
          unar "$1"
        else
          echo "Install unrar or unar to extract .rar files"
          return 1
        fi
        ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "'$1' cannot be extracted via x()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

alias serve='python3 -m http.server'
alias mark='zoxide add "$(pwd)"'
