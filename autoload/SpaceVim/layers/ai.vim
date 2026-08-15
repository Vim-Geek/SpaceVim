"=============================================================================
" ai.vim --- SpaceVim AI layer
" Copyright (c) 2016-2026 Phoenix Tsui & Contributors
" License: MIT
"=============================================================================
scriptencoding utf-8

""
" @section AI, layers-AI
" @parentsection layers
" `AI` layer provides AI workflow for SpaceVim.
" To load this layer:
" >
"   [[layers]]
"     name = 'ai'
" <
"
" @subsection layer options
"
" 1. `debugger_plugin`: set the debug engine. It can be `dap`
" 2. `debugger_ui`: set the debug ui. if `debugger_plugin = 'dap'`, It can be `dap-view`(default) or `dap-ui`
"
" The layer option can be used when loading the `ai` layer, for example:
" >
"   [[layers]]
"     name = 'ai'
" <
"
" @subsection key bindings
" >
"   Key binding     Description
"   SPC d b	        toggle breakpoints
"   SPC d c	      	continue session
"   SPC d C	        clear all breakpoints
"   SPC d d	      	disconnect session
"   SPC d e	      	evaluate expression
"   SPC d i	      	step in
"   SPC d l	      	show log
"   SPC d n	      	new session
"   SPC d o	      	step over
"   SPC d O	      	step out
"   SPC d r	      	restart frame
"   SPC d R	        toggle REPL
"   SPC d t	        terminate session
" <

if exists('s:cscope_command')
  finish
endif
function! SpaceVim#layers#ai#loadable() abort
  return has('nvim')
endfunction

let s:avante_provider = 'ollama'

        " \     'zbirenbaum/copilot.lua',
function! SpaceVim#layers#ai#plugins() abort
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

  return plugins
endfunction

function! SpaceVim#layers#ai#set_variable(var) abort

  let s:avante_provider = get(a:var, 'avante_provider', s:avante_provider)
  let s:auto_update = get(a:var, 'auto_update', s:auto_update)
  let g:cscope_open_location = get(a:var, 'open_location', 1)
  let g:cscope_preload_path = get(a:var, 'preload_path', '')
  let g:cscope_list_files_command = get(a:var, 'list_files_command', s:list_files_command)

endfunction

function! SpaceVim#layers#ai#get_options() abort

  return [
        \ 'filetree_closed_icon',
        \ 'filetree_opened_icon',
        \ 'filetree_show_hidden',
        \ 'enable_smooth_scrolling',
        \ 'enable_filetree_filetypeicon'
        \ ]

endfunction

function! SpaceVim#layers#ai#health() abort
  call SpaceVim#layers#ai#plugins()
  call SpaceVim#layers#ai#config()
  return 1
endfunction
