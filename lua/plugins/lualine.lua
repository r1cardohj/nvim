return {
	"nvim-lualine/lualine.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile"},
	config = function()
    require("darkvoid").setup()
  end
}
