-- lua/custom/plugins/tools/comments.lua
-- ══════════════════════════════════════════════════════════════
-- Comment.nvim — Smart line/block commenting
-- Mappings:
--   gcc        → toggle line comment
--   gbc        → toggle block comment
--   gc (visual) → toggle line comment on selection
--   gb (visual) → toggle block comment on selection
--   <C-k>c     → toggle line comment (VS/Rider style)
-- ══════════════════════════════════════════════════════════════

return {
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		config = function()
			require("Comment").setup({
				toggler = {
					line  = "gcc",
					block = "gbc",
				},
				opleader = {
					line  = "gc",
					block = "gb",
				},
				-- Extra mappings are added below
				extra = {
					above = "gcO",
					below = "gco",
					eol   = "gcA",
				},
				mappings = {
					basic  = true,
					extra  = true,
				},
			})

			-- ── Rider/VS-style comment shortcut ──────────────────────────
			-- <C-k>c  and  <C-k><C-c>  both toggle the current line
			local api = require("Comment.api")

			vim.keymap.set("n", "<C-k>c",
				api.toggle.linewise.current,
				{ desc = "Comment: toggle line (Rider style)" }
			)
			vim.keymap.set("n", "<C-k><C-c>",
				api.toggle.linewise.current,
				{ desc = "Comment: toggle line (Rider style)" }
			)

			-- Visual mode: <C-k>c toggles the selected block
			local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
			vim.keymap.set("v", "<C-k>c", function()
				vim.api.nvim_feedkeys(esc, "nx", false)
				api.toggle.linewise(vim.fn.visualmode())
			end, { desc = "Comment: toggle selection" })
		end,
	},
}
