local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Stay in indent mode after shifting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n",     "nzzzv",   { desc = "Next search result (centered)" })
map("n", "N",     "Nzzzv",   { desc = "Prev search result (centered)" })

-- Save
map({ "n", "i" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Reload config
map("n", "<leader>rc", function()
  for _, mod in ipairs({ "config.options", "config.keymaps", "config.autocmds" }) do
    package.loaded[mod] = nil
    require(mod)
  end
  vim.notify("Config reloaded")
end, { desc = "Reload config" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Code diagnostics" })

-- Quit
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
