-- lua/custom/plugins/tools/telescope.lua
-- Advanced Fuzzy Finder for files, strings, and more

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
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = true },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					prompt_prefix = "  ",
					selection_caret = " ",
					path_display = { "smart" },
					layout_config = { horizontal = { preview_width = 0.55 } },
				},
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			-- General search
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect" })
			vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent" })
			vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find Buffers" })
			
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]vim config" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(
					require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
				)
			end, { desc = "[/] Fuzzy search buffer" })

			-- LSP pickers
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local buf = event.buf
					vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "References" })
					vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "Implementations" })
					vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "Definition" })
					vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Document Symbols" })
					vim.keymap.set("n", "gW", builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = "Workspace Symbols" })
					vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { buffer = buf, desc = "Type Definition" })
				end,
			})
		end,
	},
}
