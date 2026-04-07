-- lua/custom/plugins/lsp/lspconfig.lua
-- Core LSP configuration and server management (Mason integrated)

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- [ADDED] Setup dev tools for Neovim config (fixes 'Undefined field' errors)
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luvit-meta/library", words = { "vim%.uv" } },
					},
				},
				{ "Bilal2453/luvit-meta", lazy = true },
			},
			{
				"mason-org/mason.nvim",
				opts = {
					registries = {
						"github:mason-org/mason-registry",
						"github:Crashdummyy/mason-registry",
					},
					ensure_installed = {
						"lua-language-server",
						"stylua",
						"bicep-lsp",
						"html-lsp",
						"css-lsp",
						"eslint-lsp",
						"typescript-language-server",
						"netcoredbg",
						"roslyn",
						"json-lsp",
						"yaml-language-server",
						"markdown-oxide",
						"csharpier",
						"prettier",
						"xmlformatter",
					},
				},
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			-- Get mason opts to use its ensure_installed list
			local mason_opts = require("lazy.core.config").plugins["mason.nvim"].opts
			require("mason").setup(mason_opts)
			require("mason-tool-installer").setup({ ensure_installed = mason_opts.ensure_installed })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("My-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buf = event.buf, desc = "LSP: " .. desc })
					end

					-- Standard LSP Actions (Rider-style)
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("grA", vim.lsp.buf.code_action, "Code [A]ction", { "n", "x" })
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("grD", vim.lsp.buf.declaration, "[D]eclaration")
					map("gd", vim.lsp.buf.definition, "[G]o to [D]efinition")
					map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
					map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					
					-- 🛠️ Fix Razor HTML Colors: Disable Semantic Tokens for .razor files
					-- Because Roslyn paints HTML as plain text and overrides TreeSitter's beautiful colors
					-- if vim.bo[event.buf].filetype == "razor" and client then
					-- 	client.server_capabilities.semanticTokensProvider = nil
					-- end

					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local hl = vim.api.nvim_create_augroup("My-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd(
							{ "CursorHold", "CursorHoldI" },
							{ buffer = event.buf, group = hl, callback = vim.lsp.buf.document_highlight }
						)
						vim.api.nvim_create_autocmd(
							{ "CursorMoved", "CursorMovedI" },
							{ buffer = event.buf, group = hl, callback = vim.lsp.buf.clear_references }
						)
					end

					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>ti", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle [I]nlay Hints")
					end

					-- CodeLens For .NET
					if client and client:supports_method("textDocument/codeLens", event.buf) then
						vim.lsp.codelens.enable(true, { bufnr = event.buf })
					end
				end,
			})

			local servers = {
				stylua = {},
				lua_ls = {
					-- [MODIFIED] Simplified lua_ls config.
					-- lazydev.nvim handles the workspace/library automatically.
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
							},
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
				html = {},
				cssls = {},
				ts_ls = {},
				razor_ls = {},
				eslint = {},
				jsonls = {},
				yamlls = {},
				markdown_oxide = {},
				bicep = {},
			}

			for name, server in pairs(servers) do
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end
		end,
	},
}
