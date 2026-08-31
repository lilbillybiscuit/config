" Neovim-only navigation. Vim never sources this file.
set mouse=a
set scrollback=100000
set clipboard=unnamedplus

lua << EOF
local ok, neo_tree = pcall(require, 'neo-tree')
if ok then
  neo_tree.setup({
    close_if_last_window = true,
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
  })
end
EOF

function! s:ToggleTree() abort
  if exists(':Neotree') == 2
    Neotree toggle
  else
    echohl WarningMsg
    echom '[vim-config] neo-tree is not available'
    echohl None
  endif
endfunction

nnoremap <silent> <leader>e :call <SID>ToggleTree()<CR>
