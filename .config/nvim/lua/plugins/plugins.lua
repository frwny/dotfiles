return {
  -- vanity
  'dstein64/vim-startuptime',
  -- lsp, syntax and linting plugins
  -- 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  'https://github.com/mason-org/mason.nvim',
  'j-hui/fidget.nvim',
  -- git plugins
  { 'tpope/vim-fugitive', event = 'VeryLazy' },
  { 'airblade/vim-gitgutter', event = 'VeryLazy' },
  -- utility plugins
  { 'tpope/vim-commentary', event = 'VeryLazy' },
  { 'windwp/nvim-autopairs', event = "VeryLazy" },
  { 'stevearc/quicker.nvim', event = "VeryLazy" },
  { 'lukas-reineke/indent-blankline.nvim', event = 'VeryLazy' },

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
    config = function()
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  },
  { 
    'alexghergh/nvim-tmux-navigation', 
    config = function()
      require'nvim-tmux-navigation'.setup {
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        }
      }
    end
}
}
