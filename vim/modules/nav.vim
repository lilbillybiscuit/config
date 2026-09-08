" File, text, and pane navigation.
if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
endif
let $FZF_DEFAULT_OPTS = trim($FZF_DEFAULT_OPTS . ' --exact')

" fzf runs in a centered floating window; older editors fall back to a split.
if has('nvim-0.4') || (has('popupwin') && has('patch-8.2.191'))
  let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.7, 'highlight': 'VertSplit'}}
else
  let g:fzf_layout = {'down': '~40%'}
endif

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
