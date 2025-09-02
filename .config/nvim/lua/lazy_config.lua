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

-- auto-load plugins/*.lua
local plugin_files = {}
local scan = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/plugins", "*.lua", true, true)
for _, file in ipairs(scan) do
  local mod = file:match("lua/(.+)%.lua$"):gsub("/", ".")
  table.insert(plugin_files, require(mod))
end

require("lazy").setup({
  spec = {
    -- vanity
    { "dstein64/vim-startuptime" },

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
      event = "VimEnter",
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
        require("alpha").setup(require("alpha.themes.dashboard").config)
      end
    },

    -- { "nvim-treesitter/nvim-treesitter",
    --   build = ":TSUpdate",
    --   config = function()
    --     require("nvim-treesitter.configs").setup({
    --     highlight = { enable = true },
    --     indent = { enable = true },
    --   })
    -- end
    -- },


    -- auto-import plugins from lua/plugins/*.lua
    unpack(plugin_files),
  },
  checker = { enabled = true },
})

