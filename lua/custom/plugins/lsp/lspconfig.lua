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
						-- "bicep-lsp",
						"html-lsp",
						"css-lsp",
						-- "eslint-lsp",
						"typescript-language-server",
						"netcoredbg",
						-- "roslyn-language-server",
						"json-lsp",
						"yaml-language-server",
						"markdown-oxide",
						"csharpier",
						-- "prettier",
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

			-- vim.api.nvim_create_autocmd("LspAttach", {
			-- 	group = vim.api.nvim_create_augroup("My-lsp-attach", { clear = true }),
			--
			-- 	callback = function(event)
			-- 		local client = vim.lsp.get_client_by_id(event.data.client_id)
			--
			-- 		-- Disable semantic tokens for Razor
			-- 		if vim.bo[event.buf].filetype == "razor" and client then
			-- 			client.server_capabilities.semanticTokensProvider = nil
			-- 		end
			-- 	end,
			-- })

			local servers = {
				roslyn_ls = {
					filetypes = { "razor", "cs" },
					settings = {
						-- better performance
						["csharp|background_analysis"] = {
							dotnet_analyzer_diagnostics_scope = "openFiles",
							dotnet_compiler_diagnostics_scope = "openFiles",
						},
					},
				},
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
				html = {
					-- ✅ ADDED razor: html-lsp provides tag/attribute completion + diagnostics
					filetypes = { "html", "razor", "cshtml" },
				},
				cssls = {
					-- ✅ ADDED razor: css-lsp handles <style> blocks inside razor files
					-- filetypes = { "css", "scss", "less", "razor", "cshtml" },
				},
				ts_ls = {},
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
