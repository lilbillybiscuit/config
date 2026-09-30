# Zsh

Install dependencies first. On macOS:

```sh
brew install fzf zoxide
# Only if ~/.oh-my-zsh does not already exist:
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
```

fzf 0.48+ and zoxide are native binaries; neither requires Node or Python.
Missing tools are skipped. Oh My Zsh supplies Git aliases and completion; the
prompt lives here. Missing Oh My Zsh falls back to Zsh completion.
Oh My Zsh updates its own checkout automatically on its default cadence when
an interactive shell starts. This does not update this config repository.

Run `./install.sh` from the repository root, or `./install.sh work` for the work
profile. This writes the Zsh, Vim, Neovim, tmux, and Ghostty entrypoints, backing
up changed files to `.bak`. Before installing, copy any app-specific startup
lines you need from your old `.zshrc` into `zsh/local.zsh`. Do not source the
entire old config: its theme and integrations would load twice.

For Zsh alone, put `source ~/config/zsh/zshrc` in your `.zshrc`, then open a new
shell. The current machine's `.zshrc` is not changed merely by editing this repo.

Load order:

1. `paths.zsh`: PATH defaults and the `config_bins` map, then ignored
   `paths.local.zsh` and the profile's `paths.zsh`.
2. `modules/options.zsh`: history and editor defaults.
3. `modules/oh-my-zsh.zsh`: Oh My Zsh, Git plugin, completion.
4. `modules/tools.zsh`: fzf and zoxide integration.
5. `modules/aliases.zsh`: navigation, Git/worktree, tmux aliases.
6. `modules/prompt.zsh`: hostname, folder, branch, linked worktree name, dirty
   marker, and active environments.
7. Ignored `local.zsh`, then the profile's `config.zsh`.

For a binary outside PATH, add to `zsh/paths.local.zsh` or
`work/zsh/paths.local.zsh`:

```zsh
config_bins[fzf]=/absolute/path/to/fzf
config_bins[zoxide]=/absolute/path/to/zoxide
config_bins[git]=/absolute/path/to/git
# Optional alternative Oh My Zsh checkout:
export ZSH=/absolute/path/to/oh-my-zsh
```

Pinned directories also enter PATH for subprocesses. Environment managers remain
machine-specific; initialize them in `local.zsh`. The prompt reads virtualenv,
Conda, explicit pyenv, nvm, explicit rbenv, Nix shell, and direnv environment
variables. It does not execute language runtimes or infer installed versions.
`wt:` identifies linked Git worktrees; the primary checkout shows the branch.
`*` means tracked or untracked changes.

Use `z name` to jump, `zi` for fuzzy directory selection, Ctrl-r for history,
Ctrl-t for files, and Alt-c for directories. `gwtl` lists Git worktrees.
