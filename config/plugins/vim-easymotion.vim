map \ <Plug>(easymotion-prefix)
nmap <Plug>(easymotion-prefix)j <Plug>(easymotion-next)
nmap <Plug>(easymotion-prefix)k <Plug>(easymotion-prev)

let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = "ASDFGHJKL;'WERUIOVN"
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

augroup EasyMotion
  au!
  autocmd User EasyMotionPromptBegin silent! CocDisable
  autocmd User EasyMotionPromptEnd silent! CocEnable
augroup END
