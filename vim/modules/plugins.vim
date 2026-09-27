" vim-plug bootstrap and the complete plugin manifest.
let g:vim_config_plugin_home = get(g:, 'vim_config_plugin_home', expand('~/.vim/plugged'))
let g:vim_config_plug_path = get(g:, 'vim_config_plug_path', expand('~/.vim/autoload/plug.vim'))
let g:vim_config_bootstrap_plugins = get(g:, 'vim_config_bootstrap_plugins', 1)

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
      call VimConfigWarn('vim-plug bootstrap failed; continuing without plugins')
    endif
  else
    call VimConfigWarn('curl is unavailable; continuing without plugins')
  endif
endif

if exists('*plug#begin')
  call plug#begin(g:vim_config_plugin_home)

  Plug 'catppuccin/vim', {'as': 'catppuccin'}
  Plug 'itchyny/lightline.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'jiangmiao/auto-pairs'
  Plug 'ojroques/vim-oscyank'
  Plug 'tpope/vim-commentary'
  Plug 'christoomey/vim-tmux-navigator'

  if has('nvim')
    Plug 'nvim-neo-tree/neo-tree.nvim', {'branch': 'v3.x'}
    Plug 'nvim-lua/plenary.nvim'
    Plug 'MunifTanjim/nui.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'sindrets/diffview.nvim'
  endif

  call plug#end()
endif

nnoremap <silent> <leader>pu :call VimConfigRun('PlugUpdate', 'vim-plug')<CR>
