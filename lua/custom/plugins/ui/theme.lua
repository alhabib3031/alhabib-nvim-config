-- lua/custom/plugins/ui/theme.lua
-- ══════════════════════════════════════════════════════════════
-- JetBrains Rider Dark Theme
-- Colors sourced from the official "Rider Dark" Windows Terminal theme
-- and the ramboe/dotfiles NvChad theme tables, translated to
-- tokyonight's on_highlights API (no NvChad/base46 required).
--
-- Palette:
--   background  #262626    foreground  #A5A5AA
--   blue        #6C95EB    green       #85C46C
--   yellow      #C9A26D    purple      #C191FF
--   pink        #ED94C0    teal        #6aadc8
--   cyan        #008080    red         #800000
--   bright_green #39CC8F   dark_purple #C191FF
--   white       #FFFFFF    comment_fg  #6A9955
--   string_fg   #CE9178
-- ══════════════════════════════════════════════════════════════

return {
	"folke/tokyonight.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		-- ── Rider Dark Color Palette ──────────────────────────────────
		local r = {
			bg = "#262626",
			bg_dark = "#1f1d2a",
			bg_darker = "#13111e",
			bg_highlight = "#2e2c39",
			fg = "#A5A5AA",
			white = "#FFFFFF",

			blue = "#6C95EB",
			green = "#85C46C",
			vibrant_grn = "#39CC8F",
			yellow = "#C9A26D",
			purple = "#ED94C0", -- pink/purple (constructors, keywords)
			dark_purple = "#C191FF", -- dark purple (function calls)
			teal = "#6aadc8",
			cyan = "#008080",
			red = "#800000",
			bright_red = "#F44747",

			comment = "#6A9955",
			string = "#CE9178",
			line_num = "#474552",
			selection = "#08335E",
			deep_black = "#000000",
		}

		require("tokyonight").setup({
			style = "night",
			transparent = false,

			-- Override the base background to Rider Dark
			on_colors = function(c)
				c.bg = r.bg
				c.bg_dark = r.bg_dark
				c.bg_darker = r.bg_darker
				c.bg_highlight = r.bg_highlight
				c.fg = r.fg
				c.comment = r.comment
				c.blue = r.blue
				c.green = r.green
				c.yellow = r.yellow
				c.purple = r.purple
				c.cyan = r.cyan
				c.red = r.red
				c.teal = r.teal
			end,

			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = { bold = true },
			},

			on_highlights = function(hl, _)
				-- ── Treesitter ────────────────────────────────────────────
				--- https://neovim.io/doc/user/treesitter.html#treesitter-highlight-groups
				hl["@function"] = { bold = true, italic = true }
				hl["@function.builtin"] = { bold = true }
				hl["@function.call"] = { bold = true, fg = r.dark_purple }
				hl["@function.method"] = { italic = true, fg = "#DCDCAA" }
				hl["@function.method.call"] = { bold = true }
				hl["@constructor"] = { fg = r.purple }

				hl["@variable"] = { fg = "#9CDCFE" }
				hl["@variable.builtin"] = { fg = r.blue }
				hl["@variable.parameter"] = { fg = r.white }
				hl["@variable.member"] = { fg = "#9CDCFE" }
				hl["@property"] = { fg = "#9CDCFE" }
				hl["@field"] = { fg = "#9CDCFE" }

				hl["@type"] = { fg = "#4EC9B0" }
				hl["@type.builtin"] = { fg = r.blue }
				hl["@type.definition"] = { fg = "#4EC9B0" }

				hl["@keyword"] = { italic = true, fg = r.purple }
				hl["@keyword.modifier"] = { italic = true, fg = r.blue }
				hl["@keyword.operator"] = { fg = r.blue }
				hl["@keyword.return"] = { italic = true, fg = "#C586C0" }
				hl["@keyword.conditional"] = { fg = "#C586C0" }
				hl["@keyword.repeat"] = { fg = "#C586C0" }
				hl["@keyword.exception"] = { fg = "#C586C0" }

				hl["@string"] = { fg = r.string }
				hl["@string.escape"] = { fg = "#D7BA7D" }
				hl["@string.special"] = { fg = "#D7BA7D" }

				hl["@number"] = { fg = "#B5CEA8" }
				hl["@number.float"] = { fg = "#B5CEA8" }
				hl["@boolean"] = { fg = r.blue }

				hl["@constant"] = { fg = "#4FC1FF" }
				hl["@constant.builtin"] = { fg = r.blue }
				hl["@constant.macro"] = { fg = "#4FC1FF" }

				hl["@comment"] = { italic = true, fg = r.comment }
				hl["@comment.documentation"] = { italic = true, fg = r.comment }

				hl["@operator"] = { fg = "#D4D4D4" }
				hl["@punctuation.bracket"] = { fg = "#FFD700" }
				hl["@punctuation.delimiter"] = { fg = "#D4D4D4" }
				hl["@namespace"] = { fg = "#C8C8C8" }
				hl["@module"] = { fg = r.deep_black }
				hl["@attribute"] = { fg = "#C8C8C8" }
				hl["@symbol"] = { fg = r.purple }
				-- hl["@comment"] = { italic = true, bg = r.baby_pink }
				-- hl["@comment"] = { bold = true, italic = true, bg = r.red }
				-- hl["@keyword"] = { fg = r.blue }

				-- ── LSP Semantic Tokens (Roslyn) ──────────────────────────
				hl["@lsp.type.class"] = { fg = "#4EC9B0" }
				hl["@lsp.type.interface"] = { fg = "#B8D7A3" }
				hl["@lsp.type.struct"] = { fg = "#86C691" }
				hl["@lsp.type.enum"] = { fg = "#B8D7A3" }
				hl["@lsp.type.enumMember"] = { fg = "#B8D7A3" }
				hl["@lsp.type.method"] = { fg = "#DCDCAA" }
				hl["@lsp.type.function"] = { fg = "#DCDCAA" }
				hl["@lsp.type.property"] = { fg = "#9CDCFE" }
				hl["@lsp.type.variable"] = { fg = "#9CDCFE" }
				hl["@lsp.type.parameter"] = { fg = r.white }
				hl["@lsp.type.namespace"] = { fg = "#C8C8C8" }
				hl["@lsp.type.keyword"] = { fg = r.blue }
				hl["@lsp.type.string"] = { fg = r.string }
				hl["@lsp.type.number"] = { fg = "#B5CEA8" }
				hl["@lsp.type.comment"] = { fg = r.comment }
				hl["@lsp.type.modifier"] = { fg = r.blue }
				hl["@lsp.type.event"] = { fg = "#DCDCAA" }
				hl["@lsp.type.delegate"] = { fg = "#DCDCAA" }
				hl["@lsp.type.typeParameter"] = { fg = "#B8D7A3" }
				hl["@lsp.type.operator"] = { fg = "#D4D4D4" }

				-- ── Editor UI ──────────────────────────────────────────────
				hl.LineNr = { fg = r.line_num }
				hl.CursorLineNr = { fg = r.yellow, bold = true }
				hl.Visual = { bg = r.selection }
				hl.ColorColumn = { bg = r.bg_highlight }
				hl.Pmenu = { bg = r.bg_dark, fg = r.fg }
				hl.PmenuSel = { bg = r.selection, fg = r.white, bold = true }

				-- ── Git Conflict ───────────────────────────────────────────
				hl["GitConflictCurrent"] = { bg = "#2f3f2f" }
				hl["GitConflictCurrentLabel"] = { bg = "#3a5f3a", bold = true }
				hl["GitConflictIncoming"] = { bg = "#2f2f4f" }
				hl["GitConflictIncomingLabel"] = { bg = "#3a3a6f", bold = true }
				hl["GitConflictAncestor"] = { bg = "#3f3f2f" }
				hl["GitConflictAncestorLabel"] = { bg = "#5f5f3a" }

				-- ── fzf-lua (Rider accent) ────────────────────────────────
				hl["FzfLuaBorder"] = { fg = r.blue }
				hl["FzfLuaTitle"] = { fg = r.blue, bold = true }
				hl["FzfLuaHeaderText"] = { fg = r.purple }
			end,
		})

		vim.cmd.colorscheme("tokyonight-night")

		-- ── Diagnostic underlines ────────────────────────────────────────
		vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = r.bright_red })
		vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#CCA700" })
		vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#4FC1FF" })
		vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#A6A6A6" })
	end,
}
