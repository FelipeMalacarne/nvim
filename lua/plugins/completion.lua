return {
  {
    "saghen/blink.cmp",
    version = "*", -- use a release tag
    event   = { "InsertEnter" },
    opts = {
      keymap = {
        preset = "default",
        -- Override specific keys
        ["<Tab>"]   = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"]    = { "accept", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"]   = { "hide" },
        ["<C-b>"]   = { "scroll_documentation_up", "fallback" },
        ["<C-f>"]   = { "scroll_documentation_down", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant        = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          -- Raise LSP priority so it shows first
          lsp = { score_offset = 5 },
        },
      },
      completion = {
        documentation = {
          auto_show       = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = { enabled = true },
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },
      },
      signature = { enabled = true },
    },
  },
}
