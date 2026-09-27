" File, text, and pane navigation.
if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
endif

" fzf runs in a centered floating window; older editors fall back to a split.
if has('nvim-0.4') || (has('popupwin') && has('patch-8.2.191'))
  let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.7, 'highlight': 'VertSplit'}}
else
  let g:fzf_layout = {'down': '~40%'}
endif
" Preview on the right (colored when bat is installed); ctrl-/ toggles it.
let g:fzf_vim = {'preview_window': ['right,50%', 'ctrl-/']}

nnoremap <silent> <C-p> :call VimConfigRun('Files', 'fzf.vim')<CR>
nnoremap <silent> <leader>b :call VimConfigRun('Buffers', 'fzf.vim')<CR>
nnoremap <silent> <leader>l :call VimConfigRun('BLines', 'fzf.vim')<CR>
nnoremap <silent> <leader>h :call VimConfigRun('History', 'fzf.vim')<CR>
nnoremap <silent> <leader>r :call VimConfigRun('Rg', 'ripgrep and fzf.vim')<CR>
nnoremap <silent> <leader>* :call VimConfigRun('Rg ' . expand('<cword>'), 'ripgrep and fzf.vim')<CR>
