return {
	"nvim-lualine/lualine.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile"},
	config = function()
    require('lualine').setup({
      theme = 'tokyonight'
    })
  end
}
