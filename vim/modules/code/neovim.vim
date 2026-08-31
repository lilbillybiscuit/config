" Neovim-only formatter host preference.
if executable('/usr/local/bin/python3.12')
  let g:python3_host_prog = get(g:, 'python3_host_prog', '/usr/local/bin/python3.12')
endif
