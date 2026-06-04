-- lua/custom/plugins/tools/telescope.lua
-- Advanced Fuzzy Finder — primarily used for LSP pickers
-- (file/grep search is handled by fzf-lua which is faster for those tasks)

return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-tree/nvim-web-devicons", enabled = true },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					prompt_prefix    = "  ",
					selection_caret  = " ",
					path_display     = { "smart" },
					layout_config    = { horizontal = { preview_width = 0.55 } },
				},
				-- Note: extensions.ui-select removed — fzf-lua.register_ui_select() handles vim.ui.select
			})
			pcall(require("telescope").load_extension, "fzf")

			local builtin = require("telescope.builtin")

			-- ── General search (kept for help/keymaps/commands pickers) ──
			vim.keymap.set("n", "<leader>sh", builtin.help_tags,  { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps,    { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin,    { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sc", builtin.commands,   { desc = "[S]earch [C]ommands" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find Buffers" })

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]vim config" })

			-- ── LSP pickers (telescope handles these well with preview) ──
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local buf = event.buf
					vim.keymap.set("n", "grr", builtin.lsp_references,               { buf = buf, desc = "References" })
					vim.keymap.set("n", "gri", builtin.lsp_implementations,           { buf = buf, desc = "Implementations" })
					vim.keymap.set("n", "grd", builtin.lsp_definitions,               { buf = buf, desc = "Definition" })
					vim.keymap.set("n", "gO",  builtin.lsp_document_symbols,          { buf = buf, desc = "Document Symbols" })
					vim.keymap.set("n", "gW",  builtin.lsp_dynamic_workspace_symbols, { buf = buf, desc = "Workspace Symbols" })
					vim.keymap.set("n", "grt", builtin.lsp_type_definitions,          { buf = buf, desc = "Type Definition" })
				end,
			})
		end,
	},
}
