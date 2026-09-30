ZSH_THEME=""
plugins=(git)
# Use Oh My Zsh's default update cadence, independent of this repository.
zstyle ':omz:update' mode auto
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  autoload -Uz compinit
  compinit
fi
