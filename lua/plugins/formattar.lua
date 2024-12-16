return {
  "stevearc/conform.nvim",
  lazy = true,
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>F",
      function()
        require("conform").format()
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
    },
  },
  opts = function()
    local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,           -- not recommended to change
        quiet = false,           -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        python = { "ruff_format", "ruff_organize_imports" }
      },
    }
    return opts
  end,
}
