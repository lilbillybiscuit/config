" Colors, separators, status and tab lines, and terminal-window presentation.
" Catppuccin Frappe matches Ghostty; every color below comes from it.
set background=dark
if exists('+termguicolors')
  set termguicolors
endif

if !empty(globpath(&runtimepath, 'colors/catppuccin_frappe.vim'))
  colorscheme catppuccin_frappe
endif

if exists('+fillchars')
  set fillchars=vert:┃,fold:─,diff:╱
endif

" lightline draws the mode, so Vim's own mode message is redundant.
set noshowmode

" Neovim draws separators with WinSeparator; Vim still uses VertSplit.
let s:separator_groups = ['VertSplit', 'WinSeparator']

" Links to the color scheme's groups, re-applied whenever it changes.
function! s:ApplyHighlights() abort
  highlight! link VimConfigActiveSeparator Special
endfunction

call s:ApplyHighlights()

" File-specific CoC details for each window's status line: the enclosing
" symbol and diagnostic counts, including information and hints.
function! VimConfigCocStatus() abort
  if !get(g:, 'did_coc_loaded', 0)
    return ''
  endif
  let l:parts = []
  let l:function = trim(get(b:, 'coc_current_function', ''))
  if !empty(l:function)
    call add(l:parts, l:function)
  endif
  let l:info = get(b:, 'coc_diagnostic_info', {})
  for [l:sign, l:key] in [['E', 'error'], ['W', 'warning'], ['I', 'information'], ['H', 'hint']]
    if get(l:info, l:key, 0) > 0
      call add(l:parts, l:sign . l:info[l:key])
    endif
  endfor
  return join(l:parts, ' ')
endfunction

" Editor-wide details for the top bar.
function! VimConfigServers() abort
  return get(g:, 'did_coc_loaded', 0) ? trim(get(g:, 'coc_status', '')) : ''
endfunction

function! VimConfigGitBranch() abort
  return trim(get(g:, 'coc_git_status', ''))
endfunction

function! VimConfigCwd() abort
  return fnamemodify(getcwd(), ':~')
endfunction

" Each window's own status line sits at its bottom; the tab line is an
" always-visible global bar at the top.
set laststatus=2
set showtabline=2

let g:lightline = {
      \ 'active': {
      \   'left': [['mode', 'paste'], ['readonly', 'relativepath', 'modified']],
      \   'right': [['lineinfo'], ['percent'], ['coc']],
      \ },
      \ 'inactive': {
      \   'left': [['relativepath', 'modified']],
      \   'right': [['lineinfo']],
      \ },
      \ 'tabline': {
      \   'left': [['tabs']],
      \   'right': [['cwd'], ['git'], ['servers']],
      \ },
      \ 'component_function': {
      \   'coc': 'VimConfigCocStatus',
      \   'servers': 'VimConfigServers',
      \   'git': 'VimConfigGitBranch',
      \   'cwd': 'VimConfigCwd',
      \ },
      \ }
if !empty(globpath(&runtimepath, 'autoload/lightline/colorscheme/catppuccin_frappe.vim'))
  let g:lightline.colorscheme = 'catppuccin_frappe'
endif

" The active window's separators use the bright group. A window owns only its
" right and bottom borders. Vim has no 'winhighlight', so this is Neovim-only.
function! s:MarkSeparators(active) abort
  if !exists('+winhighlight')
    return
  endif
  for l:group in s:separator_groups
    execute 'setlocal winhighlight' . (a:active ? '+=' : '-=') . l:group . ':VimConfigActiveSeparator'
  endfor
endfunction

function! s:ConfigureTerminalWindow() abort
  setlocal nonumber norelativenumber nolist signcolumn=no
endfunction

function! s:RefreshStatus() abort
  if exists('*lightline#update')
    call lightline#update()
  endif
  redrawtabline
endfunction

augroup vim_config_ui
  autocmd!
  autocmd ColorScheme * call <SID>ApplyHighlights()
  autocmd WinEnter * call <SID>MarkSeparators(1) | setlocal cursorline
  autocmd WinLeave * call <SID>MarkSeparators(0) | setlocal nocursorline
  autocmd User CocStatusChange,CocDiagnosticChange,CocGitStatusChange call <SID>RefreshStatus()
  autocmd DirChanged * redrawtabline
  if exists('##TermOpen')
    autocmd TermOpen * call <SID>ConfigureTerminalWindow()
  endif
  if exists('##TerminalOpen')
    autocmd TerminalOpen * call <SID>ConfigureTerminalWindow()
  endif
augroup END
