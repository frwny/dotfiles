local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function multi_open(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_selection = picker:get_multi_selection()

  if #multi_selection > 0 then
    actions.close(prompt_bufnr)
    for _, entry in ipairs(multi_selection) do
      if entry.path then
        vim.cmd("edit " .. entry.path)
      end
    end
  else
    actions.select_default(prompt_bufnr)
    actions.center(prompt_bufnr)
  end
end

return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    require('telescope').setup({
      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        }
      },
      defaults = require('telescope.themes').get_dropdown {
        layout_config = {
          width = 0.8,
          anchor = "N",
        },
        mappings = {
          -- your custom insert mode mappings
          i = {
            ["<CR>"] = multi_open,
          },
          -- your custom normal mode mappings
          n = {
            ["<CR>"] = multi_open,
            ["v"] = "select_vertical",
            ["V"] = "select_horizontal"
          },
        },
        -- Use grep wihtout rg dependency
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
        file_ignore_patterns = {
          "^.git/*",
          ".terraform/*",
          "node_modules/*",
          "Music",
          ".runelite",
          "pipx",
        },
      },
      pickers = {
        buffers = {
          show_all_buffers = true,
          sort_lastused = true,
          mappings = {
            n = {
              -- your custom normal mode mappings
              ["<leader>bd"] = "delete_buffer"
            },
          },
        },
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          hidden = true
        },
      },
    })
    require('telescope').load_extension('fzf')
  end,
}


