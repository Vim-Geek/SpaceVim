"=============================================================================
" template.vim --- SpaceVim layer template
" Copyright (c) 2016-2026 Phoenix Tsui & Contributors
" License: MIT
"=============================================================================
scriptencoding utf-8

""
" @section <xxx>, layers-<xxx>
" @parentsection layers
" `<xxx>` layer provides <xxx> workflow for SpaceVim.
" To load this layer:
" >
"   [[layers]]
"     name = <layer_name>
" <
"
" @subsection layer options
"
" 1. `<options_xxx>`: set the debug engine. It can be `<xxx_a>`
"
" The layer option can be used when loading the `<xxx>` layer, for example:
" >
"   [[layers]]
"     name = <layer_name>
"     options_xxx = "xxx_a"
" <
"
" @subsection key bindings
" >
"   Key binding     Description
"   SPC ? ?	        <describe the function of key binding>
" <

if exists('s:options_xxx')
  finish
endif

let s:options_xxx = 'ollama'

function! SpaceVim#layers#template#loadable() abort
  echo "template: loadable"
  return has('nvim')
endfunction


        " \     'zbirenbaum/copilot.lua',
function! SpaceVim#layers#template#plugins() abort
  let plugins = [
        \ ['avante-corp/avante.nvim', { 'merged' : 0, 'loadconf' : 1, "depends" : [ 
        \     'nvim-lua/plenary.nvim',
        \     'MunifTanjim/nui.nvim',
        \     'nvim-mini/mini.pick',
        \     'nvim-telescope/telescope.nvim',
        \     'hrsh7th/nvim-cmp',
        \     'ibhagwan/fzf-lua',
        \     'folke/snacks.nvim',
        \     'nvim-tree/nvim-web-devicons',
        \    ]}
        \ ],
        \ ]

  if !empty(system('command -v ' . 'opencode'))
    call add(plugins, ['nickjvandyke/opencode.nvim', {'merged' : 0, 'loadconf' : 1 }])
  end

  if !empty(system('command -v ' . 'ollama'))
    call add(plugins, ['gergap/vim-ollama', {'merged' : 0, 'loadconf' : 1 }])
  end
  echo "template: plugins"

  return [] 
endfunction

function! SpaceVim#layers#template#set_variable(var) abort
  echo "template: set_variable"

  let s:options_xxx = get(a:var, 'options_xxx', s:options_xxx)

endfunction

function! SpaceVim#layers#template#get_variable() abort
  echo "template: get_variable"
  
  return {
        \ 'options_xxx' : s:options_xxx,
        \ }

endfunction

function! SpaceVim#layers#template#get_options() abort
  echo "template: get_options"

  return [
        \ 'options_xxx',
        \ ]

endfunction

function! SpaceVim#layers#template#health() abort
  echo "template: health"
  call SpaceVim#layers#template#plugins()
  call SpaceVim#layers#template#config()
  return 1
endfunction
