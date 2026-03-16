-- ============================================================
-- NVIM CONFIG — Rider-inspired .NET Development Environment
-- ============================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- ─────────────────────────────────────────────────────────────
-- OPTIONS
-- ─────────────────────────────────────────────────────────────
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
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.wrap = false -- no line wrapping (like IDEs)
vim.o.colorcolumn = "120" -- Rider default line length guide
vim.o.tabstop = 4 -- C# convention
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- RTL support for Arabic — toggle with <leader>ta
vim.o.arabicshape = true
vim.o.arabic = false

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- ─────────────────────────────────────────────────────────────
-- DIAGNOSTICS (Rider-like inline errors)
-- ✅ FIX 1: Removed severity filter so all errors show up without filtering
-- ─────────────────────────────────────────────────────────────
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = true },
	underline = true,
	virtual_text = false,
	virtual_lines = false,
	jump = { float = true },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "❌", -- Rider style error
			[vim.diagnostic.severity.WARN] = "⚠️", -- Rider style warning
			[vim.diagnostic.severity.INFO] = "ℹ️", -- Rider style info
			[vim.diagnostic.severity.HINT] = "💡", -- Rider style hint/suggestion
		},
	},
})

vim.lsp.handlers["textDocument/publishDiagnostics"] =
	vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })

