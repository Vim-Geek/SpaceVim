"=============================================================================
" treesitter.vim --- treesitter layer for SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section treesitter, layers-treesitter
" @parentsection layers
" This layer provides treesitter support for SpaceVim.

function! SpaceVim#layers#treesitter#plugins() abort
  let plugins = []
  " call add(plugins, ['nvim-treesitter/nvim-treesitter', { 'merged' : 0, 'loadconf' : 1 , 'do' : 'TSUpdate', 'loadconf_before' : 1 }])
  call add(plugins, ['nvim-treesitter/nvim-treesitter', { 'merged' : 0, 'loadconf' : 1 , 'do' : 'TSUpdate' }])
  call add(plugins, ['nvim-treesitter/nvim-treesitter-context', { 'merged' : 0, 'loadconf' : 1 }])
  call add(plugins, ['RRethy/nvim-treesitter-textsubjects', { 'merged' : 0 }])
  call add(plugins, ['RRethy/nvim-treesitter-endwise', { 'merged' : 0 }])
  return plugins
endfunction

function! SpaceVim#layers#treesitter#health() abort
  call SpaceVim#layers#treesitter#plugins()
  return 1
endfunction

function! SpaceVim#layers#treesitter#setup() abort
  lua require('spacevim.treesitter').setup()
endfunction

function! SpaceVim#layers#treesitter#loadable() abort
  return has('nvim') && has('nvim-0.12.0')
endfunction
