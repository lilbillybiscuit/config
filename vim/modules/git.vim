" Git-backed file discovery and coc-git's commit-at-position view.
nnoremap <silent> <leader>gf :call VimConfigRun('GFiles', 'Git and fzf.vim')<CR>
nnoremap <silent> <leader>gc :call VimConfigRun('CocCommand git.showCommit', 'coc-git')<CR>
