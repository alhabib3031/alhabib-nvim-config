-- lua/custom/plugins/terminal.lua

return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<C-\>]],
			direction = "float",
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.48 -- 48% of width for a comfortable "IDE panel" feel
				end
			end,
			float_opts = {
				border = "curved", -- Rounded corners for floating terminal
				width = math.floor(vim.o.columns * 0.9), -- Slightly larger
				height = math.floor(vim.o.lines * 0.85),
				winblend = 3,
			},
			highlights = {
				-- Standard highlights
			},
			shell = vim.o.shell,
			close_on_exit = true,
		},
	},
}
