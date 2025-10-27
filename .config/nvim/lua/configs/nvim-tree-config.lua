local M = {}

local api = require("nvim-tree.api")

local function edit_or_open()
  local node = api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    api.node.open.edit()
  else
    -- open file
    api.node.open.edit()
  end
end

-- open as vsplit on current node
local function vsplit_preview()
  local node = api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    api.node.open.edit()
  else
    -- open file as vsplit
    api.node.open.vertical()
  end

  -- Finally refocus on tree if it was lost
  api.tree.focus()
end

local function my_on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- on_attach
  vim.keymap.set("n", "l", edit_or_open,          opts("Edit Or Open"))
  vim.keymap.set("n", "L", vsplit_preview,        opts("Vsplit Preview"))
  vim.keymap.set("n", "h", api.tree.close,        opts("Close"))
  vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
  vim.keymap.set("n", "v", api.node.open.vertical, opts("Split Vertical"))
  vim.keymap.set("n", "V", api.node.open.horizontal, opts("Split Horizontal"))
end

function M.setup()
  require("nvim-tree").setup({
    sync_root_with_cwd = false,
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 40,
      signcolumn = "no",
    },
    renderer = {
      highlight_bookmarks = "name",
      icons = {
        show = {
          bookmarks = true,
        },
      },
      indent_markers = {
        enable = true,
      },
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
    on_attach = my_on_attach,
  })
end

return M
