-- lua/lazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
local unpack = table.unpack or unpack  -- make sure unpack exists

require("lazy").setup({
  spec = {
    -- lsp, syntax and linting
    { "mason-org/mason.nvim" },
    { "j-hui/fidget.nvim", opts = {} },

    -- git plugins
    { "tpope/vim-fugitive", event = "VeryLazy" },
    { "airblade/vim-gitgutter", event = "VeryLazy" },

    -- utility
    { "tpope/vim-commentary", event = "VeryLazy" },
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
    { "stevearc/quicker.nvim", event = "VeryLazy" },

    { "lukas-reineke/indent-blankline.nvim",
      event = "VeryLazy",
      config = function()
        require("ibl").setup({
          indent = { char = "│" },
        })
      end,
    },

    -- plugins that require setup
    { "kylechui/nvim-surround",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({})
      end
    },

    { "nvim-tree/nvim-tree.lua",
      cmd = "NvimTreeFindFileToggle",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("configs.nvim-tree-config").setup()
      end
    },

    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

    { "goolord/alpha-nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("alpha").setup(require("alpha.themes.steps").config)
      end
    },

    -- auto-import plugins from lua/plugins/*.lua
    { import = "plugins", }
  },
  checker = { enabled = true },
})

