-- lua/custom/plugins/lsp/roslyn.lua
-- Standalone Roslyn configuration to allow for specific commits and manual modification

return {
  "seblj/roslyn.nvim",
  -- You can specify a commit hash here if you wish
  commit = "82d0c9724c3f8eab7342a3a136782b4788070bd0",
  lazy = false,
  ft = { "cs", "razor" },
  dependencies = {
    {
      -- For better razor support, you can also use a specific commit for the parser if needed
      "nvim-treesitter/nvim-treesitter",
    },
  },
  config = function()
    require("roslyn").setup({
      config = {
        -- Pass standard LSP settings here
        settings = {
          ["csharp|background_analysis"] = {
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
      },
      -- If you want to use a specific version of the Microsoft.CodeAnalysis.LanguageServer, 
      -- you can use exe = { "path/to/server" } or the version option if the plugin supports it
      -- For example:
      -- exe = "Microsoft.CodeAnalysis.LanguageServer",
      args = {
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
      },
    })
  end,
}
