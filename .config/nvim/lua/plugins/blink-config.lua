return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = { 'rafamadriz/friendly-snippets' },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      nerd_font_variant = mono,
    },
    keymap = { preset = 'super-tab' },
    completion = {
      ghost_text = { enabled = true },
    },
    cmdline = {
      enabled = false,
    }
  }
}
