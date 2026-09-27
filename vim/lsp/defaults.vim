" Language-server defaults shared by every profile. This file is data only;
" modules/code/lsp.vim hands it to CoC. A profile's settings.vim can add
" extensions or override any key, and a project's .vim/coc-settings.json
" still wins over both.
let g:vim_config_coc_extensions = [
      \ 'coc-clangd',
      \ 'coc-git',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-pyright',
      \ 'coc-sh',
      \ 'coc-yank',
      \ ]

let g:vim_config_coc_settings = {
      \ 'coc.preferences.currentFunctionSymbolAutoUpdate': v:true,
      \ 'codeLens.enable': v:true,
      \ 'semanticTokens.enable': v:true,
      \ 'diagnostic.virtualText': v:true,
      \ 'diagnostic.errorSign': '✘',
      \ 'diagnostic.warningSign': '▲',
      \ 'diagnostic.infoSign': '●',
      \ 'diagnostic.hintSign': '·',
      \ 'python.formatting.provider': 'black',
      \ }
