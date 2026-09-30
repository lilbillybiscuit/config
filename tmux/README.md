# tmux

The prefix is Ctrl-a. Reload with Prefix+r, then press Prefix+I to install any
new plugins through TPM. The first start on a machine without TPM bootstraps it.

- Prefix+s opens the built-in session tree. Press `/` to search, Enter to switch.
- Prefix+F opens [tmux-fzf](https://github.com/sainnhe/tmux-fzf), which searches
  sessions, windows, panes, and other tmux objects. It needs fzf on tmux's PATH.
- Prefix+Ctrl-s saves with Resurrect; Prefix+Ctrl-r restores.
- Continuum saves every 15 minutes and restores when a new tmux server starts.
  Reloading the config does not trigger a restore. It restores supported session
  structure and programs, not arbitrary process memory or unsaved application data.

The top status bar has one row, with tabs on the left and the clock followed by
Catppuccin's built-in host module at the far right. `@catppuccin_host_text`
controls its label; `#h` shows the short hostname. Continuum loads last; later profile settings must
not replace `status-right`, which contains its save hook.

Plugin references:
[Resurrect](https://github.com/tmux-plugins/tmux-resurrect),
[Continuum](https://github.com/tmux-plugins/tmux-continuum).
