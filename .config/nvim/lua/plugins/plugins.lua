return {
-- vanity plugins
  'dstein64/vim-startuptime',
  {
    'goolord/alpha-nvim',
    config = function()
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  },

-- git plugins
  'tpope/vim-fugitive',
  'airblade/vim-gitgutter',

-- lsp, syntax and linting plugins
  'https://github.com/mason-org/mason.nvim',
  -- 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  'j-hui/fidget.nvim',

-- utility plugins
  'tpope/vim-commentary',
  'lukas-reineke/indent-blankline.nvim',
  'kylechui/nvim-surround',
  'windwp/nvim-autopairs',
  'stevearc/quicker.nvim',
}
