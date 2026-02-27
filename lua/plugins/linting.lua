return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        php        = { "phpstan" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        go         = { "golangcilint" },
        lua        = { "selene" },
      }

      -- Run linter on save and after leaving insert mode
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
          -- Only lint if a config file exists for the linter
          lint.try_lint()
        end,
      })
    end,
  },
}
