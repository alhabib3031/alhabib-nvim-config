-- lua/custom/plugins/smoothcursor.lua
-- ══════════════════════════════════════════════════════════════
-- SmoothCursor — Cursor with animations
-- Inspired by ramboe (cursor animation)
-- ══════════════════════════════════════════════════════════════

return {
	"gen740/SmoothCursor.nvim",
	event = "BufReadPost",
	config = function()
		require("smoothcursor").setup({
			autostart = true,
			type = "exp", -- "default" | "exp" | "matrix"

			fancy = {
				enable = true,
				head = {
					cursor = "▷",
					texthl = "SmoothCursorHead",
					linehl = nil,
				},
				body = {
					{ cursor = "●", texthl = "SmoothCursorBody1" },
					{ cursor = "●", texthl = "SmoothCursorBody1" },
					{ cursor = "•", texthl = "SmoothCursorBody2" },
					{ cursor = "•", texthl = "SmoothCursorBody2" },
					{ cursor = "∙", texthl = "SmoothCursorBody3" },
					{ cursor = "∙", texthl = "SmoothCursorBody3" },
				},
				tail = { cursor = nil, texthl = "SmoothCursorBody3" },
			},

			flyin_effect = "bottom", -- Direction of cursor fly-in
			speed = 25,
			intervals = 35,
			priority = 10,
			timeout = 3000,
			threshold = 3, -- Only move if more than 3 lines are jumped

			disabled_filetypes = {
				"TelescopePrompt",
				"neo-tree",
				"NvimTree",
				"dashboard",
				"alpha",
				"nofile",
				"toggleterm",
				"dapui_scopes",
				"dapui_stacks",
				"dapui_watches",
				"dapui_breakpoints",
			},
		})

		-- Colors compatible with tokyonight-night + Rider palette
		vim.api.nvim_set_hl(0, "SmoothCursorHead", { fg = "#4EC9B0" }) -- teal (Rider)
		vim.api.nvim_set_hl(0, "SmoothCursorBody1", { fg = "#4EC9B0" })
		vim.api.nvim_set_hl(0, "SmoothCursorBody2", { fg = "#6aadc8" })
		vim.api.nvim_set_hl(0, "SmoothCursorBody3", { fg = "#3a7a8a" })
	end,
}
