return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
  },

  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local lspconfig = require('lspconfig')

    local servers = {
      pyright = {},
      terraformls = {},
      bashls = {},
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            completion = { callSnippet = 'Replace' },
          },
        },
      },
    }

    for name, opts in pairs(servers) do
      opts.capabilities = capabilities
      lspconfig[name].setup(opts)
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      end,
    })
  end,
}

