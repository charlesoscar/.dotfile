autoload -Uz compinit compaudit
zmodload zsh/complist
unsetopt menucomplete

if [[ -r "$HOME/.antidote/antidote.zsh" ]]; then
  source "$HOME/.antidote/antidote.zsh"

  if [[ -r "$HOME/.zsh_plugins.txt" ]]; then
    if [[ ! -r "$HOME/.zsh_plugins.zsh" || "$HOME/.zsh_plugins.txt" -nt "$HOME/.zsh_plugins.zsh" ]]; then
      antidote bundle < "$HOME/.zsh_plugins.txt" > "$HOME/.zsh_plugins.zsh"
    fi

    [[ -r "$HOME/.zsh_plugins.zsh" ]] && source "$HOME/.zsh_plugins.zsh"
  fi
fi

if compaudit_out=$(compaudit 2>/dev/null) && [[ -n $compaudit_out ]]; then
  compinit -i -d "$HOME/.zcompdump"
else
  compinit -d "$HOME/.zcompdump"
fi

zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' switch-group ',' '.'
