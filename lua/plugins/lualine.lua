return {
	"nvim-lualine/lualine.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile"},
	config = function()
		require("lualine").setup({
			options = {
				theme = "tokyonight",
			},
		})
	end,
}
