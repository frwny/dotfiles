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
          resize_step_x = 4,
          resize_step_y = 2,
        },
        swap = {
          enable_default_keybindings = false,
        },
      })
    end
}
