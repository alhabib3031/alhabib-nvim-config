-- lua/custom/plugins/lsp/lspconfig.lua
-- Core LSP configuration and server management (Mason integrated)

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					registries = { "github:Crashdummyy/mason-registry", "github:mason-org/mason-registry" },
				},
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
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
					
					-- Standard LSP Actions (Rider-style)
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("grA", vim.lsp.buf.code_action, "Code [A]ction", { "n", "x" })
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("grD", vim.lsp.buf.declaration, "[D]eclaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local hl = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, { buffer = event.buf, group = hl, callback = vim.lsp.buf.document_highlight })
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { buffer = event.buf, group = hl, callback = vim.lsp.buf.clear_references })
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
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
							diagnostics = { globals = { "vim" } },
						},
					},
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, { "roslyn", "netcoredbg" })
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, server in pairs(servers) do
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end
		end,
	},
}
