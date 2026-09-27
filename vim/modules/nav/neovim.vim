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

nnoremap <silent> <leader>e :call VimConfigRun('Neotree toggle', 'neo-tree')<CR>
