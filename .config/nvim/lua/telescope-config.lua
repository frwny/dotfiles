require('telescope').setup {
  defaults = require('telescope.themes').get_ivy {
    -- Use grep wihtout rg dependency
    vimgrep_arguments = {
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
    },
  },
}
