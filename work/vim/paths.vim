" Work machine binaries. Anything not set here comes from ~/config/vim/paths.vim.
"
"   let g:vim_config_paths.node = '/path/to/node'
"
" Values specific to one employer or machine go in paths.local.vim next to
" this file, which git ignores.
let s:local = expand('<sfile>:p:h') . '/paths.local.vim'
if filereadable(s:local)
  execute 'source ' . fnameescape(s:local)
endif
unlet s:local
