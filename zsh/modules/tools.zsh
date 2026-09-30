# fzf >= 0.48: Ctrl-r history, Ctrl-t files, Alt-c directories, **<Tab> completion.
if [[ -n ${config_bins[fzf]} && -x ${config_bins[fzf]} ]]; then
  source <("${config_bins[fzf]}" --zsh)
fi
# Load after compinit/Oh My Zsh. z jumps; zi opens the fzf directory picker.
if [[ -n ${config_bins[zoxide]} && -x ${config_bins[zoxide]} ]]; then
  eval "$("${config_bins[zoxide]}" init zsh)"
fi
