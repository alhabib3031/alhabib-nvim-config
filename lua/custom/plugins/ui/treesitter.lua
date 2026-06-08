-- lua/custom/plugins/ui/treesitter.lua
-- Semantic highlighting and syntax tree management

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",

		-- ✅ FIXED: load lazily on buffer open (matches reference config behavior)
		-- Without this, treesitter fires at startup and may miss the FileType event
		-- for files opened at launch (e.g. nvim myfile.razor)
		event = { "BufReadPost", "BufNewFile" },

		config = function()
			-- ✅ FIXED: removed require("nvim-treesitter.install") entirely.
			-- That module's API changed in the new main branch and calling it
			-- outside a pcall silently aborts the config function before
			-- configs.setup() ever runs — so NO FileType autocmd is created
			-- and only languages Neovim knows natively ever get highlighted.
			-- (razor is NOT one of those native languages.)

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
						-- ✅ FIXED: false — mixing regex + treesitter on complex
						-- multi-language files like Razor causes color conflicts
						additional_vim_regex_highlighting = false,
					},
					indent = { enable = true },
				})
			end

			-- ✅ FIXED: register "razor" LANGUAGE for "razor" FILETYPE
			-- The commented-out line was register("razor", "cshtml") which only
			-- helps .cshtml files. Since filetype.add maps .razor → "razor"
			-- filetype, we need register("razor", "razor") for those files.
			vim.treesitter.language.register("razor", "razor")
			vim.treesitter.language.register("razor", "cshtml")

			-- ✅ FIXED: explicit FileType autocmd as a safety net.
			-- This directly calls vim.treesitter.start() for razor files,
			-- bypassing all automatic detection chains completely.
			-- If everything above works, this is a no-op. If anything above
			-- fails, this is what actually makes highlighting appear.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "razor", "cshtml" },
				callback = function(args)
					-- Only start if treesitter is not already active on this buffer
					if not vim.treesitter.highlighter.active[args.buf] then
						pcall(vim.treesitter.start, args.buf, "razor")
					end
				end,
			})
		end,
	},
}
