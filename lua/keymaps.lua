-- lua/keymaps.lua
-- ============================================================
-- All keymaps in one place — Rider-inspired workflow
-- ============================================================

local keymap = vim.keymap.set
local opts   = { noremap = true, silent = true }

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

-- ─────────────────────────────────────────────────────────────
-- TERMINAL
-- ─────────────────────────────────────────────────────────────
keymap("n", "<C-\\>",       "<cmd>ToggleTerm direction=float<CR>",      { desc = "Toggle floating terminal" })
keymap("n", "<leader>th",   "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal horizontal" })
keymap("n", "<leader>tv",   "<cmd>ToggleTerm direction=vertical<CR>",   { desc = "Terminal vertical" })
keymap("t", "<Esc><Esc>",   "<C-\\><C-n>",                              { desc = "Exit terminal mode" })

-- ─────────────────────────────────────────────────────────────
-- DEBUG (nvim-dap) — F-keys remain unchanged
-- DAP adapter + .NET configs registered by easy-dotnet.nvim
-- ─────────────────────────────────────────────────────────────
keymap("n", "<F5>",    function() require("dap").continue()   end, { desc = "Debug: Start/Continue" })
keymap("n", "<F10>",   function() require("dap").step_over()  end, { desc = "Debug: Step Over" })
keymap("n", "<F11>",   function() require("dap").step_into()  end, { desc = "Debug: Step Into" })
keymap("n", "<S-F11>", function() require("dap").step_out()   end, { desc = "Debug: Step Out" })
keymap("n", "<leader>b", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })
keymap("n", "<leader>B", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Conditional Breakpoint" })
keymap("n", "<F7>",       function() require("dapui").toggle()  end, { desc = "Debug: Toggle UI" })
keymap("n", "<leader>dR", function() require("dap").repl.open() end, { desc = "Debug: Open REPL" })
keymap("n", "<leader>dq", function() require("dap").terminate() end, { desc = "Debug: Stop" })

-- ─────────────────────────────────────────────────────────────
-- .NET / easy-dotnet.nvim  (replaces old manual TermExec/dotnet run)
-- ─────────────────────────────────────────────────────────────
keymap("n", "<leader>dr", function() require("easy-dotnet").run()             end, { desc = "[D]otnet [R]un" })
keymap("n", "<leader>dw", function() require("easy-dotnet").run_with_args()   end, { desc = "[D]otnet Run [W]ith Args" })
keymap("n", "<leader>db", function() require("easy-dotnet").build()           end, { desc = "[D]otnet [B]uild" })
keymap("n", "<leader>dB", function() require("easy-dotnet").build_solution()  end, { desc = "[D]otnet [B]uild Solution" })
keymap("n", "<leader>dC", function() require("easy-dotnet").clean()           end, { desc = "[D]otnet [C]lean" })
keymap("n", "<leader>do", function() require("easy-dotnet").restore()         end, { desc = "[D]otnet Rest[o]re" })
keymap("n", "<C-F5>",     function() require("easy-dotnet").run({ watch = true }) end, { desc = "Dotnet Watch Run (Hot Reload)" })

-- NuGet
keymap("n", "<leader>dn", function() require("easy-dotnet").nuget_search()       end, { desc = "[D]otnet [N]uGet Search" })
keymap("n", "<leader>da", function() require("easy-dotnet").add()                end, { desc = "[D]otnet [A]dd Package" })
keymap("n", "<leader>du", function() require("easy-dotnet").outdated()           end, { desc = "[D]otnet Outdated ([U]pdate check)" })

-- Secrets & Diagnostics
keymap("n", "<leader>ds", function() require("easy-dotnet").user_secrets()          end, { desc = "[D]otnet [S]ecrets" })
keymap("n", "<leader>dD", function() require("easy-dotnet").workspace_diagnostics() end, { desc = "[D]otnet Workspace [D]iagnostics" })

-- Entity Framework
keymap("n", "<leader>de", function() require("easy-dotnet").entity_framework() end, { desc = "[D]otnet [E]ntityFramework" })

-- Project / Template
keymap("n", "<leader>dp", function() require("easy-dotnet").project()          end, { desc = "[D]otnet [P]roject view" })
keymap("n", "<leader>dN", function() require("easy-dotnet").new()              end, { desc = "[D]otnet [N]ew template" })

-- Test Runner (easy-dotnet)
keymap("n", "<leader>nt", function() require("easy-dotnet").test()             end, { desc = "[N]eotest: Run nearest [T]est" })
keymap("n", "<leader>nf", function() require("easy-dotnet").test_solution()    end, { desc = "[N]eotest: Run [F]ile/Solution" })
keymap("n", "<leader>ns", function() require("easy-dotnet").open_testrunner()  end, { desc = "[N]eotest: Toggle [S]ummary panel" })

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
