-- lua/custom/plugins/tiny_inline_diagnostic.lua
-- Inline diagnostics — Rider-style messages without shifting lines

return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup({
			-- "modern" | "classic" | "minimal" | "powerline" | "ghost" | "simple" | "nonerdfont" | "amongus"
			preset = "modern",

			transparent_bg = false,
			transparent_cursorline = true,

			-- Inherit colors from your existing diagnostic highlights
			hi = {
				error = "DiagnosticError",
				warn = "DiagnosticWarn",
				info = "DiagnosticInfo",
				hint = "DiagnosticHint",
				arrow = "NonText",
				background = "CursorLine",
				mixing_color = "Normal",
			},

			options = {
				-- Show LSP source name (e.g. "roslyn", "lua_ls")
				show_source = {
					enabled = true,
					if_many = false,
				},

				-- Use the same icons defined in vim.diagnostic.config (your ❌ ⚠️ etc.)
				use_icons_from_diagnostic = false,

				throttle = 20,
				softwrap = 30,

				add_messages = {
					messages = true,
					display_count = false,
					use_max_severity = false,
					show_multiple_glyphs = true,
				},

				-- Multiline: show every line of a long diagnostic
				multilines = {
					enabled = true,
					always_show = false,
					trim_whitespaces = true,
					tabstop = 4,
				},

				show_all_diags_on_cursorline = true,

				-- Related info from Roslyn (like Rider's "see also" links)
				show_related = {
					enabled = true,
					max_count = 3,
				},

				enable_on_insert = false,
				enable_on_select = false,

				overflow = {
					mode = "wrap",
					padding = 0,
				},

				break_line = {
					enabled = false,
					after = 30,
				},

				virt_texts = {
					priority = 2048,
				},

				severity = {
					vim.diagnostic.severity.ERROR,
					vim.diagnostic.severity.WARN,
					vim.diagnostic.severity.INFO,
					vim.diagnostic.severity.HINT,
				},
			},
		})

		-- Disable Neovim's default virtual_text to avoid duplicates
		vim.diagnostic.config({ virtual_text = false })
	end,
}
