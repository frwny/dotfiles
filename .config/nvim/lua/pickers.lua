local previewers = require('telescope.previewers')
local builtin    = require('telescope.builtin')

local M = {}

M.project_files = function(opts)
  opts = opts or {
    find_command = {
      "grep",
        "--extended-regexp",
        "--color=never",
        "--with-filename",
        "--line-number",
        "-b", -- grep doesn't support a `--column` option :(
        "--ignore-case",
        "--recursive",
        "--no-messages",
        "--exclude-dir=*cache*",
        "--exclude-dir=*.git",
    },
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
