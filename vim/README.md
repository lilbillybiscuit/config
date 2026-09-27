# Vim configuration

`vimrc` is the shared entrypoint for Vim and Neovim. It resolves this directory
from its own path, then sources an explicit list of modules. Nothing depends on
the directory from which the editor starts.

## Install

Run `../install.sh` for the public config alone, or `../install.sh
~/config-work` to add a private profile. It writes `~/.vimrc` and
`~/.config/nvim/init.vim` (plus the tmux and Ghostty entrypoints). The Vim
ones look like:

```vim
let g:vim_config_profile_dir = '/Users/you/config-work/vim'   " optional
source /Users/you/config/vim/vimrc
```

vim-plug installs plugins under `~/.vim/plugged`. On first startup the config
downloads vim-plug with `curl` when it is missing. Set
`g:vim_config_bootstrap_plugins = 0` before sourcing `vimrc` to disable that.
fzf, ripgrep, fd, and bat should be on `PATH` for search and previews.

## Layers

Each layer overrides the one before it:

1. **Public defaults** in this directory.
2. **Profile** (`g:vim_config_profile_dir`), such as a private work repository:
   - `paths.vim` overrides entries of `g:vim_config_paths`
   - `settings.vim` changes `g:vim_config_coc_extensions` and
     `g:vim_config_coc_settings`
   - `modules/*.vim` are sourced after the public modules
3. **Machine-local** `~/.vim/local.vim` (or `g:vim_config_local_file`), sourced
   last and never committed.
4. **Per-project** `.vim/coc-settings.json` in a project, which CoC applies over
   everything above.

`paths.vim` is the only file that names binaries (`node`, `python3`, `clangd`,
`black`). An empty entry lets the tool find its own, which keeps per-project
virtualenvs working. To pin a version on one machine, set it in the profile's
or the local file:

```vim
let g:vim_config_paths.node = '/opt/node-22/bin/node'
```

`lsp/defaults.vim` holds the shared CoC extensions and settings as data, using
CoC's own setting names. `modules/code/lsp.vim` merges them with the paths and
hands the result to CoC through `g:coc_user_config`.

## Modules

- `paths.vim`: external binaries
- `lsp/defaults.vim`: shared CoC extensions and settings
- `modules/general.vim`: editor-wide options, persistent undo, and the
  `VimConfigRun()` helper for optional dependencies
- `modules/plugins.vim`: vim-plug bootstrap and plugin declarations
- `modules/ui.vim`: Catppuccin Frappe, lightline status and tab lines, and
  active-window indicators
- `modules/nav.vim`: fzf file, buffer, history, and text search
- `modules/nav/neovim.vim`: Neo-tree and Neovim navigation options
- `modules/code/editing.vim`: insert keys, pairs, and comments
- `modules/code/filetypes.vim`: C-family extension choices
- `modules/code/lsp.vim`: the CoC adapter and language mappings
- `modules/git.vim`: Git files and commit-at-position
- `modules/git/neovim.vim`: Diffview diffs and file history
- `modules/yank.vim`: OSC52 copy and yank history

## Main keys

| Key | Action |
| --- | --- |
| `<C-p>` | Find files |
| `<Space>b` | Find open buffers |
| `<Space>h` | Recently opened files |
| `<Space>l` | Search lines in the current buffer |
| `<Space>r` | Search with ripgrep |
| `<Space>*` | Search with ripgrep for the word under the cursor |
| `<Esc><Esc>` | Clear search highlighting |
| `<Space>gf` | Find Git files |
| `<Space>gc` | Show the commit for the current line (coc-git) |
| `<Space>e` | Toggle Neo-tree in Neovim |
| `<Space>pu` | Update plugins |
| `<Space>/`, `gcc`, `gc` | Toggle comments |
| `<Space>y` | Copy the selection to the system clipboard (OSC52) |
| `<Space>yy` | Copy the current line to the system clipboard |
| `<Space>yl` | Browse yank history |
| `<Space>gs` | List symbols |
| `<Space>d` | Show documentation |
| `<Space>R` | Rename the symbol under the cursor |
| `<Space>i` | Show the full diagnostic message at the cursor |
| `<Space>k` | List the buffer's diagnostics in the location list |
| `[g` / `]g` | Jump to the previous / next diagnostic |
| `<Space>f` | Format the buffer, or the selection in Visual mode |
| `<Space>ac` | Run a code action |
| `<Space>qf` | Apply the current fix |
| `gl` | Run the code lens on the current line |
| `<Space>gd` | Open Diffview for the working tree in Neovim |
| `<Space>gh` | Diffview history for the current file in Neovim |
| `<Space>gH` | Diffview history for the repository in Neovim |
| `<Space>gq` | Close Diffview in Neovim |

## Indicators

- lightline draws the status and tab lines with Catppuccin's lightline theme:
  the mode, colored per mode, in the focused window, and, when CoC is loaded,
  the enclosing symbol, diagnostic counts (`E` `W` `I` `H`), and the language
  servers' status. `ui.vim` sets no colors of its own; its few highlights link
  to the color scheme's groups.
- Neovim uses one status line for all windows and a title bar per window; the
  focused window's title bar is highlighted.
- Only the focused window draws the cursor line. In Neovim, its separators are
  also brighter.
- The sign column always shows, so diagnostics and coc-git's change markers
  don't shift the text. Tabs, trailing spaces, and non-breaking spaces are
  visible, and searches show a `[3/12]` count.
- Closing a modified buffer asks for confirmation instead of failing.

## Tests

```sh
vim -Nu NONE -i NONE -es -S tests/verify.vim    # Vim only
vim -Nu NONE -i NONE -es -S tests/editing.vim
vim -Nu NONE -i NONE -es -S tests/profile.vim
```

`tests/verify.vim` also fails if any module other than `paths.vim` names a
binary under `/opt` or `/usr`.
