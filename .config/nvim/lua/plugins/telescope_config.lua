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
          ["n"] = {
            -- your custom normal mode mappings
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
          mappings = {
            ["n"] = {
              -- your custom normal mode mappings
              ["<leader>bd"] = "delete_buffer"
            },
          },
        },
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          hidden = true
        }
      },
    })
    require('telescope').load_extension('fzf')
  end,
}


