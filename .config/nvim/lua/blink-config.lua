require('blink.cmp').setup({
  opts{
    completion {
      completion.ghost_text {
        completion.ghost_text.enabled = true

        completion.menu.auto_show = false -- only show menu on manual <C-space>
        completion.ghost_text.show_with_menu = false -- only show when menu is closed
      }
    }
  }
})
