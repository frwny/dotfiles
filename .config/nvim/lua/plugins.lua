return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Simple plugins can be specified as strings
  use 'nvim-lua/plenary.nvim'
  use 'axkirillov/easypick.nvim'
  use 'nvim-lualine/lualine.nvim'
  -- use 'vim-airline/vim-airline'
  -- use 'vim-airline/vim-airline-themes'
  use 'cohlin/vim-colorschemes'
  -- use 'arcticicestudio/nord-vim'
  use 'gbprod/nord.nvim'
  use 'ggandor/leap.nvim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-commentary'
  use 'folke/zen-mode.nvim'
  use 'nvim-tree/nvim-web-devicons' 
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use 'lukas-reineke/indent-blankline.nvim'

  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'nvim-telescope/telescope.nvim'

  use {
  "startup-nvim/startup.nvim", requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
  }

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


