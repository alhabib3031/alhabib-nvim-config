-- lua/keymaps.lua
-- ============================================================
-- All keymaps in one place — Rider-inspired workflow
-- ============================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ─────────────────────────────────────────────────────────────
-- FILE & EDITOR
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>pv", ":Ex<CR>", { desc = "Project View [Ex]" })
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<C-S-s>", "<cmd>wa<CR>", { desc = "Save all files" })
keymap("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })
keymap("n", "<C-S-q>", "<cmd>qa<CR>", { desc = "Quit all" })

-- ─────────────────────────────────────────────────────────────
-- NAVIGATION — Rider-like
-- ─────────────────────────────────────────────────────────────
-- Scroll centered
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Keep search results centered
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Window navigation (Ctrl+hjkl)
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus left" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus right" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus down" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus up" })

-- ─────────────────────────────────────────────────────────────
-- TABS / BUFFERS — like IDE tabs
-- ─────────────────────────────────────────────────────────────
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next Tab" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous Tab" })
keymap("n", "<leader>x", ":bd<CR>", { desc = "Close current tab" })
keymap("n", "<leader>X", ":bd!<CR>", { desc = "Force close tab" })

-- ─────────────────────────────────────────────────────────────
-- CODE EDITING
-- ─────────────────────────────────────────────────────────────
-- Move selected lines (Rider: Alt+Shift+Up/Down)
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better paste (don't lose register)
keymap("x", "<leader>p", '"_dP', { desc = "Paste without losing register" })

-- Duplicate line (Rider: Ctrl+D)
keymap("n", "<C-S-d>", "yyp", { desc = "Duplicate line" })
keymap("v", "<C-S-d>", "y`>pgv", { desc = "Duplicate selection" })

-- Delete line (Rider: Ctrl+Y)
keymap("n", "<C-y>", "dd", { desc = "Delete line" })

-- Comment toggle handled by which-key / mini.comment if installed
-- Format buffer (Rider: Ctrl+Alt+L)
keymap("n", "<C-A-l>", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
keymap("", "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

-- ─────────────────────────────────────────────────────────────
-- SEARCH & REPLACE
-- ─────────────────────────────────────────────────────────────
-- Clear highlights
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Search & replace word under cursor (Rider: Ctrl+R)
keymap(
	"n",
	"<leader>rw",
	":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
	{ desc = "Replace word under cursor" }
)

-- ─────────────────────────────────────────────────────────────
-- FILE EXPLORER (Neo-tree)
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle [E]xplorer" })
keymap("n", "\\", ":Neotree reveal<CR>", { desc = "Reveal in Explorer" })

-- ─────────────────────────────────────────────────────────────
-- TERMINAL
-- <C-`> does not work in Windows — replaced with <C-t> (or using ToggleTerm)
-- ─────────────────────────────────────────────────────────────
keymap("n", "<C-\\>", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal horizontal" })
keymap("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Terminal vertical" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ─────────────────────────────────────────────────────────────
-- .NET / DOTNET (Rider: Run = Ctrl+F5, Debug = F5)
-- ─────────────────────────────────────────────────────────────
keymap("n", "<F5>", function()
	require("dap").continue()
end, { desc = "Debug: Start/Continue" })
keymap("n", "<C-F5>", '<cmd>TermExec cmd="dotnet watch run"<CR>', { desc = "Dotnet Watch Run (Hot Reload)" })
keymap("n", "<F10>", function()
	require("dap").step_over()
end, { desc = "Debug: Step Over" })
keymap("n", "<F11>", function()
	require("dap").step_into()
end, { desc = "Debug: Step Into" })
keymap("n", "<S-F11>", function()
	require("dap").step_out()
end, { desc = "Debug: Step Out" })
keymap("n", "<leader>b", function()
	require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })
keymap("n", "<leader>B", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Conditional Breakpoint" })
keymap("n", "<F7>", function()
	require("dapui").toggle()
end, { desc = "Debug: Toggle UI" })
keymap("n", "<leader>dr", function()
	require("dap").restart()
end, { desc = "Debug: Restart" })
keymap("n", "<leader>dq", function()
	require("dap").terminate()
end, { desc = "Debug: Stop" })

-- ─────────────────────────────────────────────────────────────
-- LSP (mapped dynamically in lspconfig on_attach, mirrored here for reference)
-- ─────────────────────────────────────────────────────────────
-- grn  → Rename
-- gra  → Code Action
-- grr  → References
-- grd  → Definition
-- grD  → Declaration
-- gri  → Implementation
-- grt  → Type Definition
-- gO   → Document Symbols
-- gW   → Workspace Symbols
-- <leader>q → Quickfix diagnostics

-- ─────────────────────────────────────────────────────────────
-- SYMBOLS OUTLINE (Rider: Structure panel)
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>cs", "<cmd>SymbolsOutline<CR>", { desc = "Code [S]tructure (Symbols)" })

-- ─────────────────────────────────────────────────────────────
-- GIT
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git Status" })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git Commits" })
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git Branches" })

-- ─────────────────────────────────────────────────────────────
-- DIAGNOSTICS
-- vim.diagnostic.jump replaces the deprecated goto_next/goto_prev (Neovim 0.11+)
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostic Quickfix" })
keymap("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
keymap("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

-- ─────────────────────────────────────────────────────────────
-- INLAY HINTS TOGGLE
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>ti", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
end, { desc = "[T]oggle [I]nlay Hints" })

-- ─────────────────────────────────────────────────────────────
-- ARABIC RTL TOGGLE — Toggle writing direction for Arabic
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>ta", function()
	-- vim.wo.rightleft is a boolean window-local option (correct API for Neovim)
	local enabled = vim.wo.rightleft
	vim.wo.rightleft = not enabled
	vim.wo.rightleftcmd = not enabled and "search" or ""
	vim.notify("Arabic RTL: " .. (not enabled and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = "[T]oggle [A]rabic RTL" })
