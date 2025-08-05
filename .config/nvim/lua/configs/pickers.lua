local previewers = require('telescope.previewers')
local builtin    = require('telescope.builtin')

local M = {}

M.project_files = function(opts)
  opts = opts or {
    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    file_ignore_patterns = {
      "^.git/*",
      "node_modules/*",
      "Music",
      ".runelite",
      "pipx"
    },
  }
  local ok = pcall(builtin.git_files, opts)
  if not ok then builtin.find_files(opts) end
end

return M
