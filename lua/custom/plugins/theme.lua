-- lua/custom/plugins/theme.lua
-- ══════════════════════════════════════════════════════════════
-- Tokyonight + Real JetBrains Rider Colors
-- Extracted from lua/themes/jetbrains-rider.lua in ramboe dotfiles
--
-- Changes from previous version in init.lua:
--   ✅ italic for keywords (@keyword)
--   ✅ italic for comments (@comment)
--   ✅ bold for functions (@function)
--   ✅ parameter colors white like real Rider
--   ✅ @function.call dark purple like Rider
--   ✅ @constructor pink like Rider
--   ✅ GitConflict colors
-- ══════════════════════════════════════════════════════════════

return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    -- Real Rider colors from jetbrains-rider.lua
    local rider = {
      blue        = "#6C95EB",   -- Rider blue (calmer than VSCode)
      green       = "#85C46C",
      vibrant_grn = "#39CC8F",
      yellow      = "#C9A26D",
      purple      = "#ED94C0",   -- Rider purple (pink)
      dark_purple = "#C191FF",   -- Rider dark purple
      teal        = "#6aadc8",
      red         = "#800000",
      bright_red  = "#F44747",
      comment     = "#6A9955",
      string      = "#CE9178",
      white       = "#FFFFFF",
    }

    require("tokyonight").setup({
      style       = "night",
      transparent = false,
      styles      = {
        comments  = { italic = true },  -- ✅ italic for comments
        keywords  = { italic = true },  -- ✅ italic for keywords
        functions = { bold = true },    -- ✅ bold for functions
      },

      on_highlights = function(hl, c)
        hl.ColorColumn = { bg = c.bg_highlight }

        -- ── Treesitter ────────────────────────────────────────
        hl["@type"]                  = { fg = "#4EC9B0" }
        hl["@type.builtin"]          = { fg = rider.blue }
        hl["@type.definition"]       = { fg = "#4EC9B0" }

        hl["@keyword"]               = { fg = rider.blue, italic = true }
        hl["@keyword.modifier"]      = { fg = rider.blue, italic = true }
        hl["@keyword.operator"]      = { fg = rider.blue }
        hl["@keyword.return"]        = { fg = "#C586C0", italic = true }
        hl["@keyword.conditional"]   = { fg = "#C586C0" }
        hl["@keyword.repeat"]        = { fg = "#C586C0" }
        hl["@keyword.exception"]     = { fg = "#C586C0" }

        hl["@function"]              = { fg = "#DCDCAA", bold = true }
        hl["@function.call"]         = { fg = rider.dark_purple, bold = true } -- ✅ Dark purple like Rider
        hl["@function.method"]       = { fg = "#DCDCAA", italic = true }
        hl["@function.method.call"]  = { fg = "#DCDCAA", bold = true }
        hl["@constructor"]           = { fg = rider.purple }                   -- ✅ Pink like Rider

        hl["@variable"]              = { fg = "#9CDCFE" }
        hl["@variable.builtin"]      = { fg = rider.blue }
        hl["@variable.parameter"]    = { fg = rider.white }  -- ✅ White for params
        hl["@variable.member"]       = { fg = "#9CDCFE" }
        hl["@property"]              = { fg = "#9CDCFE" }
        hl["@field"]                 = { fg = "#9CDCFE" }

        hl["@string"]                = { fg = rider.string }
        hl["@string.escape"]         = { fg = "#D7BA7D" }
        hl["@string.special"]        = { fg = "#D7BA7D" }

        hl["@number"]                = { fg = "#B5CEA8" }
        hl["@number.float"]          = { fg = "#B5CEA8" }
        hl["@boolean"]               = { fg = rider.blue }
        hl["@constant"]              = { fg = "#4FC1FF" }
        hl["@constant.builtin"]      = { fg = rider.blue }
        hl["@constant.macro"]        = { fg = "#4FC1FF" }

        hl["@comment"]               = { fg = rider.comment, italic = true }  -- ✅ italic
        hl["@comment.documentation"] = { fg = rider.comment, italic = true }

        hl["@operator"]              = { fg = "#D4D4D4" }
        hl["@punctuation.bracket"]   = { fg = "#FFD700" }
        hl["@punctuation.delimiter"] = { fg = "#D4D4D4" }
        hl["@namespace"]             = { fg = "#C8C8C8" }
        hl["@module"]                = { fg = "#C8C8C8" }
        hl["@attribute"]             = { fg = "#C8C8C8" }

        -- ── LSP Semantic Tokens (Roslyn) ──────────────────────
        hl["@lsp.type.class"]         = { fg = "#4EC9B0" }
        hl["@lsp.type.interface"]     = { fg = "#B8D7A3" }
        hl["@lsp.type.struct"]        = { fg = "#86C691" }
        hl["@lsp.type.enum"]          = { fg = "#B8D7A3" }
        hl["@lsp.type.enumMember"]    = { fg = "#B8D7A3" }
        hl["@lsp.type.method"]        = { fg = "#DCDCAA" }
        hl["@lsp.type.function"]      = { fg = "#DCDCAA" }
        hl["@lsp.type.property"]      = { fg = "#9CDCFE" }
        hl["@lsp.type.variable"]      = { fg = "#9CDCFE" }
        hl["@lsp.type.parameter"]     = { fg = rider.white } -- ✅ White for params
        hl["@lsp.type.namespace"]     = { fg = "#C8C8C8" }
        hl["@lsp.type.keyword"]       = { fg = rider.blue }
        hl["@lsp.type.string"]        = { fg = rider.string }
        hl["@lsp.type.number"]        = { fg = "#B5CEA8" }
        hl["@lsp.type.operator"]      = { fg = "#D4D4D4" }
        hl["@lsp.type.comment"]       = { fg = rider.comment }
        hl["@lsp.type.modifier"]      = { fg = rider.blue }
        hl["@lsp.type.event"]         = { fg = "#DCDCAA" }
        hl["@lsp.type.delegate"]      = { fg = "#DCDCAA" }
        hl["@lsp.type.typeParameter"] = { fg = "#B8D7A3" }

        -- ── Git Conflict (git-conflict.nvim) ──────────────────
        hl["GitConflictCurrent"]       = { bg = "#2f3f2f" }
        hl["GitConflictCurrentLabel"]  = { bg = "#3a5f3a", bold = true }
        hl["GitConflictIncoming"]      = { bg = "#2f2f4f" }
        hl["GitConflictIncomingLabel"] = { bg = "#3a3a6f", bold = true }
        hl["GitConflictAncestor"]      = { bg = "#3f3f2f" }
        hl["GitConflictAncestorLabel"] = { bg = "#5f5f3a" }
      end,
    })

    vim.cmd.colorscheme("tokyonight-night")

    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#F44747" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = "#CCA700" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { undercurl = true, sp = "#4FC1FF" })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { undercurl = true, sp = "#A6A6A6" })
  end,
}
