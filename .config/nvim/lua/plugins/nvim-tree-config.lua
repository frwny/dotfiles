return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup{
      sync_root_with_cwd = false,
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 40,
        signcolumn = "no",
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    }
  end,
}
