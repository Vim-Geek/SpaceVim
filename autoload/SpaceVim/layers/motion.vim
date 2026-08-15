"=============================================================================
" motion.vim --- SpaceVim motion layer
" Author: Phoenix Xu 
" License: MIT
"=============================================================================


function! SpaceVim#layers#motion#plugins() abort
endfunction

function! SpaceVim#layers#motion#config() abort
endfunction

function! SpaceVim#layers#motion#set_variable(var) abort
endfunction

function! SpaceVim#layers#motion#health() abort
  call SpaceVim#layers#lang#rust#plugins()
  call SpaceVim#layers#lang#rust#config()
  return 1
endfunction
