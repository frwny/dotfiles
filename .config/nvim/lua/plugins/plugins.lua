return {
  -- vanity
  'dstein64/vim-startuptime',
  -- lsp, syntax and linting plugins
  -- 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  'https://github.com/mason-org/mason.nvim',
  { 'j-hui/fidget.nvim', opts = {},},
  -- git plugins
  { 'tpope/vim-fugitive', event = 'VeryLazy' },
  { 'airblade/vim-gitgutter', event = 'VeryLazy' },
  -- utility plugins
  { 'tpope/vim-commentary', event = 'VeryLazy' },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
  { 'stevearc/quicker.nvim', event = "VeryLazy" },
  { 'lukas-reineke/indent-blankline.nvim', 
    event = 'VimEnter', 
    require('ibl').setup(),
    main = 'ibl',
    opts = {
      indent = { char = "│" },
    }
  },

  -- plugins that require setup
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({})
    end
  },
  {
    'goolord/alpha-nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  },
}
