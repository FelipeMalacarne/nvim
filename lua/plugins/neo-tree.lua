return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch       = "v3.x",
    cmd          = "Neotree",
    keys         = {
      { "<leader>e", "<cmd>Neotree toggle<cr>",                  desc = "Explorer (root)" },
      { "<leader>E", "<cmd>Neotree toggle dir=%:p:h<cr>",        desc = "Explorer (file dir)" },
      { "<leader>ge", "<cmd>Neotree float git_status<cr>",       desc = "Git status (neo-tree)" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      sources = { "filesystem", "git_status" },
      source_selector = {
        winbar = true,
      },
      filesystem = {
        bind_to_cwd       = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible         = false,
          hide_dotfiles   = false,
          hide_gitignored = false,
          hide_by_name    = { ".git", "node_modules", "vendor" },
        },
      },
      window = {
        width = 35,
        mappings = {
          ["<space>"] = "none", -- don't shadow leader
          ["l"]       = "open",
          ["h"]       = "close_node",
        },
      },
      default_component_configs = {
        indent = { with_expanders = true },
        icon   = {
          folder_closed = "",
          folder_open   = "",
          folder_empty  = "󰜌",
        },
        git_status = {
          symbols = {
            added     = "",
            modified  = "",
            deleted   = "✖",
            renamed   = "󰁕",
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },
    },
  },
}
