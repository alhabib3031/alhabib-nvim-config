-- lua/custom/plugins/completion.lua
-- Autocompletion with Tab-to-accept (Rider/VS style)

return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- Premade snippets for C#, JS, etc.
        {
          'rafamadriz/friendly-snippets',
          config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
        },
      },
      opts = {},
    },
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      -- Tab = accept suggestion (Rider / VS Code style)
      -- Ctrl+Space = open menu
      -- Ctrl+e = dismiss
      -- Ctrl+n/p = navigate list
      preset = 'none',
      ['<Tab>'] = { 'accept', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'mono',
      -- Show kind icons like Rider
      kind_icons = {
        Class = ' ',
        Color = ' ',
        Constant = ' ',
        Constructor = ' ',
        Enum = '󰕘 ',
        EnumMember = ' ',
        Event = ' ',
        Field = ' ',
        File = ' ',
        Folder = ' ',
        Function = '󰊕 ',
        Interface = ' ',
        Keyword = '󰻾 ',
        Method = '󰊕 ',
        Module = ' ',
        Operator = '󰪚 ',
        Property = ' ',
        Reference = ' ',
        Snippet = ' ',
        Struct = ' ',
        Text = ' ',
        TypeParameter = '󰬛 ',
        Unit = ' ',
        Value = ' ',
        Variable = ' ',
      },
    },

    completion = {
      -- Auto-show documentation popup (like Rider's quick doc)
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = 'rounded' },
      },
      menu = {
        border = 'rounded',
        -- Show a preview of what will be inserted
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind', gap = 1 },
          },
        },
      },
      -- Accept current item on Enter
      accept = { auto_brackets = { enabled = true } },
      -- Ghost text (like Rider's inline completion hint)
      ghost_text = { enabled = true },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'lua' },
    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },
  },
}
