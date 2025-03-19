local util = require("conform.util")
return {
  "stevearc/conform.nvim",
  opts = function()
    local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        php = { "pint" },
        blade = { "blade-formatter" },
        python = { "black" },
        go = { "gofmt" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        pint = {
          meta = {
            url = "https://github.com/laravel/pint",
            description = "Laravel Pint is an opinionated PHP code style fixer for minimalists.",
          },
          command = util.find_executable({
            vim.fn.stdpath("data") .. "/mason/bin/pint",
            "vendor/bin/pint --preset laravel",
          }, "pint"),
          args = { "$FILENAME" },
          stdin = false,
        },
        prettierd = {
          command = util.find_executable({
            vim.fn.stdpath("data") .. "/mason/bin/prettierd",
            "prettierd",
          }, "prettierd"),
          args = { "$FILENAME" },
          stdin = false,
        },
      },
    }
    return opts
  end,
}
