-- lua/custom/plugins/indent_line.lua
-- Indent guides (Rider-style vertical lines)

return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "▏", -- Smooth vertical bar
				tab_char = "▏",
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
				injected_languages = false,
				highlight = { "Function", "Label" },
				priority = 500,
			},
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
	},
}