-- ─────────────────────────────────────────────────────────────
-- AUTOCOMMANDS
-- ─────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Auto-resize splits on window resize
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("resize-splits", { clear = true }),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- ─────────────────────────────────────────────────────────────
-- LAZY PLUGIN MANAGER
-- ─────────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ─────────────────────────────────────────────────────────────
-- PLUGINS
-- ─────────────────────────────────────────────────────────────
require("lazy").setup({

	-- Indent detection
	{ "NMAC427/guess-indent.nvim", opts = {} },

	-- Git signs in gutter
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
		},
	},

	-- Which-key: keymap cheatsheet
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 400,
			icons = { mappings = vim.g.have_nerd_font },
			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				{ "<leader>d", group = "[D]ebug" },
				{ "<leader>n", group = "[N]eotest" },
				{ "<leader>r", group = "[R]ename/Replace" },
				{ "gr", group = "LSP Actions" },
			},
		},
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		enabled = true,
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					prompt_prefix = "  ",
					selection_caret = " ",
					path_display = { "smart" },
					layout_config = { horizontal = { preview_width = 0.55 } },
				},
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect" })
			vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent" })
			vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find Buffers" })
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]vim config" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(
					require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
				)
			end, { desc = "[/] Fuzzy search buffer" })

			-- LSP pickers wired in lspconfig on_attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
				callback = function(event)
					local buf = event.buf
					vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "References" })
					vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "Implementations" })
					vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "Definition" })
					vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Document Symbols" })
					vim.keymap.set(
						"n",
						"gW",
						builtin.lsp_dynamic_workspace_symbols,
						{ buffer = buf, desc = "Workspace Symbols" }
					)
					vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { buffer = buf, desc = "Type Definition" })
				end,
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					registries = {
						"github:Crashdummyy/mason-registry",
						"github:mason-org/mason-registry",
					},
				},
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("grA", vim.lsp.buf.code_action, "Code [A]ction", { "n", "x" })
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" }) -- Rider-like code action shortcut

					map("grD", vim.lsp.buf.declaration, "[D]eclaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local hl = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd(
							{ "CursorHold", "CursorHoldI" },
							{ buffer = event.buf, group = hl, callback = vim.lsp.buf.document_highlight }
						)
						vim.api.nvim_create_autocmd(
							{ "CursorMoved", "CursorMovedI" },
							{ buffer = event.buf, group = hl, callback = vim.lsp.buf.clear_references }
						)
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(e2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = e2.buf })
							end,
						})
						vim.api.nvim_create_autocmd("VimLeavePre", {
							group = vim.api.nvim_create_augroup("clean-shada-tmp", { clear = true }),
							callback = function()
								local shada_dir = vim.fn.stdpath("data") .. "/shada"
								for _, f in ipairs(vim.fn.glob(shada_dir .. "/*.tmp.*", false, true)) do
									vim.fn.delete(f)
								end
							end,
						})
					end

					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>ti", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle [I]nlay Hints")
					end
				end,
			})

			local servers = {
				stylua = {},
				lua_ls = {
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								path ~= vim.fn.stdpath("config")
								---@diagnostic disable-next-line: undefined-field
								and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
							then
								return
							end
						end
						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = { version = "LuaJIT" },
							workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
						})
					end,
					settings = { Lua = {} },
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			-- Ensure C# servers & debuggers are installed
			vim.list_extend(ensure_installed, { "roslyn", "netcoredbg", "rzls" })

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			for name, server in pairs(servers) do
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end
		end,
	},

	-- Formatter
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable = { c = true, cpp = true }
				if disable[vim.bo[bufnr].filetype] then
					return nil
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},

	-- Colorscheme
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = false,
				styles = { comments = { italic = false } },
				on_highlights = function(hl, c)
					hl.ColorColumn = { bg = c.bg_highlight }

					-- ── C# / General — JetBrains + VS Dark style ──────────
					hl["@type"] = { fg = "#4EC9B0" }
					hl["@type.builtin"] = { fg = "#569CD6" }
					hl["@type.definition"] = { fg = "#4EC9B0" }
					hl["@keyword"] = { fg = "#569CD6" }
					hl["@keyword.modifier"] = { fg = "#569CD6" }
					hl["@keyword.operator"] = { fg = "#569CD6" }
					hl["@keyword.return"] = { fg = "#C586C0" }
					hl["@keyword.conditional"] = { fg = "#C586C0" }
					hl["@keyword.repeat"] = { fg = "#C586C0" }
					hl["@keyword.exception"] = { fg = "#C586C0" }
					hl["@function"] = { fg = "#DCDCAA" }
					hl["@function.call"] = { fg = "#DCDCAA" }
					hl["@function.method"] = { fg = "#DCDCAA" }
					hl["@function.method.call"] = { fg = "#DCDCAA" }
					hl["@constructor"] = { fg = "#4EC9B0" }
					hl["@variable"] = { fg = "#9CDCFE" }
					hl["@variable.builtin"] = { fg = "#569CD6" }
					hl["@variable.parameter"] = { fg = "#9CDCFE" }
					hl["@variable.member"] = { fg = "#9CDCFE" }
					hl["@property"] = { fg = "#9CDCFE" }
					hl["@field"] = { fg = "#9CDCFE" }
					hl["@string"] = { fg = "#CE9178" }
					hl["@string.escape"] = { fg = "#D7BA7D" }
					hl["@string.special"] = { fg = "#D7BA7D" }
					hl["@number"] = { fg = "#B5CEA8" }
					hl["@number.float"] = { fg = "#B5CEA8" }
					hl["@boolean"] = { fg = "#569CD6" }
					hl["@constant"] = { fg = "#4FC1FF" }
					hl["@constant.builtin"] = { fg = "#569CD6" }
					hl["@constant.macro"] = { fg = "#4FC1FF" }
					hl["@comment"] = { fg = "#6A9955" }
					hl["@comment.documentation"] = { fg = "#6A9955" }
					hl["@operator"] = { fg = "#D4D4D4" }
					hl["@punctuation.bracket"] = { fg = "#FFD700" }
					hl["@punctuation.delimiter"] = { fg = "#D4D4D4" }
					hl["@namespace"] = { fg = "#C8C8C8" }
					hl["@module"] = { fg = "#C8C8C8" }
					hl["@attribute"] = { fg = "#C8C8C8" }

					-- ── LSP Semantic Tokens — Works with Roslyn ─────────────
					hl["@lsp.type.class"] = { fg = "#4EC9B0" }
					hl["@lsp.type.interface"] = { fg = "#B8D7A3" }
					hl["@lsp.type.struct"] = { fg = "#86C691" }
					hl["@lsp.type.enum"] = { fg = "#B8D7A3" }
					hl["@lsp.type.enumMember"] = { fg = "#B8D7A3" }
					hl["@lsp.type.method"] = { fg = "#DCDCAA" }
					hl["@lsp.type.function"] = { fg = "#DCDCAA" }
					hl["@lsp.type.property"] = { fg = "#9CDCFE" }
					hl["@lsp.type.variable"] = { fg = "#9CDCFE" }
					hl["@lsp.type.parameter"] = { fg = "#9CDCFE" }
					hl["@lsp.type.namespace"] = { fg = "#C8C8C8" }
					hl["@lsp.type.keyword"] = { fg = "#569CD6" }
					hl["@lsp.type.string"] = { fg = "#CE9178" }
					hl["@lsp.type.number"] = { fg = "#B5CEA8" }
					hl["@lsp.type.operator"] = { fg = "#D4D4D4" }
					hl["@lsp.type.comment"] = { fg = "#6A9955" }
					hl["@lsp.type.modifier"] = { fg = "#569CD6" }
					hl["@lsp.type.event"] = { fg = "#DCDCAA" }
					hl["@lsp.type.delegate"] = { fg = "#DCDCAA" }
					hl["@lsp.type.typeParameter"] = { fg = "#B8D7A3" }
				end,
			})
			vim.cmd.colorscheme("tokyonight-night")

			-- ✅ Force diagnostic undercurls (red/yellow squiggly lines)
			vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#F44747" })
			vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#CCA700" })
			vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#4FC1FF" })
			vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#A6A6A6" })
		end,
	},

	-- TODO comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = true },
	},

	-- Mini plugins
	{
		"nvim-mini/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.comment").setup()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		config = function()
			-- Force Zig compiler exclusively
			require("nvim-treesitter.install").compilers = { "zig" }

			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if ok then
				---@diagnostic disable-next-line: missing-fields
				configs.setup({
					ensure_installed = {
						"bash",
						"c",
						"diff",
						"html",
						"lua",
						"luadoc",
						"markdown",
						"markdown_inline",
						"query",
						"vim",
						"vimdoc",
						"c_sharp",
						"css",
						"javascript",
						"json",
						"xml",
						"razor",
					},
					sync_install = false,
					auto_install = true,
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
					indent = { enable = true },
				})
			end
		end,
	},

	-- Custom plugin files
	require("alhabib.plugins.neo-tree"),

	{ import = "custom.plugins" },
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤",
		},
	},
})

-- ✅ Removed duplicate C# autocmd that conflicted with the global Treesitter
-- Do not add any vim.treesitter.start here — the global FileType autocmd above is enough

-- ─────────────────────────────────────────────────────────────
-- AUTO-SAVE CONFIGURATION
-- ─────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = "*",
	callback = function()
		if vim.bo.modified and vim.bo.buftype == "" and vim.bo.readonly == false then
			vim.cmd("silent! update")
		end
	end,
})

-- ─────────────────────────────────────────────────────────────
-- LOAD KEYMAPS (must be after plugins)
-- ─────────────────────────────────────────────────────────────
require("keymaps")

-- vim: ts=2 sts=2 sw=2 et
