return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      source = {
        null_ls.builtins.formatting.stylelua,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
      }
    })
    vim.keymap.set("n", '<leader>F', vim.lsp.buf.format, {})
  end
}
