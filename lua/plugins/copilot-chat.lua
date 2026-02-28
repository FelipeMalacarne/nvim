return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "zbirenbaum/copilot.lua" },
    cmd = { "CopilotChat", "CopilotChatCommit" },
    keys = {
      -- Quick actions picker
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        mode = { "n", "v" },
        desc = "Copilot quick actions",
      },
      -- Commit message
      {
        "<leader>ac",
        function()
          require("CopilotChat").ask(
            "Write a commit message for the staged changes. Follow conventional commits format. Only output the commit message, no explanation.",
            { context = "git:staged" }
          )
        end,
        desc = "Copilot commit message",
      },
      -- Toggle chat window
      {
        "<leader>aa",
        function()
          require("CopilotChat").toggle()
        end,
        mode = { "n", "v" },
        desc = "Copilot toggle chat",
      },
    },
    opts = {
      window = {
        layout = "float",
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
    },
  },
}
