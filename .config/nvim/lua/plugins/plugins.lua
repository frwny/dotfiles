return {
  -- vanity plugins
    'dstein64/vim-startuptime',
  {
    'goolord/alpha-nvim',
    lazy = false,
    config = function()
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  },

  -- git plugins
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
  },
  {
    'airblade/vim-gitgutter',
    event = 'VeryLazy',
  },

  -- lsp, syntax and linting plugins
  'https://github.com/mason-org/mason.nvim',
  -- 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  'j-hui/fidget.nvim',

  -- utility plugins
  {
    'tpope/vim-commentary',
    event = 'VeryLazy',
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
  },
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
  },
  {
    'windwp/nvim-autopairs',
    event = "VeryLazy",
  },
  {
    'stevearc/quicker.nvim',
    event = "VeryLazy",
  },
}
