# Build data before prompt expansion; escape % in branch and environment names.
# No language runtime is launched just to draw the prompt.
_config_prompt() {
  local git_bin=${config_bins[git]} branch root git_dir common_dir dirty value
  local -a envs
  typeset -g config_prompt_git='' config_prompt_env=''
  if [[ -n $git_bin && -x $git_bin ]] && root=$("$git_bin" rev-parse --show-toplevel 2>/dev/null); then
    branch=$("$git_bin" symbolic-ref --quiet --short HEAD 2>/dev/null) || branch=$("$git_bin" rev-parse --short HEAD 2>/dev/null)
    git_dir=$("$git_bin" rev-parse --git-dir 2>/dev/null)
    common_dir=$("$git_bin" rev-parse --git-common-dir 2>/dev/null)
    dirty=$("$git_bin" status --porcelain --ignore-submodules=dirty 2>/dev/null)
    value="git:$branch"
    [[ $git_dir == $common_dir ]] || value+=" wt:${root:t}"
    [[ -z $dirty ]] || value+=' *'
    config_prompt_git=" %F{magenta}${value//\%/%%}%f"
  fi
  if [[ -n ${VIRTUAL_ENV:-} ]]; then
    envs+=("py:${VIRTUAL_ENV:t}")
  elif [[ -n ${CONDA_DEFAULT_ENV:-} ]]; then
    envs+=("conda:$CONDA_DEFAULT_ENV")
  elif [[ -n ${PYENV_VERSION:-} ]]; then
    envs+=("py:$PYENV_VERSION")
  fi
  [[ -z ${NVM_BIN:-} ]] || envs+=("node:${${NVM_BIN:h}:t}")
  [[ -z ${RBENV_VERSION:-} ]] || envs+=("ruby:$RBENV_VERSION")
  [[ -z ${IN_NIX_SHELL:-} ]] || envs+=("nix:$IN_NIX_SHELL")
  [[ -z ${DIRENV_DIR:-} ]] || envs+=(direnv)
  value="${(j: :)envs}"
  [[ -z $value ]] || config_prompt_env=" %F{yellow}[${value//\%/%%}]%f"
  return 0
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _config_prompt
setopt prompt_subst
PROMPT='%F{cyan}%m%f %F{blue}%~%f${config_prompt_git}${config_prompt_env} %(?.%F{green}.%F{red})%#%f '
RPROMPT=''
