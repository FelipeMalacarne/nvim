return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false }, -- handled by blink-copilot
      panel = { enabled = false },
    },
  },
  {
    "fang2hou/blink-copilot",
    dependencies = { "zbirenbaum/copilot.lua" },
  },
}
