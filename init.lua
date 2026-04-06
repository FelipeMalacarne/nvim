-- Leader keys — must be set before lazy.nvim loads anything
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
    }, true, {})
    vim.cmd.quit()
  end
end
vim.opt.rtp:prepend(lazypath)

-- Core config
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")

-- Statusline
require("statusline").setup()

-- Plugins (lazy.nvim auto-discovers all files under lua/plugins/)
require("lazy").setup("plugins", {
  defaults        = { lazy = false },
  -- install         = { colorscheme = { "catppuccin" } },
  checker         = { enabled = true, notify = false },
  change_detection = { notify = false },
  -- When running from the nix store the config dir is read-only,
  -- so keep the lock file in the writable data directory instead.
  lockfile = vim.env.NIX_MANAGED == "1"
    and vim.fn.stdpath("data") .. "/lazy-lock.json"
    or vim.fn.stdpath("config") .. "/lazy-lock.json",
})

-- lazy.nvim resets runtimepath during setup, so Nix-provided treesitter parsers
-- must be re-added after setup completes.
if vim.env.NIX_MANAGED == "1" and vim.env.NVIM_TREESITTER_PARSERS then
  vim.opt.rtp:append(vim.env.NVIM_TREESITTER_PARSERS)
end
