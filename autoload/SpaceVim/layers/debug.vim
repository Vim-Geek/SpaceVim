"=============================================================================
" debug.vim --- SpaceVim debug layer
" Copyright (c) 2016-2026 Phoenix Tsui & Contributors
" License: MIT
"=============================================================================
scriptencoding utf-8

""
" @section debug, layers-debug
" @parentsection layers
" `debug` layer debug workflow for SpaceVim. All of the functionality is based
" on dap
"
" @subsection layer options
"
" 1. `debugger_plugin`: set the debug engine. It can be `dap`
" 2. `debugger_ui`: set the debug ui. if `debugger_plugin = 'dap'`, It can be `dap-view`(default) or `dap-ui`
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

" values: 'dap'
let s:debugger_plugin = 'dap'
" values: 'dap-view' | 'dap-ui'
let s:debugger_ui = 'dap-view' 

function! SpaceVim#layers#debug#set_variable(var) abort
  let s:debugger_plugin = get(a:var, 'debugger_plugin', 'dap')
  let s:debugger_ui = get(a:var, 'debugger_ui', 'dap-view')
endfunction

function! SpaceVim#layers#debug#plugins() abort
  let plugins = []

  if s:debugger_plugin ==# 'dap'
    call add(plugins,['mason-org/mason.nvim', {'merged' : 0, 'loadconf': 1}])
    call add(plugins,['jay-babu/mason-nvim-dap.nvim', {'merged' : 0, 'loadconf': 1, 'depends': ['mason-org/mason.nvim']}])
    call add(plugins,['mfussenegger/nvim-dap', {'merged' : 0, 'loadconf': 1, 'depends': ['mason-nvim-dap.nvim'] }])
    call add(plugins,['nvim-neotest/nvim-nio', {'merged' : 0}])
    call add(plugins,['theHamsta/nvim-dap-virtual-text', {'merged' : 0, 'loadconf': 1, 'depends': ['mfussenegger/nvim-dap']}])
    call add(plugins,['Weissle/persistent-breakpoints.nvim', {'merged' : 0}])
    call add(plugins,['Jorenar/nvim-dap-disasm', {'merged': 0}])
    if s:debugger_ui ==# 'dap-ui'
      call add(plugins,['rcarriga/nvim-dap-ui', {'merged' : 0, 'loadconf': 1, 'depends': ['mfussenegger/nvim-dap']}])
    else
      call add(plugins,['igorlfs/nvim-dap-view', {'merged' : 0, 'loadconf': 1, 'depends': ['mfussenegger/nvim-dap']}])
    endif
  else
    throw 'Only support `dap` debug engine'
  endif

  " if g:spacevim_filemanager !=# 'vimfiler'
    " call add(plugins, ['Shougo/vimproc.vim', {'build' : [(executable('gmake') ? 'gmake' : 'make')]}])
  " endif
  return plugins
endfunction

function! SpaceVim#layers#debug#health() abort
  call SpaceVim#layers#debug#plugins()
  call SpaceVim#layers#debug#config()
  return 1
endfunction

function! s:defineCommonKeymap() abort
  " call SpaceVim#mapping#space#def('nnoremap', ['d', 'b'], 'DapToggleBreakpoint', ' Toggle Breakpoint', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'b'], 'PBToggleBreakpoint', ' Toggle Breakpoint', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'B'], 'PBSetConditionalBreakpoint', ' Toggle Conditional Breakpoint', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'c'], 'DapContinue', ' Continue Session', 1)
  " call SpaceVim#mapping#space#def('nnoremap', ['d', 'C'], 'DapClearBreakpoints', ' Clear all Breakpoints', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'C'], 'PBClearAllBreakpoints', ' Clear all Breakpoints', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'd'], 'DapDisconnnet', ' Disconnect Session', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'e'], 'DapEval', '󰫧 Evalute Expression', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'i'], 'DapStepInto', ' Step In', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'l'], 'PBSetLogPoint', ' Toggle Log Point', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'L'], 'DapShowLog', ' Show Log', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'n'], 'DapNew', ' New Session', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'o'], 'DapStepOver', ' Step Over', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'O'], 'DapStepOut', ' Step Out', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'p'], 'lua require("dap.ui.widgets").preview()', ' Preview', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'r'], 'DapRestartFrame', ' Restart Frame', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'R'], 'DapToggleRepl', ' Toggle REPL', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 't'], 'call call('. string(s:_function('s:terminate')) . ', [])', ' Terminate Session', 1)

endfunction

function! s:defineDapUIKeymap() abort
  let g:_spacevim_mappings_space.d.u = {'name' : '+UI'}
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'u', 'b'], 'lua require("dapui").float_element("breakpoints", { width = 120, height = 80, enter = true, position = "center" })', ' Breakpoints', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'u', 'k'], 'lua require("dapui").float_element("stacks", { width = 120, height = 80, enter = true, position = "center" })', ' Stacks', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'u', 'r'], 'lua require("dapui").float_element("repl", { width = 120, height = 80, enter = true, position = "center" })', ' REPL', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'u', 's'], 'lua require("dapui").float_element("scopes", { width = 120, height = 80, enter = true, position = "center" })', '󰫙 Scopes', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'u', 'w'], 'lua require("dapui").float_element("watches", { width = 120, height = 80, enter = true, position = "center" })', ' Watches', 1)
endfunction

function! s:defineDapViewKeymap() abort
  let g:_spacevim_mappings_space.d.u = {'name' : '+View'}
endfunction


function! SpaceVim#layers#debug#config() abort
  call s:defineCommonKeymap()
  if s:debugger_ui ==# 'dap-view'
    call s:defineDapViewKeymap()
  elseif s:debugger_ui ==# 'dap-ui'
    call s:defineDapUIKeymap()
  endif

  let g:_spacevim_mappings_space.d.r = {'name' : '+Run'}
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'r', 'c'], 'lua require("dap").run_to_cursor()', ' Run to cursor', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'r', 'l'], 'lua require("dap").run_last()', ' Run Last', 1)
  " call SpaceVim#mapping#space#def('nnoremap', ['d', 'r', 'r'], 'lua require("dap").restart()', '󰑙 Restart', 1)

  let g:_spacevim_mappings_space.d.v = {'name' : '+Telescope'}
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'v', 'b'], 'Telescope dap list_breakpoints', ' breakpoints', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'v', 'c'], 'Telescope dap commands', ' commands', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'v', 'C'], 'Telescope dap configurations', '漣configurations', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'v', 'f'], 'Telescope dap frames', ' frames', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'v', 'v'], 'Telescope dap variables', ' variables', 1)
endfunction

function! s:terminate() abort
  lua require("dap").terminate()
  if s:debugger_ui ==# 'dap-view'
  elseif s:debugger_ui ==# 'dap-ui'
    lua require("dapui").close()
  endif
  lua require("nvim-dap-virtual-text").toggle()
endfunction

function! SpaceVim#layers#debug#launching(ft) abort
  echom 'debug#launching'
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif
