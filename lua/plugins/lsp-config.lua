return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			ensure_installed = { "pyright", "lua_ls" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		config = function()
			local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
						pyright = {
							disableOrganizeImports = true,
						},
						python = {
							analysis = {
								typeCheckingMode = "off",
							},
						},
					},
      })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", function()
				require("telescope.builtin").lsp_definitions({ reuse_win = true })
			end, {})
			vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>")
			vim.keymap.set("n", "gi", function()
				require("telescope.builtin").lsp_implementations({ reuse_win = true })
			end, {})
			vim.keymap.set("n", "gt", function()
				require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
			end, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
