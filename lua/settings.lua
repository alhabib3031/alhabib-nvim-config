-- lua/settings.lua
-- ══════════════════════════════════════════════════════════════
-- Global feature flags to toggle configuration features
-- Set value to true to enable, or false to disable a module
-- ══════════════════════════════════════════════════════════════

local M = {
  enable_git       = true, -- Git integrations (gitsigns, diffview, gitgraph)
  enable_lsp       = true, -- Language Server Protocol (mason, lspconfig, completions)
  enable_dap       = true, -- Debug Adapter Protocol (debugger, dap, dap-ui)
  enable_terminal  = true, -- Terminal integration (toggleterm)
  enable_dotnet    = true, -- .NET specialized configurations (easy-dotnet, dotnet-utils)
  enable_dashboard = true, -- Modern dashboard-nvim welcome screen
}

return M
