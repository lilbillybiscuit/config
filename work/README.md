# Work profile

A placeholder profile layered on top of the public config. The tracked files
hold no employer-specific paths, hosts, or URLs. On a work computer, put those
in `*.local.vim` / `*.local.conf` / `*.local.zsh` files in this folder; git ignores them.

- `zsh/paths.zsh`: shell binary overrides, loaded before integrations
- `zsh/config.zsh`: shell customization, loaded after the public modules
- `vim/paths.vim`: binary locations; sources `vim/paths.local.vim` if present
- `vim/settings.vim`: extra CoC extensions and settings
- `vim/modules/`: commands sourced after the public modules
- `tmux.conf`: sources `tmux.local.conf` if present
- `ghostty`: extra Ghostty settings

Enable it on a machine with `./install.sh work` from the repository root.
