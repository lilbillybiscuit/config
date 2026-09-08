" Neovim-only Git diff and history views through Diffview. Vim never sources this file.
lua << EOF
local ok, diffview = pcall(require, 'diffview')
if ok then
  diffview.setup({
    enhanced_diff_hl = true,
  })
end
EOF

function! s:Diffview(command) abort
  let l:name = matchstr(a:command, '^\S\+')
  if exists(':' . l:name) == 2
    execute a:command
  else
    echohl WarningMsg
    echom '[vim-config] diffview.nvim is not available'
    echohl None
  endif
endfunction

nnoremap <silent> <leader>gd :call <SID>Diffview('DiffviewOpen')<CR>
nnoremap <silent> <leader>gh :call <SID>Diffview('DiffviewFileHistory %')<CR>
nnoremap <silent> <leader>gH :call <SID>Diffview('DiffviewFileHistory')<CR>
nnoremap <silent> <leader>gq :call <SID>Diffview('DiffviewClose')<CR>
