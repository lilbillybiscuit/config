" Neovim-only Git diff and history views through Diffview. Vim never sources this file.
lua << EOF
local ok, diffview = pcall(require, 'diffview')
if ok then
  diffview.setup({
    enhanced_diff_hl = true,
  })
end
EOF

nnoremap <silent> <leader>gd :call VimConfigRun('DiffviewOpen', 'diffview.nvim')<CR>
nnoremap <silent> <leader>gh :call VimConfigRun('DiffviewFileHistory %', 'diffview.nvim')<CR>
nnoremap <silent> <leader>gH :call VimConfigRun('DiffviewFileHistory', 'diffview.nvim')<CR>
nnoremap <silent> <leader>gq :call VimConfigRun('DiffviewClose', 'diffview.nvim')<CR>
