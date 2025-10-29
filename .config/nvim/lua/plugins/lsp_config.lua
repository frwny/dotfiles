return {
  'neovim/nvim-lspconfig',
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    { 'j-hui/fidget.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'saghen/blink.cmp',
  },

  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local servers = {
      pyright = {},
      terraformls = {},
      bashls = {},
      lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- tell lua_ls it’s neovim lua
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' }, -- stop whining about vim
              disable = { 'missing-fields' }, -- optional, kills noisy warnings
            },
            workspace = {
              checkThirdParty = false, -- stop telemetry nags
              library = vim.api.nvim_get_runtime_file('', true),
            },
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
    }

    -- configure each server manually
    for name, opts in pairs(servers) do
      opts.capabilities = capabilities
      vim.lsp.config(name, opts)
    end

    -- setup mason-lspconfig
    require("mason-lspconfig").setup {
      ensure_installed = vim.tbl_keys(servers),
      automatic_enable = true,   -- auto-enable installed servers
    }

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

