-- lua/custom/plugins/ui/treesitter.lua
-- Semantic highlighting and syntax tree management

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- Use the canonical data path that init.lua already adds to runtimepath
			local parser_path = vim.fn.stdpath("data") .. "/site"

			local ok, configs = pcall(require, "nvim-treesitter.configs")

			local install = require("nvim-treesitter.install")
			install.prefer_git = false
			install.compilers = { "gcc", "clang", "zig" }

			if ok then
				configs.setup({
					parser_install_dir = parser_path,
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
						additional_vim_regex_highlighting = true,
					},
					indent = { enable = true },
				})
			end

			vim.treesitter.language.register("razor", "cshtml")
		end,
	},
}
