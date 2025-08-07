return { 
    'aserowy/tmux.nvim', 
    config = function()
      require('tmux').setup({
        copy_sync = {
          enable = false, 
        },
        navigation = {
          enable_default_keybindings = false,
        },
        resize = {
          enable_default_keybindings = false,
        },
      })
    end
}
