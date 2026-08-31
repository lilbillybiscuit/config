" Personal choices for ambiguous C-family extensions.
augroup vim_config_c_family_filetypes
  autocmd!
  autocmd BufNewFile,BufRead *.[Cc] if expand('<afile>:e') ==# 'C' | setlocal filetype=cpp | endif
  autocmd BufNewFile,BufRead *.tpp setlocal filetype=cpp
  autocmd BufNewFile,BufRead *.mm setlocal filetype=objcpp
augroup END
