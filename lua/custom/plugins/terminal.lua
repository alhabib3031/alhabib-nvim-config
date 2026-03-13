-- lua/custom/plugins/terminal.lua

return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<C-\>]],
			direction = "float",
			float_opts = {
				border = "curved",
				width = math.floor(vim.o.columns * 0.85),
				height = math.floor(vim.o.lines * 0.80),
			},
			highlights = {
				FloatBorder = { link = "FloatBorder" },
			},
			shell = vim.o.shell,
			close_on_exit = true,
		},
	},
}
