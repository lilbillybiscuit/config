" vim-plug bootstrap and the complete plugin manifest.
let g:vim_config_plugin_home = get(g:, 'vim_config_plugin_home', expand('~/.vim/plugged'))
let g:vim_config_plug_path = get(g:, 'vim_config_plug_path', expand('~/.vim/autoload/plug.vim'))
let g:vim_config_bootstrap_plugins = get(g:, 'vim_config_bootstrap_plugins', 1)

function! s:Warn(message) abort
  echohl WarningMsg
  echom '[vim-config] ' . a:message
  echohl None
endfunction

if !exists('*plug#begin') && filereadable(g:vim_config_plug_path)
  execute 'source ' . fnameescape(g:vim_config_plug_path)
endif

if !exists('*plug#begin') && g:vim_config_bootstrap_plugins
  if executable('curl')
    silent! call mkdir(fnamemodify(g:vim_config_plug_path, ':h'), 'p', 0700)
    let s:curl_command = 'curl -fLo ' . shellescape(g:vim_config_plug_path)
          \ . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    call system(s:curl_command)
    unlet s:curl_command
    if filereadable(g:vim_config_plug_path)
      execute 'source ' . fnameescape(g:vim_config_plug_path)
    else
      call s:Warn('vim-plug bootstrap failed; continuing without plugins')
    endif
  else
    call s:Warn('curl is unavailable; continuing without plugins')
  endif
endif

if exists('*plug#begin')
  call plug#begin(g:vim_config_plugin_home)

  Plug 'sainnhe/sonokai'
  Plug 'sheerun/vim-polyglot'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'jiangmiao/auto-pairs'
  Plug 'ojroques/vim-oscyank'
  Plug 'tpope/vim-commentary'
  Plug 'christoomey/vim-tmux-navigator'

  if has('nvim')
    Plug 'psf/black', {'branch': 'stable'}
    Plug 'nvim-neo-tree/neo-tree.nvim', {'branch': 'v3.x'}
    Plug 'nvim-lua/plenary.nvim'
    Plug 'MunifTanjim/nui.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'sindrets/diffview.nvim'
  endif

  call plug#end()
endif

function! s:UpdatePlugins() abort
  if exists(':PlugUpdate') == 2
    PlugUpdate
  else
    call s:Warn('vim-plug is not available')
  endif
endfunction

nnoremap <silent> <leader>pu :call <SID>UpdatePlugins()<CR>
