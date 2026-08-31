" Colors, separators, status lines, and terminal-window presentation.
set background=dark
if exists('+termguicolors')
  set termguicolors
endif

let g:sonokai_style = 'default'
let g:sonokai_better_performance = 1
if !empty(globpath(&runtimepath, 'colors/sonokai.vim'))
  colorscheme sonokai
endif

if exists('+fillchars')
  set fillchars=vert:┃,fold:─,diff:╱
endif

function! s:ApplyHighlights() abort
  highlight StatusLine   cterm=bold ctermfg=231 ctermbg=60 gui=bold guifg=#f8f8f2 guibg=#5f4b8b
  highlight StatusLineNC cterm=none ctermfg=250 ctermbg=236 gui=none guifg=#b8b8b8 guibg=#303030
  highlight VertSplit    cterm=none ctermfg=99 ctermbg=NONE gui=none guifg=#875fd7 guibg=NONE
  highlight VimConfigTerminal ctermfg=250 ctermbg=234 guifg=#c6c6c6 guibg=#1c1c1c
endfunction

call s:ApplyHighlights()

let &statusline = '%#StatusLine# %<%{expand(''%:~:h'')}/'
      \ . '%#StatusLine#%t %h%m%r'
      \ . '%= %l:%c %p%% '

function! s:ConfigureTerminalWindow() abort
  setlocal nonumber norelativenumber
  let &l:statusline = ' '
  if exists('+winhighlight')
    setlocal winhighlight=Normal:VimConfigTerminal
  endif
endfunction

augroup vim_config_ui
  autocmd!
  autocmd ColorScheme * call <SID>ApplyHighlights()
  autocmd WinEnter,BufEnter * redrawstatus
  autocmd WinLeave * redrawstatus
  if exists('##TermOpen')
    autocmd TermOpen * call <SID>ConfigureTerminalWindow()
  endif
  if exists('##TerminalOpen')
    autocmd TerminalOpen * call <SID>ConfigureTerminalWindow()
  endif
augroup END
