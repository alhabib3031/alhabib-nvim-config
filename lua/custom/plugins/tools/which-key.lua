-- lua/custom/plugins/tools/which-key.lua
-- Keyboard shortcut helper (IDE cheatsheet)

return {
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      delay = 0,
      icons = { mappings = true },
      spec = {
        { "<leader>s",  group = "[S]earch" },
        { "<leader>o",  group = "[O]pen" },
        { "<leader>t",  group = "[T]oggle" },
        { "<leader>h",  group = "Git [H]unk",         mode = { "n", "v" } },
        { "<leader>d",  group = "[D]otnet / [D]ebug" },
        { "<leader>n",  group = "[N]eotest" },
        { "<leader>r",  group = "[R]ename/Replace" },
        { "gr",         group = "LSP Actions" },
      },
    },
  },
}
