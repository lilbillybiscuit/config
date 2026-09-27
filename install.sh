#!/bin/sh
# Point this machine's Vim, Neovim, tmux, and Ghostty at this repository.
#
#   ./install.sh                  public config only
#   ./install.sh work             public config plus the work profile
#
# Each entrypoint file is rewritten; an existing one that differs is kept as
# <file>.bak first.
set -eu

repo=$(cd "$(dirname "$0")" && pwd)
profile=${1:-}
if [ -n "$profile" ]; then
  [ -d "$profile" ] || profile="$repo/$profile"
  profile=$(cd "$profile" && pwd)
fi

write() {
  target=$1
  mkdir -p "$(dirname "$target")"
  tmp=$(mktemp)
  cat > "$tmp"
  if [ -f "$target" ] && ! cmp -s "$tmp" "$target"; then
    cp "$target" "$target.bak"
    echo "backed up $target to $target.bak"
  fi
  mv "$tmp" "$target"
  echo "wrote $target"
}

vim_entry() {
  if [ -n "$profile" ]; then
    echo "let g:vim_config_profile_dir = '$profile/vim'"
  fi
  echo "source $repo/vim/vimrc"
}
vim_entry | write "$HOME/.vimrc"
vim_entry | write "$HOME/.config/nvim/init.vim"

{
  echo "source-file $repo/tmux/tmux.conf"
  if [ -n "$profile" ]; then
    echo "source-file -q $profile/tmux.conf"
  fi
} | write "$HOME/.tmux.conf"

case $(uname) in
  Darwin) ghostty_entry="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty" ;;
  *) ghostty_entry="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config" ;;
esac
{
  echo "config-file = $repo/ghostty/config"
  if [ -n "$profile" ]; then
    echo "config-file = ?$profile/ghostty"
  fi
} | write "$ghostty_entry"
