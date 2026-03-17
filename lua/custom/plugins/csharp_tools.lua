-- lua/custom/plugins/csharp_tools.lua
-- ══════════════════════════════════════════════════════════════
-- Extra C# tools inspired by ramboe dotfiles:
--   1. csharpier  — Specialized C# formatter (better than LSP formatter)
--   2. Custom LuaSnip snippets for C# (XML docs, ctor, prop...)
--
-- Requirements:
--   :MasonInstall csharpier
--   :MasonInstall xmlformatter
-- ══════════════════════════════════════════════════════════════

return {
  -- ── 1. Conform with csharpier ──────────────────────────────────
  -- Replaces the conform in init.lua — adds cs and xml
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    opts  = {
      notify_on_error = false,
      format_on_save  = function(bufnr)
        local disable = { c = true, cpp = true }
        if disable[vim.bo[bufnr].filetype] then return nil end
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        lua    = { "stylua" },
        cs     = { "csharpier" },   -- ✅ C# formatter
        xml    = { "xmlformat" },   -- ✅ XML/csproj
        csproj = { "xmlformat" },
        css    = { "prettier" },
        html   = { "prettier" },
        json   = { "prettier" },
      },
      formatters = {
        csharpier = {
          command = "csharpier",
          args    = { "format", "--write-stdout" },
          stdin   = true,
        },
        xmlformat = {
          command = "xmlformat",
        },
      },
    },
  },

  -- ── 2. LuaSnip C# Snippets ───────────────────────────────────
  -- Adds custom C# snippets after loading LuaSnip
  {
    "L3MON4D3/LuaSnip",
    -- Do not redefine the plugin — only add snippets to it
    config = function(_, _)
      -- Load default snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      local ls   = require("luasnip")
      local s    = ls.snippet
      local t    = ls.text_node
      local i    = ls.insert_node
      local fmt  = require("luasnip.extras.fmt").fmt

      -- ── Custom C# Snippets (like ramboe) ──────────────────────
      ls.add_snippets("cs", {

        -- XML Documentation
        s("/// summary", fmt(
          "///<summary>\n/// {}\n///</summary>",
          { i(1, "Description") }
        )),

        s("/// param", fmt(
          [[/// <param name="{}">{}</param>]],
          { i(1, "paramName"), i(2, "description") }
        )),

        s("/// returns", fmt(
          [[/// <returns>{}</returns>]],
          { i(1, "description") }
        )),

        -- Constructor
        s("ctor", fmt(
          "public {}({})\n{{\n    {}\n}}",
          { i(1, "ClassName"), i(2, ""), i(3, "") }
        )),

        -- Property
        s("prop", fmt(
          "public {} {} {{ get; set; }}",
          { i(1, "string"), i(2, "PropertyName") }
        )),

        -- Null check
        s("nn", fmt(
          "if ({} is null) throw new ArgumentNullException(nameof({}));",
          { i(1, "param"), i(1) }
        )),

        -- Console.WriteLine
        s("cw", fmt(
          "Console.WriteLine({});",
          { i(1, "\"message\"") }
        )),

        -- Async method
        s("asyncm", fmt(
          "public async Task<{}> {}({})\n{{\n    {}\n    await Task.CompletedTask;\n}}",
          { i(1, "string"), i(2, "MethodName"), i(3, ""), i(4, "") }
        )),

        -- Dependency injection field
        s("di", fmt(
          "private readonly {} _{};",
          { i(1, "IService"), i(2, "service") }
        )),
      })

      -- ── Lua Snippets ──────────────────────────────────────────
      ls.add_snippets("lua", {
        s("hello", { t('print("Hello World")') }),
        s("req", fmt(
          [[local {} = require("{}")]], { i(1, "mod"), i(2, "module") }
        )),
      })
    end,
  },
}
