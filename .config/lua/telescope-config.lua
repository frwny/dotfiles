require('telescope').setup {
  defaults = require('telescope.themes').get_ivy {
    -- Use grep wihtout rg dependency
    vimgrep_arguments = {
      "git", "grep", "--full-name", "--line-number", "--column", "--extended-regexp", "--ignore-case",
      "--no-color", "--recursive", "--recurse-submodules", "-I"
    },
  },
}

