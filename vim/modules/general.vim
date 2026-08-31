" Editor-wide behavior with no plugin dependencies.
if &compatible
  set nocompatible
endif

let mapleader = ' '
let maplocalleader = ' '

filetype plugin indent on
syntax enable

set autoindent
set autoread
set backspace=indent,eol,start
set cursorline
set encoding=utf-8
set expandtab
set hidden
set history=1000
set laststatus=2
set nobackup
set noerrorbells
set nomodeline
set noswapfile
set novisualbell
set nowritebackup
set number
set ruler
set shiftwidth=4
set showcmd
set softtabstop=4
set tabstop=4
set title
set undofile
set updatetime=300
set wildignore+=*.o,*.obj,*.pyc,*.pyo,*.class
set wildignore+=*/.git/*,*/__pycache__/*

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

augroup vim_config_reload
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !~# '[cC]' | checktime | endif
augroup END
