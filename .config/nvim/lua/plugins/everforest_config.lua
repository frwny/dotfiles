return {
  'neanias/everforest-nvim',
  config = function()
    require("everforest").setup({
      background = "hard",
      on_highlights = function(hl, palette)
        hl.NvimTreeNormal = { fg = palette.fg, bg = palette.bg }
        hl.NvimTreeEndOfBuffer = { fg = palette.bg, bg = palette.bg }
        hl.NvimTreeSignColumn = { fg = palette.bg, bg = palette.bg }
        hl.NvimTreeLineNr = { fg = palette.bg, bg = palette.bg }
        hl.NvimTreeIndentMarker = { fg = palette.bg4, bg = palette.bg }
        -- hl.MsgArea = { fg = palette.fg, bg = palette.bg_dim }
        -- hl.VertSplit = { fg = palette.bg4, bg = palette.bg_dim }
        -- hl.NormalFloat = { fg = palette.bg4, bg = palette.bg_dim }
      end,
    })
  end,
}
