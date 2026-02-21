if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

_shell_config_dir="$HOME/.config/shell"

_shell_source_if_exists() {
  local file="$1"
  [[ -r "$file" ]] && source "$file"
}

_shell_source_if_exists "$_shell_config_dir/core.zsh"
_shell_source_if_exists "$_shell_config_dir/tools.zsh"
_shell_source_if_exists "$_shell_config_dir/plugins.zsh"
_shell_source_if_exists "$_shell_config_dir/prompt.zsh"

case "$(uname -s)" in
  Darwin)
    _shell_source_if_exists "$_shell_config_dir/mac.zsh"
    ;;
  Linux)
    _shell_source_if_exists "$_shell_config_dir/linux.zsh"
    ;;
esac

if [[ -e "$HOME/.work_shell" ]]; then
  _shell_source_if_exists "$_shell_config_dir/work.zsh"
fi

_shell_source_if_exists "$_shell_config_dir/local.zsh"

unset _shell_config_dir
unset -f _shell_source_if_exists

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.dotfile/zsh/.p10k.zsh.
[[ ! -f ~/.dotfile/zsh/.p10k.zsh ]] || source ~/.dotfile/zsh/.p10k.zsh
