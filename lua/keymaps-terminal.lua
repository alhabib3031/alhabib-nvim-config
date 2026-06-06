-- lua/keymaps-terminal.lua
-- Terminal-specific keymaps (ToggleTerm + terminal-mode navigation)

local keymap = vim.keymap.set
local opts   = { noremap = true, silent = true }

keymap("n", "<C-\\>",       "<cmd>ToggleTerm direction=float<CR>",      { desc = "Toggle floating terminal" })
keymap("n", "<leader>th",   "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal horizontal" })
keymap("n", "<leader>tv",   "<cmd>ToggleTerm direction=vertical<CR>",   { desc = "Terminal vertical" })
keymap("t", "<Esc><Esc>",   "<C-\\><C-n>",                              { desc = "Exit terminal mode" })

return {}
