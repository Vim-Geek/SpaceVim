--!/usr/bin/lua

local M = {}

function M.setup()
  require('hop').setup {
    keys = 'asdfghjkl;\'qwertyuiopvbn',
    quit_key = 'z',
    uppercase_labels = true,
  }
end

return M
