-- lua/custom/plugins/lsp_csharp.lua
-- ══════════════════════════════════════════════════════════════
-- Roslyn LSP — Performance optimized version
-- Inspired by ramboe dotfiles
--
-- ⚡ Changes from previous version:
--   1. ft = { "cs" } only — no razor (causes Roslyn crashes)
--   2. dotnet_analyzer_diagnostics_scope = "openFiles"  ← Key for speed
--   3. dotnet_compiler_diagnostics_scope = "openFiles"
--   4. broad_search = true instead of false (finds .sln automatically)
--   5. filewatching = "roslyn" instead of "auto"
-- ══════════════════════════════════════════════════════════════

return {
	"seblyng/roslyn.nvim",
	--commit = "82d0c9724c3f8eab7342a3a136782b4788070bd0",
	ft = { "cs" }, -- ⚡ cs only — razor causes Roslyn crashes
	dependencies = { "mason-org/mason.nvim" },

	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	opts = {
		broad_search = false, -- Search for .sln in parent directories
		filewatching = "auto", -- Use "roslyn" filewatching for better stability
	},

	config = function(_, opts)
		vim.lsp.config("roslyn", {
			settings = {
				["csharp|background_analysis"] = {
					-- ⚡ openFiles instead of fullSolution — KEY FOR PERFORMANCE
					dotnet_analyzer_diagnostics_scope = "openFiles",
					dotnet_compiler_diagnostics_scope = "openFiles",
				},
				["csharp|inlay_hints"] = {
					csharp_enable_inlay_hints_for_implicit_object_creation = true,
					csharp_enable_inlay_hints_for_implicit_variable_types = true,
					csharp_enable_inlay_hints_for_lambda_parameter_types = true,
					csharp_enable_inlay_hints_for_types = true,
					dotnet_enable_inlay_hints_for_indexer_parameters = true,
					dotnet_enable_inlay_hints_for_literal_parameters = true,
					dotnet_enable_inlay_hints_for_object_creation_parameters = true,
					dotnet_enable_inlay_hints_for_other_parameters = true,
					dotnet_enable_inlay_hints_for_parameters = true,
					dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
				},
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
				},
				["csharp|completion"] = {
					dotnet_show_completion_items_from_unimported_namespaces = true,
					dotnet_show_name_completion_suggestions = true,
				},
			},
		})

		require("roslyn").setup(opts)

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client or client.name ~= "roslyn" then
					return
				end
				vim.notify("Roslyn LSP attached ✓", vim.log.levels.INFO, { title = ".NET" })
			end,
		})
	end,
}
