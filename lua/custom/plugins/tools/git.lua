-- lua/custom/plugins/git.lua
-- Git signs, graph and diffview integration

local gitsigns_spec = {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = " " },
			topdelete = { text = " " },
			changedelete = { text = "▎" },
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buf = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Jump to next git [c]hange" })

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Jump to previous git [c]hange" })

			-- Actions
			map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
			map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
			map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
			map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
			map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
			map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
			map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
			map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })

			-- Toggles
			map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
			map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
		end,
	},
}

local gitgraph_spec = {
	'isakbm/gitgraph.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	cmd = { 'GitGraph' },
	config = function()
		local ok, gitgraph = pcall(require, 'gitgraph')
		if not ok then return end
		if gitgraph.setup then pcall(gitgraph.setup, {}) end

		-- Buffer-local Enter mapping for gitgraph filetype to open Diffview
		vim.api.nvim_create_autocmd('FileType', {
			pattern = 'gitgraph',
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				vim.keymap.set('n', '<CR>', function()
					local line = vim.api.nvim_get_current_line()
					local hash = line:match('(%x+)%s')
					if not hash then
						vim.notify('No commit hash found on this line', vim.log.levels.WARN)
						return
					end
					pcall(vim.cmd, 'DiffviewOpen ' .. hash)
				end, { buffer = bufnr, desc = 'Open commit in Diffview' })
			end,
		})
	end,
}

local diffview_spec = {
	'sindrets/diffview.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local ok, diffview = pcall(require, 'diffview')
		if ok and diffview.setup then
			diffview.setup({})
		end
	end,
}

return { gitsigns_spec, gitgraph_spec, diffview_spec }
