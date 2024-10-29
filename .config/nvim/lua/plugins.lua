return require('packer').startup(function(use)
-- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'

-- vanity plugins
  use 'nvim-lualine/lualine.nvim'
  use 'nvim-tree/nvim-web-devicons'
  use 'cohlin/vim-colorschemes'
  use 'gbprod/nord.nvim'
  use 'folke/zen-mode.nvim'
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
  use 'rachartier/tiny-inline-diagnostic.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

-- utility plugins
  use 'ggandor/leap.nvim'
  use 'tpope/vim-commentary'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'tpope/vim-surround'
  use 'nvim-telescope/telescope.nvim'
  use { 'lambdalisue/fern.vim',
    requires = {
      { 'lambdalisue/glyph-palette.vim' },
      { 'TheLeoP/fern-renderer-web-devicons.nvim' },
      { 'lambdalisue/fern-git-status.vim' }
    }
  }
  use {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup {}
    end
  }

end)


