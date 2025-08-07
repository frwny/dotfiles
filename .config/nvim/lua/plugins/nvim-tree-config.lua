return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup{
      view = {},
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
        dotfiles = true,
      },
    }
  end,
}
-- require("nvim-tree").setup({
--   on_attach = keymaps,
--   sync_root_with_cwd = false,
--   sort = {
--     sorter = "case_sensitive",
--   },
--   view = {
--     width = 40,
--     signcolumn = "no",
--   },
--   renderer = {
--     indent_markers = {
--       enable = true,
--     },
--     group_empty = true,
--   },
--   filters = {
--     dotfiles = true,
--   },
-- })

