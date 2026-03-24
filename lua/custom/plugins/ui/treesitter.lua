-- lua/custom/plugins/ui/treesitter.lua
-- Semantic highlighting and syntax tree management

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- Use MinGW GCC for tree-sitter parser compilation
			local gcc_path = "C:\\ProgramData\\chocolatey\\lib\\mingw\\tools\\install\\mingw64\\bin\\gcc.exe"
			vim.env.CC = gcc_path
			require("nvim-treesitter.install").compilers = { gcc_path, "gcc", "zig" }
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if ok then
				configs.setup({
					ensure_installed = {
						"bash",
						"c",
						"diff",
						"html",
						"lua",
						"luadoc",
						"markdown",
						"markdown_inline",
						"query",
						"vim",
						"vimdoc",
						"c_sharp",
						"css",
						"javascript",
						"json",
						"xml",
						"razor",
					},
					highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "razor" },
				},
					indent = { enable = true },
				})
			end
		end,
	},
}
