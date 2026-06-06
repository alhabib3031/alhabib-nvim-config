-- lua/keymaps.lua
-- ============================================================
-- All keymaps in one place — Rider-inspired workflow
-- ============================================================

local keymap = vim.keymap.set
local opts   = { noremap = true, silent = true }

-- Open Dashboard
keymap("n", "<leader>od", ":Dashboard<CR>", { desc = "Open Dashboard" })

-- ─────────────────────────────────────────────────────────────
-- FILE & EDITOR
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>pv", ":Ex<CR>",       { desc = "Project View [Ex]" })
keymap("n", "<leader>pf", function() _G.OpenProject() end, { desc = "Project [F]inder (Generalized)" })
keymap("n", "<C-s>",      "<cmd>w<CR>",    { desc = "Save file" })
keymap("n", "<C-S-s>",    "<cmd>wa<CR>",   { desc = "Save all files" })
keymap("n", "<C-q>",      "<cmd>q<CR>",    { desc = "Quit" })
keymap("n", "<C-S-q>",    "<cmd>qa<CR>",   { desc = "Quit all" })

-- ─────────────────────────────────────────────────────────────
-- NAVIGATION — Rider-like
-- ─────────────────────────────────────────────────────────────
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n",     "nzzzv",   opts)
keymap("n", "N",     "Nzzzv",   opts)

keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus left" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus right" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus down" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus up" })

-- Window Resizing (Smart Directional)
keymap("n", "<C-Up>",    function() require('smart-splits').resize_up() end,    { desc = "Resize up" })
keymap("n", "<C-Down>",  function() require('smart-splits').resize_down() end,  { desc = "Resize down" })
keymap("n", "<C-Left>",  function() require('smart-splits').resize_left() end,  { desc = "Resize left" })
keymap("n", "<C-Right>", function() require('smart-splits').resize_right() end, { desc = "Resize right" })

-- ─────────────────────────────────────────────────────────────
-- TABS / BUFFERS
-- ─────────────────────────────────────────────────────────────
keymap("n", "<S-l>",      ":bnext<CR>",    { desc = "Next Tab" })
keymap("n", "<S-h>",      ":bprevious<CR>",{ desc = "Previous Tab" })
keymap("n", "<leader>x",  ":bd<CR>",       { desc = "Close current tab" })
keymap("n", "<leader>X",  ":bd!<CR>",      { desc = "Force close tab" })

-- ─────────────────────────────────────────────────────────────
-- CODE EDITING
-- ─────────────────────────────────────────────────────────────
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
keymap("x", "<leader>p", '"_dP',     { desc = "Paste without losing register" })
keymap("n", "<C-S-d>", "yyp",        { desc = "Duplicate line" })
keymap("v", "<C-S-d>", "y`>pgv",     { desc = "Duplicate selection" })
keymap("n", "<C-y>",   "dd",         { desc = "Delete line" })

keymap("n", "<C-A-l>", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
keymap("", "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

-- ─────────────────────────────────────────────────────────────
-- SEARCH & REPLACE
-- ─────────────────────────────────────────────────────────────
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)
keymap("n", "<leader>rw",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Replace word under cursor" })

-- ─────────────────────────────────────────────────────────────
-- FILE EXPLORER (Neo-tree)
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle [E]xplorer" })
keymap("n", "\\",        ":Neotree reveal<CR>",  { desc = "Reveal in Explorer" })

-- Conditionally load peripheral keymaps (terminal / dotnet)
if _G.settings and _G.settings.enable_terminal then
  pcall(require, "keymaps-terminal")
end
if _G.settings and _G.settings.enable_dotnet then
  pcall(require, "keymaps-dotnet")
end

-- ─────────────────────────────────────────────────────────────
-- LSP (mapped dynamically in lspconfig on_attach)
-- grn  → Rename             grr  → References
-- gra  → Code Action        grd  → Definition
-- gri  → Implementation     grt  → Type Definition
-- grD  → Declaration        gO   → Document Symbols
-- gW   → Workspace Symbols
-- ─────────────────────────────────────────────────────────────

-- ─────────────────────────────────────────────────────────────
-- SYMBOLS OUTLINE
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>cs", "<cmd>SymbolsOutline<CR>", { desc = "Code [S]tructure (Symbols)" })

-- ─────────────────────────────────────────────────────────────
-- GIT
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>gs", "<cmd>Telescope git_status<CR>",   { desc = "Git Status" })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>",  { desc = "Git Commits" })
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git Branches" })

-- Clone repo (global)
keymap("n", "<leader>cl", function() require('custom.dotnet_actions').clone_repo() end, { desc = "Clone Repository" })

-- Git Timeline (global picker)
keymap("n", "<leader>gt", function() require('custom.git_timeline').git_projects_picker() end, { desc = "Git Timeline" })

-- ─────────────────────────────────────────────────────────────
-- FZF-LUA  (fast fuzzy search — supplements telescope for LSP)
-- ─────────────────────────────────────────────────────────────
-- Note: <leader>sf, sg, sb, sd, sr, s., sw, / are defined in tools/fzf.lua keys table

-- ─────────────────────────────────────────────────────────────
-- DIAGNOSTICS (Neovim 0.11+)
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostic Quickfix" })
keymap("n", "]d", function()
  vim.diagnostic.jump({ count = 1, on_jump = function() vim.diagnostic.open_float() end })
end, { desc = "Next diagnostic" })
keymap("n", "[d", function()
  vim.diagnostic.jump({ count = -1, on_jump = function() vim.diagnostic.open_float() end })
end, { desc = "Previous diagnostic" })

-- ─────────────────────────────────────────────────────────────
-- INLAY HINTS
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>ti", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
end, { desc = "[T]oggle [I]nlay Hints" })

-- ─────────────────────────────────────────────────────────────
-- ARABIC RTL TOGGLE
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>ta", function()
  local enabled = vim.wo.rightleft
  vim.wo.rightleft    = not enabled
  vim.wo.rightleftcmd = not enabled and "search" or ""
  vim.notify("Arabic RTL: " .. (not enabled and "ON" or "OFF"), vim.log.levels.INFO)
end, { desc = "[T]oggle [A]rabic RTL" })
