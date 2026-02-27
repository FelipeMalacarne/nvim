-- nvim-treesitter v2 (rewritten for Neovim 0.11+)
-- No more require("nvim-treesitter.configs").setup() — API has changed.
-- Highlighting is enabled via vim.treesitter.start() in a FileType autocmd.
-- Parser install is done via require("nvim-treesitter").install({...}).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy  = false, -- plugin does not support lazy-loading
    config = function()
      -- Neovim 0.11+ bundles: c, lua, vim, vimdoc, query, markdown, markdown_inline
      -- Install the rest we need
      require("nvim-treesitter").install({
        -- Go
        "go", "gomod", "gosum", "gotmpl",
        -- PHP / Laravel
        "php", "phpdoc",
        -- TypeScript / React
        "typescript", "tsx", "javascript", "jsdoc",
        -- Web
        "html", "css", "scss", "json", "jsonc", "yaml",
        -- Shell
        "bash",
        -- Git
        "gitcommit", "gitignore", "diff",
        -- Misc
        "toml", "dockerfile", "regex",
      })

      -- Filetypes where we enable treesitter highlighting
      -- (bundled parsers are included so lua/vim/markdown work out of the box)
      local ft_pattern = {
        "go", "gomod", "gotmpl",
        "php",
        "typescript", "tsx", "javascript",
        "html", "css", "scss", "json", "jsonc", "yaml",
        "lua", "vim", "vimdoc",
        "markdown", "markdown_inline",
        "bash", "sh",
        "gitcommit", "diff",
        "toml", "dockerfile",
      }

      vim.api.nvim_create_autocmd("FileType", {
        group   = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        pattern = ft_pattern,
        callback = function(ev)
          -- Skip very large files
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
          if ok and stats and stats.size > 100 * 1024 then return end
          vim.treesitter.start()
        end,
      })
    end,
  },
}
