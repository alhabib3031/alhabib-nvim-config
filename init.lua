-- ============================================================
-- NVIM CONFIG — ALHABIB IDE (Minimalist Entry Point)
-- ============================================================

-- 0. [HOTFIX] Neovim 0.12 LSP: Fix "compare number with nil" in util.lua:524
local original_apply_text_document_edit = vim.lsp.util.apply_text_document_edit
vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, pos_encoding, annotations)
	if text_document_edit and text_document_edit.textDocument and text_document_edit.textDocument.version == nil then
		text_document_edit.textDocument.version = vim.NIL
	end
	return original_apply_text_document_edit(text_document_edit, index, pos_encoding, annotations)
end

-- 1. Essential Global Keys (Must be defined first)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- 1.1 Ensure TreeSitter parser directory exists and is in runtimepath
local ts_site = vim.fn.stdpath("data") .. "/site"
if not (vim.uv or vim.loop).fs_stat(ts_site) then
	vim.fn.mkdir(ts_site, "p")
end
vim.opt.runtimepath:prepend(ts_site)

-- 2. Load Core Settings & Filetype definitions
require("options")

-- 3. Bootstrap Plugin Manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- 4. Setup Plugin Architecture (Modules)
require("lazy").setup({
	{ import = "custom.plugins.ui" },
	{ import = "custom.plugins.lsp" },
	{ import = "custom.plugins.tools" },
}, {
	ui = { border = "rounded" },
})

-- 5. Essential UI Autocommands
local group = vim.api.nvim_create_augroup("alhabib-core", { clear = true })
local au = vim.api.nvim_create_autocmd

-- Improved Yank Highlighting
au("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Auto-resize splits when terminal window size changes
au("VimResized", {
	group = group,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- 6. Load Custom Keybindings
require("keymaps")
