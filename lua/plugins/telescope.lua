return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<C-p>",
				function()
					local builtin = require("telescope.builtin")
					builtin.find_files()
				end,
				desc = "Telescope find files",
			},
			{
				"<leader>fg",
				function()
					local builtin = require("telescope.builtin")
					builtin.live_grep()
				end,
			},
		}
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
