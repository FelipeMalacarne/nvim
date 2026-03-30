 local M = {}

 function M.setup()
   require('base16-colorscheme').setup {
     -- Background tones
     base00 = '#17120f', -- Default Background
     base01 = '#241e1b', -- Lighter Background (status bars)
     base02 = '#2f2925', -- Selection Background
     base03 = '#9e8d82', -- Comments, Invisibles
     -- Foreground tones
     base04 = '#d6c3b7', -- Dark Foreground (status bars)
     base05 = '#ece0da', -- Default Foreground
     base06 = '#ece0da', -- Light Foreground
     base07 = '#ece0da', -- Lightest Foreground
     -- Accent colors
     base08 = '#ffb4ab', -- Variables, XML Tags, Errors
     base09 = '#c6cb96', -- Integers, Constants
     base0A = '#e3c0a6', -- Classes, Search Background
     base0B = '#ffb77f', -- Strings, Diff Inserted
     base0C = '#c6cb96', -- Regex, Escape Chars
     base0D = '#ffb77f', -- Functions, Methods
     base0E = '#e3c0a6', -- Keywords, Storage
     base0F = '#93000a', -- Deprecated, Embedded Tags
   }
 end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
