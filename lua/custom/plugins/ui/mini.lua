-- lua/custom/plugins/ui/mini.lua
-- Essential utilities (Surround, AI, Comments, Statusline)

return {
	{
		"nvim-mini/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.comment").setup()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = true })
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- Show attached LSP client names for the current buffer
			statusline.section_lsp = function()
				local buf = 0
				if vim.api.nvim_buf_get_option(buf, "buftype") ~= "" then return "" end
				local clients = vim.lsp.get_clients({ bufnr = buf })
				if not clients or vim.tbl_isempty(clients) then return "" end
				local names = {}
				for _, c in pairs(clients) do
					if c and c.name then table.insert(names, c.name) end
				end
				return table.concat(names, ", ")
			end
		end,
	},
}
