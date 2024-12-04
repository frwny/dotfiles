require("everforest").setup({
  background = "hard",
  on_highlights = function(hl, palette)
    -- hl.NvimTreeNormal = { fg = palette.fg, bg = palette.bg }
    -- hl.NvimTreeEndOfBuffer = { fg = palette.bg, bg = palette.bg }
    -- hl.NvimTreeSignColumn = { fg = palette.bg, bg = palette.bg }
    -- hl.NvimTreeLineNr = { fg = palette.bg, bg = palette.bg }
    -- hl.NvimTreeIndentMarker = { fg = palette.bg4, bg = palette.bg }
  end,
  colours_override = function (palette)
    palette.bg0 = "#1e2326"
  end

})
