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

" Neovim draws separators with WinSeparator; Vim still uses VertSplit.
let s:separator_groups = ['VertSplit', 'WinSeparator']

function! s:ApplyHighlights() abort
  highlight StatusLine   cterm=bold ctermfg=231 ctermbg=60 gui=bold guifg=#f8f8f2 guibg=#5f4b8b
  highlight StatusLineNC cterm=none ctermfg=250 ctermbg=236 gui=none guifg=#b8b8b8 guibg=#303030
  for l:group in s:separator_groups
    execute 'highlight ' . l:group . ' cterm=none ctermfg=99 ctermbg=NONE gui=none guifg=#875fd7 guibg=NONE'
  endfor
  highlight VimConfigActiveSeparator cterm=bold ctermfg=183 ctermbg=NONE gui=bold guifg=#d7afff guibg=NONE
  highlight VimConfigTerminal ctermfg=250 ctermbg=234 guifg=#c6c6c6 guibg=#1c1c1c
endfunction

call s:ApplyHighlights()

function! VimConfigCocStatus() abort
  if !get(g:, 'did_coc_loaded', 0)
    return ''
  endif
  let l:status = trim(coc#status())
  return empty(l:status) ? '' : l:status . ' '
endfunction

let &statusline = '%#StatusLine# %<%{expand(''%:~:h'')}/'
      \ . '%#StatusLine#%t %h%m%r'
      \ . '%= %{VimConfigCocStatus()}%l:%c %p%% '

" Only the active window's separators use the bright group, which shows which
" pane owns a border. Vim has no 'winhighlight', so this is Neovim-only.
function! s:MarkSeparators(active) abort
  if !exists('+winhighlight')
    return
  endif
  for l:group in s:separator_groups
    execute 'setlocal winhighlight' . (a:active ? '+=' : '-=') . l:group . ':VimConfigActiveSeparator'
  endfor
endfunction

function! s:ConfigureTerminalWindow() abort
  setlocal nonumber norelativenumber
  let &l:statusline = ' '
  if exists('+winhighlight')
    setlocal winhighlight+=Normal:VimConfigTerminal
  endif
endfunction

augroup vim_config_ui
  autocmd!
  autocmd ColorScheme * call <SID>ApplyHighlights()
  autocmd WinEnter,BufEnter * redrawstatus
  autocmd WinLeave * redrawstatus
  autocmd WinEnter * call <SID>MarkSeparators(1)
  autocmd WinLeave * call <SID>MarkSeparators(0)
  autocmd User CocStatusChange,CocDiagnosticChange redrawstatus
  if exists('##TermOpen')
    autocmd TermOpen * call <SID>ConfigureTerminalWindow()
  endif
  if exists('##TerminalOpen')
    autocmd TerminalOpen * call <SID>ConfigureTerminalWindow()
  endif
augroup END
