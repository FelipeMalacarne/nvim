local icons = require("statusline.icons")

local M = {}

function M.file_type()
  local ft = vim.bo.filetype
  if ft == "" then
    return " \u{f15b} " -- nf-fa-file_o
  end
  return (icons[ft] or " \u{f15b} ") .. ft
end

function M.file_size()
  local size = vim.fn.getfsize(vim.fn.expand("%"))
  if size < 0 then
    return ""
  end
  local size_str
  if size < 1024 then
    size_str = size .. "B"
  elseif size < 1024 * 1024 then
    size_str = string.format("%.1fK", size / 1024)
  else
    size_str = string.format("%.1fM", size / 1024 / 1024)
  end
  return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
end

function M.mode_icon()
  local mode  = vim.fn.mode()
  local modes = {
    n          = " \u{f121}  NORMAL",
    i          = " \u{f11c}  INSERT",
    v          = " \u{f0168} VISUAL",
    V          = " \u{f0168} V-LINE",
    ["\22"]    = " \u{f0168} V-BLOCK",
    c          = " \u{f120} COMMAND",
    s          = " \u{f0c5} SELECT",
    S          = " \u{f0c5} S-LINE",
    ["\19"]    = " \u{f0c5} S-BLOCK",
    R          = " \u{f044} REPLACE",
    r          = " \u{f044} REPLACE",
    ["!"]      = " \u{f489} SHELL",
    t          = " \u{f120} TERMINAL",
  }
  return modes[mode] or (" \u{f059} " .. mode)
end

return M
