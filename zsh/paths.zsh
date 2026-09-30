# Native tools need no Node/Python runtime. Prefer PATH; pin paths in paths.local.zsh.
typeset -U path
for _config_bin_dir in /opt/homebrew/bin /usr/local/bin "$HOME/.local/bin"; do
  [[ ! -d $_config_bin_dir ]] || path+=("$_config_bin_dir")
done
unset _config_bin_dir

typeset -gA config_bins
config_bins=(
  git "${commands[git]:-}"
  fzf "${commands[fzf]:-}"
  zoxide "${commands[zoxide]:-}"
)
export ZSH=${ZSH:-$HOME/.oh-my-zsh}
[[ ! -r "$ZSH_CONFIG_DIR/paths.local.zsh" ]] || source "$ZSH_CONFIG_DIR/paths.local.zsh"
[[ -z ${ZSH_CONFIG_PROFILE_DIR:-} || ! -r "$ZSH_CONFIG_PROFILE_DIR/paths.zsh" ]] || source "$ZSH_CONFIG_PROFILE_DIR/paths.zsh"

# Generated integrations also call tools by name. Put pinned directories on PATH.
for _config_tool in git fzf zoxide; do
  if [[ -n ${config_bins[$_config_tool]} && -x ${config_bins[$_config_tool]} ]]; then
    path=("${config_bins[$_config_tool]:h}" $path)
  fi
done
unset _config_tool
