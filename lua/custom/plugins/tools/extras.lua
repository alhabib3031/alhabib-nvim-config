-- lua/custom/plugins/extras.lua
-- ══════════════════════════════════════════════════════════════
-- Extra features inspired by ramboe dotfiles — not in 
-- your current setup:
--   1. git-conflict.nvim  — Visual Git conflict resolution
--   2. centerpad.nvim     — Center code (lightweight Zen mode)
--   3. oil.nvim           — File explorer that works like an editable buffer
-- ══════════════════════════════════════════════════════════════

return {

  -- ── 1. git-conflict.nvim ─────────────────────────────────────
  -- Shows merge conflicts with clear colors
  -- Automatic mappings:
  --   co = accept current change (ours)
  --   ct = accept incoming change (theirs)
  --   cb = accept both
  --   c0 = reject both
  --   ]x / [x = navigate between conflicts
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPre",
    config = function()
      require("git-conflict").setup({
        default_mappings = true,
        default_commands  = true,
        disable_diagnostics = false,
        list_opener = "copen",
        highlights = {
          incoming = "DiffAdd",
          current  = "DiffText",
        },
      })
    end,
  },

  -- ── 2. centerpad.nvim ────────────────────────────────────────
  -- Centers code in the middle of the screen — useful for focused writing
  -- Shortcut: <leader>z
  {
    "smithbm2316/centerpad.nvim",
    cmd  = "Centerpad",
    keys = {
      {
        "<leader>z",
        function()
          require("centerpad").toggle({ leftpad = 22, rightpad = 22 })
        end,
        desc = "[Z]en: Toggle centerpad",
      },
    },
  },

  -- ── 3. oil.nvim ──────────────────────────────────────────────
  -- File browser that works as a text buffer — you can edit/delete/move files
  -- the same way you edit text in vim
  -- Shortcut: <A-a> to open floating window
  -- Does not replace neo-tree — they work together
  {
    "stevearc/oil.nvim",
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
    keys = {
      {
        "<A-a>",
        function() require("oil").open_float() end,
        desc = "Oil: Float file explorer",
      },
    },
    opts = {
      default_file_explorer = false, -- neo-tree remains primary explorer
      columns               = { "icon" },

      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },

      win_options = {
        wrap          = false,
        signcolumn    = "no",
        cursorcolumn  = false,
        foldcolumn    = "0",
        spell         = false,
        list          = false,
        conceallevel  = 3,
        concealcursor = "nvic",
      },

      delete_to_trash                 = false,
      skip_confirm_for_simple_edits   = false,
      prompt_save_on_select_new_entry = true,
      cleanup_delay_ms                = 2000,

      lsp_file_methods = {
        timeout_ms       = 1000,
        autosave_changes = false,
      },

      constrain_cursor  = "editable",
      watch_for_changes = false,

      keymaps = {
        ["g?"]    = "actions.show_help",
        ["<CR>"]  = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true },   desc = "Open vertical split" },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open horizontal split" },
        ["<C-t>"] = { "actions.select", opts = { tab = true },        desc = "Open in new tab" },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"]     = "actions.parent",
        ["_"]     = "actions.open_cwd",
        ["`"]     = "actions.cd",
        ["~"]     = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to oil dir" },
        ["gs"]    = "actions.change_sort",
        ["gx"]    = "actions.open_external",
        ["g."]    = "actions.toggle_hidden",
        ["g\\"]   = "actions.toggle_trash",
      },

      use_default_keymaps = true,

      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, _)
          return vim.startswith(name, ".")
        end,
        is_always_hidden = function(_, _)
          return false
        end,
        natural_order    = true,
        case_insensitive = false,
        sort = {
          { "type", "asc" },
          { "name", "asc" },
        },
      },

      float = {
        padding  = 2,
        border   = "rounded",
        win_options = { winblend = 0 },
      },
      preview = {
        max_width  = 0.9,
        min_width  = { 40, 0.4 },
        max_height = 0.9,
        min_height = { 5, 0.1 },
        border     = "rounded",
        win_options = { winblend = 0 },
        update_on_cursor_moved = true,
      },
      progress = {
        max_width  = 0.9,
        min_width  = { 40, 0.4 },
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        border           = "rounded",
        minimized_border = "none",
        win_options = { winblend = 0 },
      },
      ssh          = { border = "rounded" },
      keymaps_help = { border = "rounded" },
    },
  },
  
  -- ── 4. smart-splits.nvim ─────────────────────────────────────
  -- Smart directional window resizing
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require('smart-splits').setup({
        -- Ignored filetypes (don't resize these to keep them static)
        ignored_filetypes = { 'nofile', 'quickfix', 'prompt' },
        ignored_buftypes = { 'nofile' },
        -- when moving cursor between splits left or right, 
        -- place cursor on same row of the *screen*
        cursor_respects_line_number = false,
      })
    end
  },
}
