local M = {}

function M.setup()
  local git        = require("statusline.git")
  local components = require("statusline.components")

  -- Expose to v:lua for use in statusline format strings
  _G.stl_mode_icon  = components.mode_icon
  _G.stl_git_branch = git.branch
  _G.stl_file_type  = components.file_type
  _G.stl_file_size  = components.file_size

  vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

  local group = vim.api.nvim_create_augroup("statusline", { clear = true })

  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = group,
    callback = function()
      vim.opt_local.statusline = table.concat({
        "  ",
        "%#StatusLineBold#%{v:lua.stl_mode_icon()}%#StatusLine#",
        " \u{e0b1} %f %h%m%r",
        "%{v:lua.stl_git_branch()}",
        "\u{e0b1} %{v:lua.stl_file_type()}",
        "\u{e0b1} %{v:lua.stl_file_size()}",
        "%=",
        " \u{f017} %l:%c  %P ",
      })
    end,
  })

  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = group,
    callback = function()
      vim.opt_local.statusline =
        "  %f %h%m%r \u{e0b1} %{v:lua.stl_file_type()} %=  %l:%c   %P "
    end,
  })
end

return M
