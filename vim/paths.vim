" The one place external binaries are chosen. A profile's paths.vim overrides
" entries here; modules read g:vim_config_paths and never hard-code a path.
" An empty value means "let the tool find it", which keeps things like
" per-project virtualenvs working.
let g:vim_config_paths = {
      \ 'node': exepath('node'),
      \ 'python3': '',
      \ 'clangd': '',
      \ 'black': '',
      \ }
