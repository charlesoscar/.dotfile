typeset -U path PATH

local -a _mac_paths
_mac_paths=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
)

for _dir in "${_mac_paths[@]}"; do
  [[ -d "$_dir" ]] && path=("$_dir" $path)
done

unset _mac_paths _dir
export PATH

alias ls='ls -G'
alias ll='ls -alFG'
alias la='ls -AG'
alias l='ls -CFG'
alias lt='ls -altrhG'
alias lh='ls -alhG'
alias tree='tree -C'
