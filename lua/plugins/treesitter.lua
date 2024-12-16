return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
  event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
	config = function()
		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all" (the listed parsers MUST always be installed)
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true, disable = { "python" } },
		})
	end,
}
