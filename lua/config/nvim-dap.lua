--!/usr/bin/lua

local dap = require("dap")
local widgets = require('dap.ui.widgets')

-- local adapters_root_path = vim.fn.stdpath("data") .. "/mason/packages/"

vim.api.nvim_set_hl(0, 'YellowCursor', { fg = '#FFCC00', bg = None, bold = true })
vim.api.nvim_set_hl(0, 'RedCursor', { fg = '#FF5555', bg = None, bold = true })
vim.api.nvim_set_hl(0, 'BlueCursor', { fg = "#268BD2", bg = None, bold = true })
vim.api.nvim_set_hl(0, 'GreenCursor', { fg = "#62C554", bg = None, bold = true })
vim.api.nvim_set_hl(0, 'RedLine', { bg = '#6B3F69' })
vim.api.nvim_set_hl(0, 'ConditionalLine', { bg = '#B95E82' })
vim.api.nvim_set_hl(0, 'StoppedLine', { bg = '#476EAE' })

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'RedCursor', linehl = 'RedLine', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'RedCursor', linehl = 'ConditionalLine', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'YellowCursor', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'GreenCursor', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '⭃', texthl = 'BlueCursor', linehl = 'StoppedLine', numhl = '' })

vim.keymap.set('n', '<F3>', function() dap.pause() end)
vim.keymap.set('n', '<F4>', function() dap.disconnect({ terminateDebuggee = true }) end)
-- Refer: persistent-breakpoints.lua
-- vim.keymap.set("n", "<F5>", function() pb_api.toggle_breakpoint() end)
-- vim.keymap.set("n", "<F6>", function() pb_api.set_conditional_breakpoint() end)
-- vim.keymap.set("n", "<F7>", function() pb_api.set_log_point() end)
vim.keymap.set('n', '<F8>', function() widgets.hover() end)
vim.keymap.set('n', '<F9>', function() dap.continue() end)
-- <S-F9>
vim.keymap.set('n', '<F21>', function()
  require("dap").terminate()
  require("dapui").close()
  require("nvim-dap-virtual-text").toggle()
end)
-- vim.keymap.set('n', '<F21>', function() dap.reverse_continue() end)
vim.keymap.set('n', '<F10>', function() dap.step_over() end)
vim.keymap.set('n', '<F11>', function() dap.step_into() end)
-- <S-F11>
vim.keymap.set('n', '<F23>', function() dap.step_out() end)

-- vim.api.nvim_create_autocmd({ 'FileType' }, { pattern = 'dap-repl', callback = function() require('dap.ext.autocompl').attach() end

for i, value in ipairs(dap.configurations.rust) do
  value.program = function()
    local cmd = ''
    if vim.fn.expand("%:h:t") == "examples" then
      local example_name = vim.fn.expand("%:t:r")
      cmd = 'examples/' .. example_name
      vim.fn.system('RUSTFLAGS=-g cargo build --example=' .. example_name)
    else
      cmd = vim.fn.fnamemodify(vim.uv.cwd(), ':t')
      vim.fn.system('RUSTFLAGS=-g cargo build')
    end
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/' .. cmd, 'file')
  end
end

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap.listeners.before['event_progressStart']['progress-notifications'] = function(session, body)
  local notif_data = get_notif_data("dap", body.progressId)

  local message = format_message(body.message, body.percentage)
  notif_data.notification = vim.notify(message, "info", {
    title = format_title(body.title, session.config.type),
    icon = spinner_frames[1],
    timeout = false,
    hide_from_history = false,
  })

  notif_data.notification.spinner = 1
  update_spinner("dap", body.progressId)
end

dap.listeners.before['event_progressUpdate']['progress-notifications'] = function(session, body)
  local notif_data = get_notif_data("dap", body.progressId)
  notif_data.notification = vim.notify(format_message(body.message, body.percentage), "info", {
    replace = notif_data.notification,
    hide_from_history = false,
  })
end

dap.listeners.before['event_progressEnd']['progress-notifications'] = function(session, body)
  local notif_data = client_notifs["dap"][body.progressId]
  notif_data.notification = vim.notify(body.message and format_message(body.message) or "Complete", "info", {
    icon = "",
    replace = notif_data.notification,
    timeout = 3000
  })
  notif_data.spinner = nil
end

-- dap.configurations.c = {
-- {
-- name = "Launch",
-- type = "gdb",
-- request = "launch",
-- program = function()
-- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
-- end,
-- args = {}, -- provide arguments if needed
-- cwd = "${workspaceFolder}",
-- stopAtBeginningOfMainSubprogram = false,
-- },
-- {
-- name = "Select and attach to process",
-- type = "gdb",
-- request = "attach",
-- program = function()
-- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
-- end,
-- pid = function()
-- local name = vim.fn.input('Executable name (filter): ')
-- return require("dap.utils").pick_process({ filter = name })
-- end,
-- cwd = '${workspaceFolder}'
-- },
-- {
-- name = 'Attach to gdbserver :1234',
-- type = 'gdb',
-- request = 'attach',
-- target = 'localhost:1234',
-- program = function()
-- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
-- end,
-- cwd = '${workspaceFolder}'
-- }
-- }

-- dap.configurations.cpp = dap.configurations.c

-- dap.configurations.rust = {
-- {
-- name = "Launch file",
-- type = "codelldb",
-- request = "launch",
-- program = function()
-- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
-- end,
-- cwd = '${workspaceFolder}',
-- stopOnEntry = false
-- },
-- }

-- dap.configurations.rust = dap.configurations.c

-- dap.configurations.rust = {
-- {
-- name = "Launch",
-- type = "rust-gdb",
-- request = "launch",
-- program = function()
-- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
-- end,
-- args = {}, -- provide arguments if needed
-- cwd = "${workspaceFolder}",
-- stopOnEntry = true,
-- stopAtBeginningOfMainSubprogram = true,
-- },
-- {
-- name = "Select and attach to process",
-- type = "rust-gdb",
-- request = "attach",
-- program = function()
-- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
-- end,
-- pid = function()
-- local name = vim.fn.input('Executable name (filter): ')
-- return require("dap.utils").pick_process({ filter = name })
-- end,
-- cwd = "${workspaceFolder}"
-- },
-- {
-- name = "Attach to gdbserver :1234",
-- type = "rust-gdb",
-- request = "attach",
-- target = "localhost:1234",
-- program = function()
-- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
-- end,
-- cwd = '${workspaceFolder}'
-- }
-- }

-- dap.configurations.rust = {
-- {
-- name = "hello-world",
-- type = "lldb",
-- request = "launch",
-- program = function()
-- return vim.fn.getcwd() .. "/target/debug/hello-world"
-- end,
-- cwd = "${workspaceFolder}",
-- stopOnEntry = false,
-- },
-- {
-- name = "hello-dap",
-- type = "lldb",
-- request = "launch",
-- program = function()
-- return vim.fn.getcwd() .. "/target/debug/hello-dap"
-- end,
-- cwd = "${workspaceFolder}",
-- stopOnEntry = false,
-- },
-- }
