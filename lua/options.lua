-- lua/options.lua
-- Global Neovim options for ALHABIB IDE (Rider-inspired)

local opt = vim.opt

-- Appearance & UI
vim.o.number = true
vim.o.relativenumber = true -- relative numbers like Rider's gutter
vim.o.mouse = "a"
vim.o.showmode = false -- mode shown in statusline
vim.o.breakindent = true
vim.o.undofile = true
vim.o.shadafile = vim.fn.stdpath("data") .. "/shada/main.shada"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.swapfile = false -- Disable swapfiles to prevent E325 Neo-tree errors
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.numberwidth = 5
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.wrap = false -- no line wrapping (like IDEs)
vim.o.colorcolumn = "120" -- Rider default line length guide

-- Tabs & Indentation
vim.o.tabstop = 4 -- C# convention
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99
opt.foldenable = true

-- RTL support for Arabic — toggle with <leader>ta
vim.o.arabicshape = true
vim.o.arabic = false

-- Clipboard (Optimized for performance)
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Custom Filetypes (.cshtml, Razor, Caddyfile)
--vim.filetype.add({
--	extension = {
--		caddy = "caddy",
--		razor = "razor",
--		cshtml = "razor",
--	},
--	filename = {
--		Caddyfile = "caddy",
--	},
--})

-- UI & Diagnostics Configuration
vim.diagnostic.config({
	update_in_insert = true,
	severity_sort = true,
	float = { border = "rounded", source = true },
	underline = true,
	virtual_text = false,
	virtual_lines = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
})

-- IDE-style fillchars for better window separation
opt.fillchars = {
	horiz = "━",
	horizup = "┻",
	horizdown = "┳",
	vert = "┃",
	vertleft = "┫",
	vertright = "┣",
	verthoriz = "╋",
	eob = " ", -- Hide ~ at end of buffer
}

vim.o.laststatus = 3 -- Global statusline
