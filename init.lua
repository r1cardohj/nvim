-- init.lua
-- 使用 lazy.nvim 管理插件，配置 coc.nvim

-- 设置 leader 键
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 基础设置
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.pumheight = 10
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300 -- 这会影响 Coc 的响应速度

-- 安装 lazy.nvim (如果尚未安装)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 插件列表
require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
        }
      })
    end
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = "yarn install --frozen-lockfile",
    init = function()
      -- Coc 配置 (JSON 格式的 Lua 写法)
      vim.g.coc_global_extensions = {
        'coc-json',
        'coc-lua',
        'coc-tsserver',
        'coc-pyright',
        'coc-go',
        'coc-rust-analyzer',
        'coc-html',
        'coc-css',
        'coc-snippets',
      }
    end,
    config = function()
      -- Coc.nvim 的键位映射和基本设置
      -- 使用 Tab 进行补全导航
      function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end

      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      vim.keymap.set("i", "<TAB>",
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
      vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

      -- 使用tab确认补全
      vim.keymap.set("i", "<tab>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
        opts)

      -- LSP 相关键位
      vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
      vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
      vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })
      vim.keymap.set('n', 'K', '<Plug>(coc-do-hover)', { silent = true })

      -- 代码操作
      vim.keymap.set('n', '<leader>rn', '<Plug>(coc-rename)', { silent = true })
      vim.keymap.set('n', '<leader>ca', '<Plug>(coc-codeaction)', { silent = true })
      vim.keymap.set('x', '<leader>ca', '<Plug>(coc-codeaction-selected)', { silent = true })

      -- 格式化
      vim.keymap.set('n', '<leader>f', '<Plug>(coc-format)', { silent = true })
      vim.keymap.set('x', '<leader>f', '<Plug>(coc-format-selected)', { silent = true })

      -- 诊断导航
      vim.keymap.set('n', '[d', '<Plug>(coc-diagnostic-prev)', { silent = true })
      vim.keymap.set('n', ']d', '<Plug>(coc-diagnostic-next)', { silent = true })

      -- text obj
      vim.keymap.set("x", "if", "<Plug>(coc-funcobj-i)", opts)
      vim.keymap.set("o", "if", "<Plug>(coc-funcobj-i)", opts)
      vim.keymap.set("x", "af", "<Plug>(coc-funcobj-a)", opts)
      vim.keymap.set("o", "af", "<Plug>(coc-funcobj-a)", opts)
      vim.keymap.set("x", "ic", "<Plug>(coc-classobj-i)", opts)
      vim.keymap.set("o", "ic", "<Plug>(coc-classobj-i)", opts)
      vim.keymap.set("x", "ac", "<Plug>(coc-classobj-a)", opts)
      vim.keymap.set("o", "ac", "<Plug>(coc-classobj-a)", opts)

      -- scroll float windows
      vim.keymap.set("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      vim.keymap.set("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      vim.keymap.set("i", "<C-f>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      vim.keymap.set("i", "<C-b>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      vim.keymap.set("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      vim.keymap.set("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


      -- 其他功能
      vim.keymap.set('n', '<leader>cl', '<Cmd>CocList<CR>', { silent = true })
      vim.keymap.set('n', '<leader>d', '<Cmd>CocList diagnostics<CR>', { silent = true })
      vim.keymap.set('n', '<leader>e', '<Cmd>CocList extensions<CR>', { silent = true })
      vim.keymap.set('n', '<leader>c', '<Cmd>CocList commands<CR>', { silent = true })
      vim.keymap.set('n', '<leader>o', '<Cmd>CocList outline<CR>', { silent = true })

      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- " Add `:Fold` command to fold current buffer
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = '?' })

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

      -- 显示文档
      function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end

      -- 高亮光标
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold"
      })
      vim.keymap.set("n", "<leader>h", '<CMD>lua _G.show_docs()<CR>', { silent = true })
    end,
  }
}, {
  install = {
    colorscheme = { "habamax" }
  }
})

-- 颜色方案
vim.cmd.colorscheme("habamax")

-- 自定义键位
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>')
vim.keymap.set('n', '<leader>Q', '<cmd>qa!<CR>')

print("coc.nvim 配置加载完成！使用 :Lazy 管理插件")
