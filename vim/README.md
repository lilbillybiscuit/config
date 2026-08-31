# Vim configuration

`vimrc` is the shared entrypoint for Vim and Neovim. It resolves this directory
from its own path, then sources an explicit list of modules. Nothing depends on
the directory from which the editor starts.

## Install

Source the central file from each editor's normal entrypoint:

```vim
" ~/.vimrc
execute 'source ' . fnameescape(expand('~/config/vim/vimrc'))
```

```vim
" ~/.config/nvim/init.vim
execute 'source ' . fnameescape(expand('~/config/vim/vimrc'))
```

vim-plug installs plugins under `~/.vim/plugged`. On first startup the config
downloads vim-plug with `curl` when it is missing. Set
`g:vim_config_bootstrap_plugins = 0` before sourcing `vimrc` to disable that.

## Modules

- `modules/general.vim`: editor-wide options and persistent undo
- `modules/plugins.vim`: vim-plug bootstrap and plugin declarations
- `modules/ui.vim`: Sonokai, separators, terminal styling, and status lines
- `modules/nav.vim`: fzf file and text search
- `modules/nav/neovim.vim`: Neo-tree and Neovim navigation options
- `modules/code/editing.vim`: pairs, comments, and brace indentation
- `modules/code/lsp.vim`: CoC extensions, completion, diagnostics, and actions
- `modules/code/neovim.vim`: Neovim's Python formatter host
- `modules/git.vim`: Git files and commit-at-position behavior
- `modules/custom/yank.vim`: external and OSC52 copy behavior
- `modules/custom/hrt.vim`: `:SGLink`

## Main keys

| Key | Action |
| --- | --- |
| `<C-p>` | Find files |
| `<Space>g` | Find Git files |
| `<Space>r` | Search with ripgrep |
| `<Space>e` | Toggle Neo-tree in Neovim |
| `<Space>pu` | Update plugins |
| `<Space>/` | Toggle comments |
| `<Space>y` | Copy with the external `yank` helper |
| `<Space>yy` | Copy through OSC52 |
| `<Space>gs` | List symbols |
| `<Space>d` | Show documentation |
| `<Space>f` | Format |
| `<Space>ac` | Run a code action |
| `<Space>qf` | Apply the current fix |
| `gc` | Show the commit for the current position |

The fixed HRT Node and Python paths are used only when their executables exist.
Set `g:coc_node_path` or `g:vim_config_sglink_root` before sourcing `vimrc` to
override the defaults.
