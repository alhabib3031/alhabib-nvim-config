-- lua/custom/plugins/dashboard.lua
-- ╔══════════════════════════════════════════╗
-- ║   ALHABIB IDE — Ultra Modern Dashboard  ║
-- ╚══════════════════════════════════════════╝

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- ── Actions from dotnet_actions.lua ─────────────────────────
    local actions_mod = require('custom.dotnet_actions')

    -- ── Safe project opener ──────────────────────────────────────
    local function open_project_dir(dir)
      if _G.OpenProjectDir then
        _G.OpenProjectDir(dir)
      else
        vim.api.nvim_set_current_dir(dir)
        vim.defer_fn(function() 
          vim.cmd('Neotree filesystem reveal dir=' .. vim.fn.fnameescape(dir) .. ' left show') 
        end, 60)
      end
    end

    -- ── Collect recent .NET projects (styled like Rider) ─────────
    local function get_recent_projects()
      local results = {}
      local seen_dirs = {}
      local oldfiles = vim.v.oldfiles or {}
      for _, file in ipairs(oldfiles) do
        if #results >= 7 then break end
        local dir = vim.fn.fnamemodify(file, ':p:h')
        local ext = vim.fn.fnamemodify(file, ':e')
        
        if not seen_dirs[dir] and (ext == 'cs' or ext == 'sln' or ext == 'csproj' or ext == 'cshtml' or ext == 'razor') then
          seen_dirs[dir] = true
          local label = vim.fn.fnamemodify(dir, ':t')
          if label == '' then label = 'Solution' end
          
          local path = vim.fn.fnamemodify(dir, ':~')
          if #path > 60 then path = '...' .. path:sub(-57) end
          
          table.insert(results, { path = dir, label = label, full_path = path })
        end
      end
      return results
    end

    -- ════════════════════════════════════════════════════════════════
    --  HEADER  — ALHABIB IDE (Premium 2026)
    -- ════════════════════════════════════════════════════════════════
    local header = {
      '',
      '   █████╗ ██╗     ██╗  ██╗ █████╗ ██████╗ ██╗██████╗    ██╗██████╗ ███████╗',
      '  ██╔══██╗██║     ██║  ██║██╔══██╗██╔══██╗██║██╔══██╗   ██║██╔══██╗██╔════╝',
      '  ███████║██║     ███████║███████║██████╔╝██║██████╔╝   ██║██║  ██║█████╗  ',
      '  ██╔══██║██║     ██╔══██║██╔══██║██╔══██╗██║██╔══██╗   ██║██║  ██║██╔══╝  ',
      '  ██║  ██║███████╗██║  ██║██║  ██║██████╔╝██║██████╔╝   ██║██████╔╝███████╗',
      '  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═════╝    ╚═╝╚═════╝ ╚══════╝',
      '',
      '              ░░░  A L H A B I B  ·  I D E  ·  2 0 2 6  ░░░',
      '',
    }

    -- ════════════════════════════════════════════════════════════════
    --  CENTER MENU — Global Actions (Buttons)
    -- ════════════════════════════════════════════════════════════════
    local items = {
      {
        icon = '󰌛 ',
        desc = ' New Solution                          ',
        key = 'n',
        shortcut = 'N',
        action = function() actions_mod.new_solution() end,
      },
      {
        icon = '󰂬 ',
        desc = ' Open Project                          ',
        key = 'o',
        shortcut = 'O',
        action = 'lua OpenDotnetProject()',
      },
      {
        icon = ' ',
        desc = ' Clone Repository                      ',
        key = 'c',
        shortcut = 'C',
        action = function() actions_mod.clone_repo() end,
      },
      {
        icon = ' ',
        desc = ' Search Projects (Fuzzy)               ',
        key = 'f',
        shortcut = 'F',
        action = 'Telescope find_files',
      },
      {
        icon = '⚙ ',
        desc = ' Settings                              ',
        key = ',',
        shortcut = ',',
        action = 'edit ' .. vim.fn.stdpath 'config' .. '/init.lua',
      },
      {
        icon = ' ',
        desc = ' Quit                                  ',
        key = 'q',
        shortcut = 'Q',
        action = 'qa',
      },
    }

    -- Inject recent projects with Rider-style formatting
    local recent = get_recent_projects()
    if #recent > 0 then
      table.insert(items, 5, { desc = '── Recent Projects ──────────────────────────────────────────', action = '' })
      for i, proj in ipairs(recent) do
        local pad = string.rep(' ', math.max(0, 40 - #proj.label))
        table.insert(items, 5 + i, {
          icon = ' ',
          desc = ' ' .. proj.label .. pad .. '  ' .. proj.full_path,
          key = tostring(i),
          action = function() open_project_dir(proj.path) end,
        })
      end
    end

    -- ════════════════════════════════════════════════════════════════
    --  SETUP
    -- ════════════════════════════════════════════════════════════════
    require('dashboard').setup {
      theme = 'doom',
      hide = { statusline = true, tabline = true, winbar = true },
      config = {
        header = header,
        center = items,
        footer = function()
          local v = vim.version()
          local ver = string.format('%d.%d.%d', v.major, v.minor, v.patch)
          local ok, lazy = pcall(require, 'lazy')
          local plugins = ok and tostring(lazy.stats().loaded) or '?'
          return {
            '',
            '   ⚡ Neovim ' .. ver .. ' · Loaded ' .. plugins .. ' plugins · ALHABIB IDE 2026',
            '',
          }
        end,
      },
    }

    -- ════════════════════════════════════════════════════════════════
    --  HIGHLIGHTS
    -- ════════════════════════════════════════════════════════════════
    local hl = vim.api.nvim_set_hl

    hl(0, 'DashboardHeader', { fg = '#569CD6', bold = true }) -- Rider/VSC Blue
    hl(0, 'DashboardCenter', { fg = '#D4D4D4' }) -- Text color
    hl(0, 'DashboardIcon', { fg = '#4EC9B0', bold = true }) -- Projects Green/Teal
    hl(0, 'DashboardDesc', { fg = '#9CDCFE' }) -- Description Blue
    hl(0, 'DashboardShortCut', { fg = '#C586C0', bold = true }) -- Keymaps
    hl(0, 'DashboardFooter', { fg = '#6A9955', italic = true }) -- Green info
    hl(0, 'DashboardKey', { fg = '#D7BA7D', bold = true }) -- Keyboard keys
  end,
}
