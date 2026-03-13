-- lua/custom/plugins/dashboard.lua
-- ╔══════════════════════════════════════════╗
-- ║   ALHABIB IDE — Ultra Modern Dashboard  ║
-- ╚══════════════════════════════════════════╝

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- ── Safe project opener ──────────────────────────────────────
    local function open_project_dir(dir)
      if _G.OpenProjectDir then
        _G.OpenProjectDir(dir)
      else
        vim.api.nvim_set_current_dir(dir)
        vim.defer_fn(function() vim.cmd('Neotree filesystem reveal dir=' .. vim.fn.fnameescape(dir) .. ' left show') end, 60)
      end
    end

    -- ── Collect recent .NET projects ─────────────────────────────
    local function get_recent_projects()
      local results = {}
      local seen_dirs = {}
      local oldfiles = vim.v.oldfiles or {}
      for _, file in ipairs(oldfiles) do
        if #results >= 5 then break end
        local dir = vim.fn.fnamemodify(file, ':h')
        local ext = vim.fn.fnamemodify(file, ':e')
        if not seen_dirs[dir] and (ext == 'cs' or ext == 'sln' or ext == 'csproj') then
          seen_dirs[dir] = true
          local short = vim.fn.fnamemodify(dir, ':~')
          if #short > 42 then short = '...' .. short:sub(-40) end
          table.insert(results, { path = dir, label = short })
        end
      end
      return results
    end

    -- ── Time-based greeting ───────────────────────────────────────
    local function greeting()
      local hour = tonumber(os.date '%H')
      if hour < 6 then
        return '  Good Night'
      elseif hour < 12 then
        return '  Good Morning'
      elseif hour < 17 then
        return '  Good Afternoon'
      else
        return '  Good Evening'
      end
    end

    -- ════════════════════════════════════════════════════════════════
    --  HEADER  — ALHABIB IDE
    -- ════════════════════════════════════════════════════════════════
    local header = {
      '',
      '',
      '',
      '   ░█████╗░██╗░░░░░██╗░░██╗░█████╗░██████╗░██╗██████╗░',
      '   ██╔══██╗██║░░░░░██║░░██║██╔══██╗██╔══██╗██║██╔══██╗',
      '   ███████║██║░░░░░███████║███████║██████╦╝██║██████╦╝',
      '   ██╔══██║██║░░░░░██╔══██║██╔══██║██╔══██╗██║██╔══██╗',
      '   ██║░░██║███████╗██║░░██║██║░░██║██████╦╝██║██████╦╝',
      '   ╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚═╝╚═════╝░',
      '',
      '              ░░░  I D E  ·  v 2 0 2 5  ░░░            ',
      '',
      '   ╔─────────────────────────────────────────────────╗',
      '   │    .NET  ·  C#  ·  Blazor  ·  ASP.NET  ·  MAUI  │',
      '   ╚─────────────────────────────────────────────────╝',
      '',
      '   ' .. greeting() .. '  ·  ' .. os.date '%A, %d %B %Y' .. '  ·  ' .. os.date '%H:%M',
      '',
    }

    -- ════════════════════════════════════════════════════════════════
    --  CENTER MENU
    -- ════════════════════════════════════════════════════════════════
    local items = {
      {
        icon = '  ',
        desc = 'Open Project                          ',
        key = 'p',
        key_format = '  [%s]',
        action = 'lua OpenDotnetProject()',
      },
      {
        icon = '  ',
        desc = 'New File                              ',
        key = 'n',
        key_format = '  [%s]',
        action = 'ene | startinsert',
      },
      {
        icon = '  ',
        desc = 'Find File                             ',
        key = 'f',
        key_format = '  [%s]',
        action = 'Telescope find_files',
      },
      {
        icon = '  ',
        desc = 'Recent Files                          ',
        key = 'r',
        key_format = '  [%s]',
        action = 'Telescope oldfiles',
      },
      {
        icon = '  ',
        desc = 'Search in Project                     ',
        key = 's',
        key_format = '  [%s]',
        action = 'Telescope live_grep',
      },
      {
        icon = '  ',
        desc = 'Git Status                            ',
        key = 'g',
        key_format = '  [%s]',
        action = 'Telescope git_status',
      },
      {
        icon = '  ',
        desc = 'Settings                              ',
        key = ',',
        key_format = '  [%s]',
        action = 'edit ' .. vim.fn.stdpath 'config' .. '/init.lua',
      },
      {
        icon = '  ',
        desc = 'Plugin Manager                        ',
        key = 'l',
        key_format = '  [%s]',
        action = 'Lazy',
      },
      {
        icon = '  ',
        desc = 'LSP Servers                           ',
        key = 'm',
        key_format = '  [%s]',
        action = 'Mason',
      },
      {
        icon = '  ',
        desc = 'Quit                                  ',
        key = 'q',
        key_format = '  [%s]',
        action = 'qa',
      },
    }

    -- Inject recent projects after index 3 (after "Find File")
    local recent = get_recent_projects()
    if #recent > 0 then
      for i, proj in ipairs(recent) do
        table.insert(items, 3 + i, {
          icon = '  ',
          desc = proj.label,
          key = tostring(i),
          key_format = '  [%s]',
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
            '   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
            '     ALHABIB IDE  ·  Neovim ' .. ver .. '  ·  ' .. plugins .. ' plugins active',
            '   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
            '',
          }
        end,
      },
    }

    -- ════════════════════════════════════════════════════════════════
    --  HIGHLIGHTS — Cyberpunk / Electric Blue palette
    -- ════════════════════════════════════════════════════════════════
    local hl = vim.api.nvim_set_hl

    hl(0, 'DashboardHeader', { fg = '#00d4ff', bold = true })
    hl(0, 'DashboardCenter', { fg = '#c0caf5' })
    hl(0, 'DashboardIcon', { fg = '#7dcfff', bold = true })
    hl(0, 'DashboardDesc', { fg = '#a9b1d6' })
    hl(0, 'DashboardShortCut', { fg = '#bb9af7', bold = true })
    hl(0, 'DashboardKey', { fg = '#ff007c', bold = true })
    hl(0, 'DashboardFooter', { fg = '#3d59a1', italic = true })
  end,
}
