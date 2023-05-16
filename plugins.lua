return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Simple plugins can be specified as strings
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'axkirillov/easypick.nvim'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'cohlin/vim-colorschemes'
  use 'arcticicestudio/nord-vim'
  use 'sheerun/vim-polyglot'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-commentary'
  use 'nvim-tree/nvim-web-devicons'
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'lambdalisue/fern.vim',
    requires = {
      { 'lambdalisue/glyph-palette.vim' },
      { 'TheLeoP/fern-renderer-web-devicons.nvim' },
      { 'lambdalisue/fern-git-status.vim' }
    }
  }
end)
