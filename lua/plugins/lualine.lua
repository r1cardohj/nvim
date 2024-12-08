return {
  "nvim-lualine/lualine.nvim",
  opts = {

  },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'tokyonight'
      }
    })
  end
}
