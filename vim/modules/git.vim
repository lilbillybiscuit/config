" Git-backed file discovery and CoC's current-position commit view.
function! s:RunGitFiles() abort
  if exists(':GFiles') == 2
    GFiles
  else
    echohl WarningMsg | echom '[vim-config] Git and fzf.vim are not available' | echohl None
  endif
endfunction

function! s:ShowCommit() abort
  if exists(':CocCommand') == 2
    CocCommand git.showCommit
  else
    echohl WarningMsg | echom '[vim-config] CoC git support is not available' | echohl None
  endif
endfunction

nnoremap <silent> <leader>g :call <SID>RunGitFiles()<CR>
nnoremap <silent> gc :call <SID>ShowCommit()<CR>
