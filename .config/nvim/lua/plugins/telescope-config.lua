return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    require('telescope').setup{
      defaults = require('telescope.themes').get_dropdown {
        layout_config = {
          width = 0.8,
          anchor = "N",
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
      extensions = {
        file_browser = {
          theme = "ivy",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            ["i"] = {
              -- your custom insert mode mappings
            },
            ["n"] = {
              -- your custom normal mode mappings
            },
          },
        },
      },
    }
  end,
}


