"=============================================================================
" asm.vim --- assembly language support in SpaceVim
" License: GPLv3
"=============================================================================

""
" @section lang#asm, layers-lang-asm
" @parentsection layers
" This layer provides workflow for asm. To enable this
" layer:
" >
"   [[layers]]
"     name = "lang#asm"
" <

function! SpaceVim#layers#lang#asm#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-aspectj', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#asm#health() abort
  call SpaceVim#layers#lang#asm#plugins()
  return 1
endfunction
