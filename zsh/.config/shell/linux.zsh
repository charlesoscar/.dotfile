alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias lt='ls -altrh --color=auto'
alias lh='ls -alh --color=auto'
alias tree='tree -C'

if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  alias open='wslview'
fi
