HISTFILE=${HISTFILE:-${ZDOTDIR:-$HOME}/.zsh_history}
HISTSIZE=50000
SAVEHIST=50000
setopt append_history share_history hist_ignore_dups hist_ignore_space
setopt auto_cd interactive_comments
export EDITOR=${EDITOR:-vim}
export VISUAL=${VISUAL:-$EDITOR}
# The prompt owns environment display.
export VIRTUAL_ENV_DISABLE_PROMPT=1
export CONDA_CHANGEPS1=false
