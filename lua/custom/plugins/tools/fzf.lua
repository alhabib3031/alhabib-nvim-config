-- lua/custom/plugins/tools/fzf.lua
-- ══════════════════════════════════════════════════════════════
-- fzf-lua — fast fuzzy finder (replaces telescope-ui-select,
--            supplements telescope for LSP pickers)
-- ══════════════════════════════════════════════════════════════

return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "FzfLua",
		keys = {
			{ "<leader>sf", "<cmd>FzfLua files<cr>",            desc = "[S]earch [F]iles (fzf)" },
			{ "<leader>sg", "<cmd>FzfLua live_grep<cr>",        desc = "[S]earch [G]rep (fzf)" },
			{ "<leader>sb", "<cmd>FzfLua buffers<cr>",          desc = "[S]earch [B]uffers (fzf)" },
			{ "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "[S]earch [D]iagnostics (fzf)" },
			{ "<leader>sr", "<cmd>FzfLua resume<cr>",           desc = "[S]earch [R]esume (fzf)" },
			{ "<leader>s.", "<cmd>FzfLua oldfiles<cr>",         desc = "[S]earch Recent (fzf)" },
			{ "<leader>sw", "<cmd>FzfLua grep_cword<cr>",       desc = "[S]earch [W]ord (fzf)" },
			{ "<leader>/",  "<cmd>FzfLua grep_curbuf<cr>",      desc = "[/] Fuzzy search buffer (fzf)" },
		},
		config = function()
			require("fzf-lua").setup({
				-- ── Window ──────────────────────────────────────────────
				winopts = {
					fullscreen = true,
					preview = {
						layout   = "vertical",
						vertical = "up:70%",
					},
				},

				-- ── Exact matching ───────────────────────────────────────
				grep_curbuf = {
					fzf_opts = {
						["--exact"]   = "",
						["--no-sort"] = "",
					},
				},
				files = {
					fzf_opts = {
						["--exact"]   = "",
						["--no-sort"] = "",
					},
				},

				-- ── Global keymaps inside fzf ────────────────────────────
				keymap = {
					fzf = {
						["ctrl-q"] = "select-all+accept", -- send all to quickfix
					},
				},

				-- ── Diagnostics panel ────────────────────────────────────
				diagnostics = {
					cwd_only       = false,
					file_icons     = false,
					git_icons      = false,
					color_headings = true,
					diag_icons     = true,
					diag_source    = true,
					diag_code      = true,
					icon_padding   = "",
					multiline      = 2,
				},
			})

			-- Replace vim.ui.select with fzf-lua (faster than telescope-ui-select)
			require("fzf-lua").register_ui_select()
		end,
	},
}
