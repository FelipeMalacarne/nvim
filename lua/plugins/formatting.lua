return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    keys  = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format buffer (conform)",
      },
    },
    opts = {
      formatters_by_ft = {
        lua        = { "stylua" },
        go         = { "goimports", "gofmt" },
        php        = { "pint" },        -- Laravel Pint (falls back to php-cs-fixer)
        blade      = { "blade-formatter" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json       = { "prettier" },
        yaml       = { "prettier" },
        markdown   = { "prettier" },
        css        = { "prettier" },
        scss       = { "prettier" },
        html       = { "prettier" },
        sh         = { "shfmt" },
      },
      -- Format on save (async to avoid blocking)
      format_on_save = function(bufnr)
        -- Disable for files in node_modules or vendor
        local path = vim.api.nvim_buf_get_name(bufnr)
        if path:match("node_modules") or path:match("/vendor/") then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    },
  },
}
