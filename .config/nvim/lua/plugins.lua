return require('packer').startup(function(use)
-- core plugins
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'

-- vanity plugins
  use 'nvim-lualine/lualine.nvim'
  use 'nvim-tree/nvim-web-devicons'
  use 'gbprod/nord.nvim'
  use 'folke/zen-mode.nvim'
  use 'neanias/everforest-nvim'
  use {
    "startup-nvim/startup.nvim",
    requires = {
      "nvim-telescope/telescope-file-browser.nvim"
    },
  }

-- git plugins
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'

-- lsp, syntax and linting plugins
  use 'neovim/nvim-lspconfig'
  -- use 'saghen/blink.cmp'
  use 'https://github.com/mason-org/mason.nvim'
  -- use 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
  use 'rachartier/tiny-inline-diagnostic.nvim'
  use 'j-hui/fidget.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

-- utility plugins
  use 'rmagatti/auto-session'
  use 'tpope/vim-commentary'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'kylechui/nvim-surround'
  use 'nvim-telescope/telescope.nvim'
  use 'windwp/nvim-autopairs'
  use 'stevearc/quicker.nvim'
  -- use 'nvim-tree/nvim-tree.lua'
end)


