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
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  }
}
