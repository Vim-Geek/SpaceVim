"=============================================================================
" test.vim --- SpaceVim test layer
" Author: Phoenix Xu < xusiyuan841028@gmail.com >
" License: GPLv3
"=============================================================================

""
" @section test, layers-test
" @parentsection layers
" This layer allows to run tests on SpaceVim
"
" @subsection layer options
"
" @subsection Mappings
" >
"   Mode      Key         Function
"   -------------------------------------------------------------
"   normal    SPC k n     run nearest test
"   normal    SPC k f     run test file
"   normal    SPC k s     run test suite
"   normal    SPC k l     run the latest test
"   normal    SPC k v     visits the last run test file
" <

function! SpaceVim#layers#test#plugins() abort
  let plugins = []
  call add(plugins, ['janko/vim-test', {'merged' : 0}])
  call add(plugins, ['nvim-lua/plenary.nvim', {'merged' : 0}])
  call add(plugins, ['antoinemadec/FixCursorHold.nvim', {'merged' : 0}])
  call add(plugins, ['nvim-treesitter/nvim-treesitter', {'merged' : 0, 'do': 'TSUpdate'}])
  call add(plugins, ['nvim-neotest/nvim-nio', {'merged' : 0}])
  call add(plugins, ['nvim-neotest/neotest', {'merged' : 0}])
  call add(plugins, ['nvim-neotest/neotest-jest', {'merged' : 0}])
  call add(plugins, ['thenbe/neotest-playwright', {'merged' : 0}])
  call add(plugins, ['rcasia/neotest-bash', {'merged' : 0}])
  call add(plugins, ['TheSnakeWitcher/hardhat.nvim', {'merged' : 0}])
  call add(plugins, ['llllvvuu/neotest-foundry', {'merged' : 0}])

  return plugins
endfunction

function! SpaceVim#layers#test#config() abort
  let g:_spacevim_mappings_space.k = get(g:_spacevim_mappings_space, 'k',  {'name' : '+Test'})
  call SpaceVim#mapping#space#def('nnoremap', ['k', 'n'], 'lua require("neotest").run.run()', ' Nearest', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['k', 'f'], 'lua require("neotest").run.run(vim.fn.expand("%"))', ' File', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['k', 'd'], 'lua require("neotest").run.run({strategy = "dap"})', ' Debug nearest', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['k', 's'], 'lua require("neotest").run.stop()', ' Stop', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['k', 'a'], 'lua require("neotest").run.attach()', '󰁦 Attach nearest', 1)

  let g:_spacevim_mappings_space.k.w = {'name' : '+Watch'}
  call SpaceVim#mapping#space#def('nnoremap', ['k', 'w', 'f'], 'lua require("neotest").watch.toggle(vim.fn.expand("%"))', '󰷊 Watch file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['k', 'w', 'a'], 'lua require("neotest").watch.toggle(vim.fn.expand("%"))', '󱞊 Watch all', 1)

  " if s:use_ultest
    " let g:ultest_use_pty = 1
"
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'l'], 'UltestLast', 'last', 1)
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'u'], 'UltestSummary!', 'jump-to-summary', 1)
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'U'], 'UltestSummary', 'open-summary', 1)
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'k'], 'UltestStopNearest', 'stop-nearest', 1)
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'K'], 'UltestStop', 'stop', 1)
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'a'], 'UltestAttach', 'attach', 1)
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'c'], 'UltestClear', 'clear', 1)
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'd'], 'UltestDebugNearest', 'debug-nearest', 1)
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'D'], 'UltestDebug', 'debug', 1)
    " call SpaceVim#mapping#space#def('nmap', ['k', 'j'], '<Plug>(ultest-next-fail)', 'jump-to-next-failed', 0)
    " call SpaceVim#mapping#space#def('nmap', ['k', 'k'], '<Plug>(ultest-prev-fail)', 'jump-to-prev-failed', 0)
    " call SpaceVim#mapping#space#def('nmap', ['k', 'o'], '<Plug>(ultest-output-show)', 'show-output', 0)
    " call SpaceVim#mapping#space#def('nmap', ['k', 'O'], '<Plug>(ultest-output-jump)', 'jump-to-output', 0)
  " else
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'n'], 'TestNearest', 'nearest', 1)
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'f'], 'TestFile', 'file', 1)
    " call SpaceVim#mapping#space#def('nnoremap', ['k', 'l'], 'TestLast', 'last', 1)
  " endif
"
  " call SpaceVim#mapping#space#def('nnoremap', ['k', 's'], 'TestSuite', 'suite', 1)
  " call SpaceVim#mapping#space#def('nnoremap', ['k', 'v'], 'TestVisit', 'visit', 1)
  " let g:test#custom_strategies = {'spacevim': function('SpaceVim#plugins#runner#open')}
  " let g:test#strategy = 'spacevim'
endfunction

function! SpaceVim#layers#test#set_variable(var) abort
  let l:override = get(a:var, 'override_config', {})
  if !empty(l:override)
    for l:option in keys(l:override)
      let l:varname = 'test#'.substitute(l:option, '_', '#', 'g')
      execute 'let g:'.l:varname.' = '."'".l:override[l:option]."'"
    endfor
  endif

  " let s:use_ultest = get(a:var, 'use_ultest', s:use_ultest)
endfunction

function! SpaceVim#layers#test#health() abort
  call SpaceVim#layers#test#plugins()
  call SpaceVim#layers#test#config()
  return 1
endfunction
