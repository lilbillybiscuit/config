" Editor-wide behavior with no plugin dependencies. Vim skips its own
" defaults.vim when a vimrc exists, so the basics Neovim ships with are set
" explicitly here.
let mapleader = ' '
let maplocalleader = ' '

filetype plugin indent on
syntax enable

set autoindent
set autoread
set backspace=indent,eol,start
set belloff=all
set complete-=i
set confirm
set cursorline
set display=lastline
set encoding=utf-8
set expandtab
set formatoptions+=j
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:»\ ,trail:·,nbsp:␣
set nobackup
set nomodeline
set noswapfile
set nowritebackup
set nrformats-=octal
set number
set scrolloff=5
set shiftwidth=4
set shortmess-=S
set showcmd
set signcolumn=yes
set smartcase
set softtabstop=-1
set splitbelow
set splitright
set tabstop=4
set title
set ttimeout
set ttimeoutlen=10
set undofile
set updatetime=300
set wildignore+=*.o,*.obj,*.pyc,*.pyo,*.class
set wildignore+=*/.git/*,*/__pycache__/*
set wildmenu

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

if has('nvim') && exists('*stdpath')
  let s:default_undo_dir = stdpath('state') . '/undo'
else
  let s:default_undo_dir = expand('~/.vim/undo')
endif
let s:undo_dir = get(g:, 'vim_config_undo_dir', s:default_undo_dir)
if !isdirectory(s:undo_dir)
  silent! call mkdir(s:undo_dir, 'p', 0700)
endif
if isdirectory(s:undo_dir)
  let &undodir = s:undo_dir
else
  set noundofile
endif
unlet s:default_undo_dir s:undo_dir

let &titlestring = '%t - ' . (has('nvim') ? 'Neovim' : 'Vim') . ' - %F'

nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

augroup vim_config_reload
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !~# '[cC]' | checktime | endif
augroup END

" Shared by every module that wraps an optional plugin or tool: run a command
" when its dependency exists, otherwise explain what is missing. The check
" defaults to the command's first word.
function! VimConfigWarn(message) abort
  echohl WarningMsg
  echom '[vim-config] ' . a:message
  echohl None
endfunction

function! VimConfigRun(command, dependency, ...) abort
  let l:check = a:0 ? a:1 : ':' . matchstr(a:command, '^\S\+')
  if exists(l:check) == (l:check[0] ==# ':' ? 2 : 1)
    execute a:command
  else
    call VimConfigWarn(a:dependency . ' is not available')
  endif
endfunction
