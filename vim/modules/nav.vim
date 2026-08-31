" File, text, and pane navigation.
if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
endif
let $FZF_DEFAULT_OPTS = trim($FZF_DEFAULT_OPTS . ' --exact')
let g:fzf_layout = {'down': '~40%'}

function! s:Run(command, dependency) abort
  let l:name = matchstr(a:command, '^\S\+')
  if exists(':' . l:name) == 2
    execute a:command
    return
  endif

  echohl WarningMsg
  echom '[vim-config] ' . a:dependency . ' is not available'
  echohl None
endfunction

nnoremap <silent> <C-p> :call <SID>Run('Files', 'fzf.vim')<CR>
nnoremap <silent> <leader>r :call <SID>Run('Rg', 'ripgrep and fzf.vim')<CR>
