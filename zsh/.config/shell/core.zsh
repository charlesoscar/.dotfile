export EDITOR="code"

setopt auto_cd interactivecomments
setopt hist_ignore_all_dups share_history inc_append_history

HISTSIZE=100000
SAVEHIST=100000
HISTFILE="$HOME/.zsh_history"

typeset -U path PATH

local -a _path_prepend
_path_prepend=(
  "$HOME/.cargo/bin"
  "$HOME/.local/bin"
)

for _dir in "${_path_prepend[@]}"; do
  [[ -d "$_dir" ]] && path=("$_dir" $path)
done

unset _path_prepend _dir
export PATH
