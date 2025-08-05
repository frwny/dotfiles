local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local plugins = {
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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- automatically check for plugin updates
  checker = { enabled = true },
})
