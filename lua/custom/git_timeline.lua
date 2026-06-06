-- lua/custom/git_timeline.lua
-- Lightweight Git timeline viewer (top split) + mini terminal (bottom)

local M = {}
local uv = vim.loop

local projects_path = 'C:/Users/alhab/NvimProjects'

local function git_log_lines()
  local cmd = 'git --no-pager log --graph --pretty=format:"%h %s (%cr)" --abbrev-commit --decorate --all'
  local ok = vim.fn.executable('git') == 1
  if not ok then return { 'git not available in PATH' } end
  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return { 'No git repository or git failed' }
  end
  return lines
end

function M.open_git_timeline(dir)
  if dir and dir ~= '' then
    local normalized = dir:gsub('\\', '/')
    pcall(vim.api.nvim_set_current_dir, normalized)
  end

  -- Create a new tab for timeline
  vim.cmd('tabnew')

  -- Top buffer for git log
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'gitgraph')

  -- Place top buffer in window
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.55))

  local function refresh()
    if not vim.api.nvim_buf_is_valid(buf) then return end
    local lines = git_log_lines()
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  end

  refresh()

  -- Terminal at bottom
  vim.cmd('belowright split')
  vim.cmd('resize 10')
  vim.cmd('terminal')

  -- Timer to refresh git buffer every 2 seconds
  local timer = uv.new_timer()
  timer:start(2000, 2000, vim.schedule_wrap(function()
    if vim.api.nvim_buf_is_valid(buf) then
      refresh()
    else
      pcall(timer.stop, timer)
      pcall(timer.close, timer)
    end
  end))

  -- Stop timer when buffer is wiped
  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = buf,
    callback = function()
      if timer and not timer:is_closing() then
        pcall(timer.stop, timer)
        pcall(timer.close, timer)
      end
    end,
  })

  -- Enter key opens Diffview for the commit on that line
  vim.keymap.set('n', '<CR>', function()
    local line = vim.api.nvim_get_current_line()
    local hash = line:match('(%x+)')
    if not hash then
      vim.notify('No commit hash on this line', vim.log.levels.WARN)
      return
    end
    pcall(vim.cmd, 'DiffviewOpen ' .. hash)
  end, { buffer = buf, desc = 'Open commit in Diffview' })

  return buf
end

function M.git_projects_picker()
  local ok_telescope, telescope = pcall(require, 'telescope.builtin')
  if not ok_telescope then
    vim.notify('Telescope not available', vim.log.levels.ERROR)
    return
  end

  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  telescope.find_files {
    prompt_title = '  Open Project (Select any file/folder)',
    cwd = projects_path,
    find_command = { 'fd', '--type', 'd', '--max-depth', '3', '--exclude', '.git', '--exclude', 'bin', '--exclude', 'obj' },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if not selection then return end

        local project_dir = selection.path or selection[1]
        if vim.fn.isdirectory(project_dir) == 0 then
          project_dir = vim.fn.fnamemodify(project_dir, ':p:h')
        end

        actions.close(prompt_bufnr)
        vim.schedule(function()
          M.open_git_timeline(project_dir)
        end)
      end)
      return true
    end,
  }
end

return M
