return {
  {
    "nvim-telescope/telescope.nvim",
    cmd  = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",               desc = "Find files" },
      { "<leader><leader>", "<cmd>Telescope find_files<cr>",               desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",                desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                  desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",                desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                 desc = "Recent files" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",     desc = "Document symbols" },
      { "<leader>fw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>",              desc = "Diagnostics" },
      -- { "<leader>gc", "<cmd>Telescope git_commits<cr>",              desc = "Git commits" },
      -- { "<leader>gs", "<cmd>Telescope git_status<cr>",               desc = "Git status" },
      -- { "<leader>gb", "<cmd>Telescope git_branches<cr>",             desc = "Git branches" },
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond  = function() return vim.fn.executable("make") == 1 end,
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    opts = {
      defaults = {
        prompt_prefix   = "  ",
        selection_caret = " ",
        path_display    = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          vertical   = { mirror = false },
          width      = 0.87,
          height     = 0.80,
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-q>"] = "send_to_qflist",
            ["<esc>"] = "close",
          },
        },
      },
    },
  },
}
