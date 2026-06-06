-- lua/custom/project_creator.lua
-- Dashboard project creation wizard (supports .NET, Lua, Web, Python, Bicep)

local M = {}

local languages = { '.NET', 'Lua', 'Web', 'Python', 'Bicep' }
local dotnet_templates = { 'webapi', 'blazor', 'mvc', 'console', 'classlib' }

local function run_in_toggleterm(cmds)
  local ok, Terminal = pcall(require, 'toggleterm.terminal')
  if ok and Terminal and Terminal.Terminal then
    local TerminalClass = Terminal.Terminal
    local t = TerminalClass:new({ cmd = table.concat(cmds, ' && '), direction = 'float', close_on_exit = false })
    t:toggle()
    return true
  end

  -- Fallback: run as a system call and show output
  for _, c in ipairs(cmds) do
    vim.notify('Running: ' .. c, vim.log.levels.INFO)
    local out = vim.fn.systemlist(c)
    vim.notify(table.concat(out, '\n'), vim.log.levels.INFO)
  end
  return false
end

function M.new_project()
  vim.ui.select(languages, { prompt = 'Select language/environment:' }, function(choice)
    if not choice then return end
    if choice == '.NET' then
      local name = vim.fn.input('Project name: ')
      if name == nil or name == '' then
        vim.notify('Aborted: no name provided', vim.log.levels.INFO)
        return
      end

      vim.ui.select(dotnet_templates, { prompt = 'Select .NET template:' }, function(tpl)
        if not tpl then return end

        local sln = vim.fn.glob('*.sln')
        local cmds = {}
        table.insert(cmds, 'dotnet new ' .. tpl .. ' -n ' .. name)
        if sln == '' then
          table.insert(cmds, 'dotnet new sln -n ' .. name)
        end
        table.insert(cmds, 'dotnet sln add ' .. name .. '/' .. name .. '.csproj')

        run_in_toggleterm(cmds)
      end)

    elseif choice == 'Lua' then
      local name = vim.fn.input('Module / project name: ')
      if name == '' then return end
      local path = name
      vim.fn.mkdir(path, 'p')
      vim.fn.writefile({'-- init.lua for ' .. name}, path .. '/init.lua')
      vim.notify('Created Lua project skeleton: ' .. path, vim.log.levels.INFO)

    elseif choice == 'Web' then
      local name = vim.fn.input('Project name: ')
      if name == '' then return end
      local cmds = {
        'mkdir -p ' .. name,
        'cd ' .. name .. ' && echo "<!doctype html>\n<html><head><meta charset=\"utf-8\"></head><body></body></html>" > index.html'
      }
      run_in_toggleterm(cmds)

    elseif choice == 'Python' then
      local name = vim.fn.input('Project name: ')
      if name == '' then return end
      local cmds = {
        'mkdir -p ' .. name,
        'cd ' .. name .. ' && python -m venv .venv'
      }
      run_in_toggleterm(cmds)

    elseif choice == 'Bicep' then
      local name = vim.fn.input('Project name: ')
      if name == '' then return end
      local path = name
      vim.fn.mkdir(path, 'p')
      vim.fn.writefile({ '// main.bicep' }, path .. '/main.bicep')
      vim.notify('Created Bicep project skeleton: ' .. path, vim.log.levels.INFO)
    end
  end)
end

return M
