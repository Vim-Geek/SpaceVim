--=============================================================================
-- plugins.lua --- plugin manager
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')

function M.load()
  if M.enable_plug() then
    M.begin(vim.g.spacevim_plugin_bundle_dir)
    M.fetch()
    load_plugins()
    disable_plugins(vim.g.spacevim_disabled_plugins)
    M._end()
  end
end

local function extend(t1, t2)
  for k, v in ipairs(t2) do
    t1[k] = v
  end
  return t1
end

local function load_plugins()
  for _, layer in ipairs(require('spacevim.layer').get()) do
    logger.debug('init ' .. layer .. ' layer plugins list.')
    vim.g._spacevim_plugin_layer = layer
    for _, plugin in ipairs(getLayerPlugins(layer)) do
      if vim.fn.len(plugin) == 2 then
        M.add(plugin[1], extend(plugin[2], { overwrite = 1 }))
        if M.tab(vim.fn.split(plugin[1], '/')[-1]) and plugin[1].loadconf then
          M.defind_hooks(plugin[1], '/')
        end
        if M.tab(vim.fn.split(plugin[1], '/')[-1]) and plugin[1].loadconf_before then
          M.loadPluginBefore(plugin[1], '/')
        end
      else
        M.add(plugin[1], { overwrite = 1 })
      end
    end
  end
end

local function getLayerPlugins(layer)
  local ok, l = pcall(require, 'spacevim.layer.' .. layer)
  if ok and l.plugins ~= nil then
    return l.plugins()
  end
  return {}
end

local function loadLayerConfig(layer)
  logger.debug('load ' .. layer .. ' layer config')
  local ok, l = pcall(require, 'spacevim.layer.' .. layer)
  if ok and l.config ~= nil then
    l.config()
  end
end

local plugins_argv = { '-update', '-openurl' }

function M.complete_plugs(ArgLead, CmdLine, CursorPos)

end

function M.Plugin(...)

end

local function disable_plugins(plugin_list)

end

function M.get(...)

end

local function install_manager()

end

install_manager()

function M.begin(path)

end

-- can not use M.end
function M._end()

end

function M.defind_hooks(bundle)

end

function M.fetch()

end

local plugins = {}

local function parser(args)

end

vim.g._spacevim_plugins = {}

function M.add(repo, ...)

end

function M.tap(plugin)

end

function M.enable_plug()

end

function M.loadPluginBefore(plugin)

end

function M.existed_plugin(name)
  local plugins = M.get_plugin(name)

  return plugins ~= nil
end

function M.get_plugin(name)
  if name == nil or name == "" then
    return nil
  else
    local plugin = get_plugin(name)
    if is_empty_dict(plugin) then
      local words = split(name, "/")
      local repo_name
      if #words >= 2 then
        repo_name = words[2]
      else
        repo_name = words[1]
      end
      plugin = get_plugin(repo_name)
      if is_empty_dict(plugin) then
        return nil
      else
        local repo = plugin.repo
        if repo == name then
          return plugin
        else
          return nil
        end
      end
    else
      return plugin
    end
  end
end

function is_empty_dict(tbl)
  return tostring(tbl) == "vim.empty_dict()"
end

function get_plugin(name)
  return vim.fn["dein#get"](name)
end

function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

return M
