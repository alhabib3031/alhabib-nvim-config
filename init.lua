-- ============================================================
-- NVIM CONFIG — ALHABIB IDE (Rider-inspired)
-- ============================================================

-- 1. Load leader keys (Must be first)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- 2. Load global options & diagnostics from options.lua
require("options")

-- 3. Install/Setup Lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
	if vim.v.shell_error ~= 0 then error("Error cloning lazy.nvim:\n" .. out) end
end
vim.opt.rtp:prepend(lazypath)

-- 4. Load plugin architecture from classified folders
require("lazy").setup({
	{ import = "custom.plugins.ui" },
	{ import = "custom.plugins.lsp" },
	{ import = "custom.plugins.tools" },
}, {
	ui = { border = "rounded" },
})

-- 5. Global Handlers & Redraw Functions (Winbar)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })

local devicons_cached = nil
_G.get_winbar = function()
	if not devicons_cached then
		local ok, devicons = pcall(require, "nvim-web-devicons")
		if ok then devicons_cached = devicons end
	end
	if not devicons_cached then return " %f %m" end
	local icon, hl = devicons_cached.get_icon(vim.fn.expand("%:t"), vim.fn.expand("%:e"), { default = true })
	return string.format(" %%#%s#%s%%* %%f %%m", hl or "Normal", icon or "")
end
vim.opt.winbar = "%{%v:lua.get_winbar()%}"

-- 6. Essential Autocommands
local group = vim.api.nvim_create_augroup("alhabib-core", { clear = true })
local au = vim.api.nvim_create_autocmd

au("TextYankPost", { group = group, callback = function() vim.hl.on_yank() end })
au("VimResized", { group = group, callback = function() vim.cmd("tabdo wincmd =") end })

-- Proactive Auto-save on InsertLeave
au("InsertLeave", {
	group = group,
	callback = function()
		if vim.bo.modified and vim.bo.buftype == "" and vim.bo.readonly == false then
			vim.cmd("silent! update")
		end
	end,
})

-- 7. Load user keymaps & legacy configurations
require("keymaps")

-- Final cleanup for temporary shada files
au("VimLeavePre", {
	group = group,
	callback = function()
		local shada_dir = vim.fn.stdpath("data") .. "/shada"
		for _, f in ipairs(vim.fn.glob(shada_dir .. "/*.tmp.*", false, true)) do
			vim.fn.delete(f)
		end
	end,
})
