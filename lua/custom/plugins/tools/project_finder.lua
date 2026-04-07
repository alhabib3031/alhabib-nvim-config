-- lua/custom/plugins/tools/project_finder.lua
-- Extended Project Opener — Generalized for all projects

local projects_path = 'C:/Users/alhab/NvimProjects'

-- ─────────────────────────────────────────────────────────────
-- Core: open a project directory in Neotree quickly
-- ─────────────────────────────────────────────────────────────
_G.OpenProjectDir = function(project_dir)
  -- Step 1: Normalize path (replace \ with / and get absolute path)
  local normalized_path = project_dir:gsub("\\", "/"):gsub("//", "/")
  normalized_path = vim.fn.fnamemodify(normalized_path, ":p")
  
  -- Remove trailing slash if present
  if normalized_path:sub(-1) == "/" then
    normalized_path = normalized_path:sub(1, -2)
  end

  -- Step 2: change cwd immediately
  vim.api.nvim_set_current_dir(normalized_path)

  -- Step 3: defer Neotree open so Telescope can fully close first
  vim.defer_fn(function()
    -- Close any existing Neotree windows to avoid stale state
    vim.cmd 'Neotree close'

    vim.defer_fn(function() 
      -- Use the official Lua API which is more robust for paths with spaces/mixed slashes
      require("neo-tree.command").execute({
        action = "show",
        source = "filesystem",
        position = "left",
        dir = normalized_path,
        reveal = true,
      })
    end, 50)
  end, 10)
end

-- ─────────────────────────────────────────────────────────────
-- Open Any Folder (Generalized Directory Picker)
-- ─────────────────────────────────────────────────────────────
_G.OpenProject = function()
  local ok_telescope, telescope = pcall(require, 'telescope.builtin')
  if not ok_telescope then
    vim.notify('Telescope not available', vim.log.levels.ERROR)
    return
  end

  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  -- Use find_files but select the directory of the file
  telescope.find_files {
    prompt_title = '  Open Project (Select any file/folder)',
    cwd = projects_path,
    find_command = { 'fd', '--type', 'd', '--max-depth', '3', '--exclude', '.git', '--exclude', 'bin', '--exclude', 'obj' },
    
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if not selection then return end

        local project_dir = selection.path or selection[1]
        
        -- If it's a file, get its directory; if it's already a directory, use it
        if vim.fn.isdirectory(project_dir) == 0 then
          project_dir = vim.fn.fnamemodify(project_dir, ':p:h')
        end

        actions.close(prompt_bufnr)
        vim.schedule(function() _G.OpenProjectDir(project_dir) end)
      end)
      return true
    end,
  }
end

-- ─────────────────────────────────────────────────────────────
-- Standard "Find Files" in Projects (for quick access)
-- ─────────────────────────────────────────────────────────────
_G.FindInProjects = function()
  require('telescope.builtin').find_files({
    prompt_title = '  Find File in All Projects',
    cwd = projects_path,
  })
end

-- ─────────────────────────────────────────────────────────────
-- Quick-open recent projects from oldfiles list
-- ─────────────────────────────────────────────────────────────
_G.OpenRecentProject = function()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local seen = {}
  local dirs = {}
  for _, f in ipairs(vim.v.oldfiles or {}) do
    local dir = vim.fn.fnamemodify(f, ':h')
    if not seen[dir] and dir:find(projects_path, 1, true) then
      if vim.fn.isdirectory(dir) == 1 then
        seen[dir] = true
        table.insert(dirs, dir)
      end
    end
    if #dirs >= 15 then break end
  end

  if #dirs == 0 then
    vim.notify('No recent projects found in ' .. projects_path, vim.log.levels.INFO)
    return
  end

  pickers
    .new({}, {
      prompt_title = '  Recent Projects',
      finder = finders.new_table {
        results = dirs,
        entry_maker = function(dir)
          return {
            value = dir,
            display = vim.fn.fnamemodify(dir, ':~'),
            ordinal = dir,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then vim.schedule(function() _G.OpenProjectDir(entry.value) end) end
        end)
        return true
      end,
    })
    :find()
end

return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
}
