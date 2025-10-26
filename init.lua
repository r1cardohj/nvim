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
--vim.o.laststatus = 3
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
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


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
  {
    "nvim-treesitter/nvim-treesitter",
    -- lazy = true,
    -- event = 'BufRead',
    build = ":TSUpdate",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "go", "gomod", "bash", "javascript" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      }

      -- run TSBufToggle highlight
      vim.cmd('TSBufToggle highlight')
    end,
  },
  { "tpope/vim-fugitive" },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeToggle<CR>', { silent = true })
    end
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          -- Defaults
          enable_close = true,          -- Auto close tags
          enable_rename = true,         -- Auto rename pairs of tags
          enable_close_on_slash = false -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          ["html"] = {
            enable_close = false
          }
        }
      })
    end
  },
  { "blazkowolf/gruber-darker.nvim" },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = false,
        }
      })
    end
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    lazy = false,
    config = function()
      require("oil").setup()
    end
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = { "GrugFar", "GrugFarWithin" },
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "honza/vim-snippets"
  },
  {
    "fannheyward/telescope-coc.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("telescope").setup({
        extensions = {
          coc = {
            theme = 'ivy',
            prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
            push_cursor_on_edit = true, -- save the cursor position to jump back in the future
            timeout = 3000,         -- timeout for coc commands
          }
        },
      })
      require('telescope').load_extension('coc')
    end
  },
  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
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
        'coc-tabnine',
        'coc-rust-analyzer',
        'coc-html',
        'coc-css',
        'coc-snippets',
        'coc-git'
      }
    end,
    config = function()
      -- Coc.nvim 的键位映射和基本设置
      -- 使用 Tab 进行补全导航

      -- function _G.check_back_space()
      --   local col = vim.fn.col('.') - 1
      --   return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      -- end
      --
      -- local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      -- vim.keymap.set("i", "<TAB>",
      --   'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
      -- vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
      --
      -- -- 使用tab确认补全
      -- vim.keymap.set("i", "<tab>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
      --   opts)

      vim.cmd([[
          inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()

        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        let g:coc_snippet_next = '<tab>'
      ]])

      -- LSP 相关键位
      vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
      -- vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      -- vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
      -- vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })
      vim.keymap.set('n', 'gr', '<Cmd>Telescope coc references<CR>', { silent = true })
      vim.keymap.set('n', 'gi', '<Cmd>Telescope coc implementations<CR>', { silent = true })
      vim.keymap.set('n', 'gt', '<Cmd>Telescope coc type_definitions<CR>', { silent = true })

      -- 代码操作
      vim.keymap.set('n', '<leader>rn', '<Plug>(coc-rename)', { silent = true })
      vim.keymap.set('n', '<leader>ca', '<Plug>(coc-codeaction)', { silent = true })
      vim.keymap.set('x', '<leader>ca', '<Plug>(coc-codeaction-selected)', { silent = true })

      -- 格式化
      vim.keymap.set('n', '<leader>F', '<Plug>(coc-format)', { silent = true })
      vim.keymap.set('x', '<leader>F', '<Plug>(coc-format-selected)', { silent = true })

      -- 诊断导航
      vim.keymap.set('n', '[d', '<Plug>(coc-diagnostic-prev)', { silent = true })
      vim.keymap.set('n', ']d', '<Plug>(coc-diagnostic-next)', { silent = true })

      local opts = { silent = true, nowait = true }
      -- text obj
      vim.keymap.set("x", "if", "<Plug>(coc-funcobj-i)", opts)
      vim.keymap.set("o", "if", "<Plug>(coc-funcobj-i)", opts)
      vim.keymap.set("x", "af", "<Plug>(coc-funcobj-a)", opts)
      vim.keymap.set("o", "af", "<Plug>(coc-funcobj-a)", opts)
      vim.keymap.set("x", "ic", "<Plug>(coc-classobj-i)", opts)
      vim.keymap.set("o", "ic", "<Plug>(coc-classobj-i)", opts)
      vim.keymap.set("x", "ac", "<Plug>(coc-classobj-a)", opts)
      vim.keymap.set("o", "ac", "<Plug>(coc-classobj-a)", opts)

      -- git
      vim.keymap.set("n", "[g", "<Plug>(coc-git-prevchunk)", { silent = true })
      vim.keymap.set("n", "]g", "<Plug>(coc-git-nextchunk)", { silent = true })
      vim.keymap.set("n", "[c", "<Plug>(coc-git-prevconflict)", { silent = true })
      vim.keymap.set("n", "]c", "<Plug>(coc-git-nextconflict)", { silent = true })
      vim.keymap.set("n", "<leader>gs", "<Plug>(coc-git-chunkinfo)", { silent = true })
      vim.keymap.set("n", "<leader>gc", "<Plug>(coc-git-commit)", { silent = true })

      -- scroll float windows
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true, expr = true }
      vim.keymap.set("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      vim.keymap.set("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      vim.keymap.set("i", "<C-f>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      vim.keymap.set("i", "<C-b>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      vim.keymap.set("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      vim.keymap.set("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


      -- 其他功能
      vim.keymap.set('n', '<leader><leader>', '<Cmd>Telescope coc<CR>', { silent = true })
      vim.keymap.set('n', '<leader>d', '<Cmd>Telescope coc diagnostics<CR>', { silent = true })
      vim.keymap.set('n', '<leader>cc', '<Cmd>Telescope coc commands<CR>', { silent = true })
      vim.keymap.set('n', "<leader>fm", '<Cmd>Telescope coc mru<CR>', { silent = true })
      vim.keymap.set('n', "<leader>fl", '<Cmd>Telescope coc links<CR>', { silent = true })
      vim.keymap.set('n', '<leader>o', '<Cmd>CocList outline<CR>', { silent = true })
      vim.keymap.set('n', '<leader>fs', '<Cmd>Telescope coc document_symbols<CR>', { silent = true })
      vim.keymap.set('n', '<leader>fws', '<Cmd>Telescope coc workspace_symbols<CR>', { silent = true })
      vim.keymap.set('n', '<leader>fwd', '<Cmd>Telescope coc workspace_diagnostics<CR>', { silent = true })

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
      vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })
    end,
  }
}, {
  install = {
    colorscheme = { "habamax" }
  }
})

-- 颜色方案
vim.cmd.colorscheme("gruber-darker")
