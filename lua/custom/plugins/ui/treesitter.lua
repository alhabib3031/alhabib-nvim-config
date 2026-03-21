-- lua/custom/plugins/ui/treesitter.lua
-- Semantic highlighting and syntax tree management

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if ok then
				configs.setup({
					ensure_installed = {
						"bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline",
						"query", "vim", "vimdoc", "c_sharp", "css", "javascript", "json", "xml", "razor",
					},
					highlight = { enable = true },
					indent = { enable = true },
				})
			end
		end,
	},
}
