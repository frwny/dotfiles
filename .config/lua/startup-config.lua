require('startup').setup({
  theme = "dashboard",
  options = {
    mapping_keys = true, -- display mapping (e.g. <leader>ff)

    -- if < 1 fraction of screen width
    -- if > 1 numbers of column
    cursor_column = 0.5,
    empty_lines_between_mappings = false, -- add an empty line between mapping/commands
    disable_statuslines = true, -- disable status-, buffer- and tablines
    paddings = {1,2}, -- amount of empty lines before each section (must be equal to amount of sections)
  }
})
