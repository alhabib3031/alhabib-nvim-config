-- lua/custom/dotnet_actions.lua
-- Helper actions for Dashboard (New Solution, Clone Repos)

local M = {}

-- Open a floating terminal for a specific command
local function open_float_term(cmd, title)
  local Terminal = require('toggleterm.terminal').Terminal
  local term = Terminal:new({
    cmd = cmd,
    dir = 'C:/Users/alhab/NvimProjects', -- Default projects directory
    direction = 'float',
    float_opts = {
      border = 'rounded',
      title = title or ' Action ',
      title_pos = 'center',
    },
    hidden = true,
    close_on_exit = false, -- Keep it open so user can see result
  })
  term:toggle()
end

-- New .NET Solution
M.new_solution = function()
  vim.ui.input({ prompt = ' Solution Name: ', default = 'MyProject' }, function(name)
    if not name or name == '' then return end
    vim.ui.select({ 'console', 'classlib', 'web', 'webapi', 'maui', 'blazor', 'xunit' }, {
      prompt = ' Select Project Type: ',
    }, function(choice)
      if not choice then return end
      
      -- Command to create folder, init solution, and add project
      local cmd = string.format(
        'powershell.exe -NoExit -Command "mkdir %s; cd %s; dotnet new sln -n %s; dotnet new %s -n %s; dotnet sln add %s/%s.csproj"',
        name, name, name, choice, name, name, name
      )
      
      open_float_term(cmd, ' New .NET Solution ')
    end)
  end)
end

-- Clone Repository
M.clone_repo = function()
  vim.ui.input({ prompt = ' Repository URL: ' }, function(url)
    if not url or url == '' then return end
    
    local default_name = url:match('/([^/]+)%.git$') or url:match('/([^/]+)$') or 'repo'
    
    vim.ui.input({ prompt = ' Directory Name: ', default = default_name }, function(name)
      if not name or name == '' then name = default_name end
      
      local cmd = string.format('git clone %s %s', url, name)
      open_float_term(cmd, ' Clone Repository ')
    end)
  end)
end

return M
