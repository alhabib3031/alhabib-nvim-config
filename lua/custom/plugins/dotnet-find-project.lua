-- lua/custom/plugins/dotnet-find-project.lua
-- Fast async project opener — fixes the slow Neotree loading issue

local projects_path = 'C:/Users/alhab/NvimProjects'

-- ─────────────────────────────────────────────────────────────
-- Core: open a project directory in Neotree quickly
-- The old approach called Neotree synchronously after Telescope
-- closed, which caused a full re-render freeze.
-- Fix: use vim.schedule + defer to let Telescope fully unload
-- before Neotree initializes, and open Neotree in reveal mode
-- so it only scans the needed directory tree.
-- ─────────────────────────────────────────────────────────────
_G.OpenProjectDir = function(project_dir)
  -- Step 1: change cwd immediately
  vim.api.nvim_set_current_dir(project_dir)

  -- Step 2: defer Neotree open so Telescope can fully close first
  vim.defer_fn(function()
    -- Close any existing Neotree windows to avoid stale state
    vim.cmd 'Neotree close'

    vim.defer_fn(function() vim.cmd('Neotree filesystem reveal dir=' .. vim.fn.fnameescape(project_dir) .. ' left show') end, 50) -- 50ms is enough — avoids the multi-second freeze
  end, 10)
end

_G.OpenDotnetProject = function()
  local ok_telescope, telescope = pcall(require, 'telescope.builtin')
  if not ok_telescope then
    vim.notify('Telescope not available', vim.log.levels.ERROR)
    return
  end

  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  telescope.find_files {
    prompt_title = '  Open .NET Solution / Project',
    cwd = projects_path,

    -- Use fd to find only solution/project files, exclude build artifacts
    find_command = {
      'fd',
      '--type',
      'f',
      '-e',
      'sln',
      '-e',
      'csproj',
      '--exclude',
      'bin',
      '--exclude',
      'obj',
      '--exclude',
      '.git',
      '--exclude',
      'node_modules',
    },

    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if not selection then return end

        local file_path = selection.path or selection[1]
        -- For .sln → open solution root; for .csproj → open project folder
        local project_dir = vim.fn.fnamemodify(file_path, ':p:h')

        -- Close Telescope first
        actions.close(prompt_bufnr)

        -- Then open project asynchronously
        vim.schedule(function() _G.OpenProjectDir(project_dir) end)
      end)
      return true
    end,
  }
end

-- ─────────────────────────────────────────────────────────────
-- Quick-open recent .NET projects from oldfiles list
-- ─────────────────────────────────────────────────────────────
_G.OpenRecentDotnetProject = function()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local seen = {}
  local dirs = {}
  for _, f in ipairs(vim.v.oldfiles or {}) do
    local ext = vim.fn.fnamemodify(f, ':e')
    local dir = vim.fn.fnamemodify(f, ':h')
    if not seen[dir] and (ext == 'cs' or ext == 'sln' or ext == 'csproj') then
      if vim.fn.isdirectory(dir) == 1 then
        seen[dir] = true
        table.insert(dirs, dir)
      end
    end
    if #dirs >= 10 then break end
  end

  if #dirs == 0 then
    vim.notify('No recent .NET projects found', vim.log.levels.INFO)
    return
  end

  pickers
    .new({}, {
      prompt_title = '  Recent .NET Projects',
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
