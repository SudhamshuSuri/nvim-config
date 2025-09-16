-- Set leader at top for LazyVim-style keymaps!
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic settings
vim.opt.compatible = false
vim.opt.showmatch = true
vim.opt.mouse = "a"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.wildmode = { "longest", "list" }
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")
vim.opt.clipboard = "unnamedplus"
vim.opt.ttyfast = true
vim.opt.termguicolors = true

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {'catppuccin/nvim'},
  {'folke/tokyonight.nvim'},
  {'ellisonleao/gruvbox.nvim'},
  {'RRethy/base16-nvim'},
  {'neovim/nvim-lspconfig'},
  {'williamboman/mason.nvim', dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'jose-elias-alvarez/null-ls.nvim',
    'mfussenegger/nvim-lint',
    'mhartington/formatter.nvim',
  }},
  {'j-hui/fidget.nvim'},
  {'folke/neodev.nvim'},
  {'folke/trouble.nvim', dependencies = { "nvim-tree/nvim-web-devicons" }},
  {'hrsh7th/nvim-cmp', dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
  }},
  {'nvim-treesitter/nvim-treesitter', dependencies = {'nvim-treesitter/nvim-treesitter-textobjects'}},
  {'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' }},
  {'nvim-treesitter/playground'},
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
  {'nvim-lualine/lualine.nvim'},
  {'nvim-tree/nvim-web-devicons'},
  {'ntpeters/vim-better-whitespace'},
  {'cohama/lexima.vim'},
  {'kaarmu/typst.vim'},
  {'dccsillag/magma-nvim'},
  {'folke/which-key.nvim'},
  {'nvim-neo-tree/neo-tree.nvim', branch = "v3.x", dependencies = {'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim'}},
  { 
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup()
    end
  }
})

-- Colorscheme
require("catppuccin").setup({ flavour = "mocha" })
require("tokyonight").setup({ style = "night" })
require("gruvbox").setup({style = ""})
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

-- Mason setup
require("mason").setup({
  ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } }
})
require("mason-lspconfig").setup()

-- nvim-cmp setup
local cmp = require'cmp'
cmp.setup({
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'vsnip' }, }, { { name = 'buffer' }, }),
})

-- LSP servers
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup {}
lspconfig.clangd.setup {}
lspconfig.bashls.setup {}
lspconfig.jedi_language_server.setup {}
lspconfig.html.setup {}
lspconfig.cssls.setup {}
lspconfig.ts_ls.setup {}
lspconfig.tinymist.setup { filetype = { 'typst' } }
lspconfig.jdtls.setup {}

-- Treesitter setup
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      return ok and stats and stats.size > max_filesize
    end,
    additional_vim_regex_highlighting = false,
  },
}

require("bufferline").setup{}
require('lualine').setup { options = { theme = 'gruvbox' } }

-- LazyVim-style keymaps
local map = vim.keymap.set

-- Navigation & window management
map('n', '<leader>wq', '<cmd>wq<cr>',   { desc = "Save & Quit" })
map('n', '<leader>ww', '<C-W>w',        { desc = "Other Window" })
map('n', '<leader>wd', '<C-W>c',        { desc = "Delete Window" })
map('n', '<leader>w-', '<C-W>s',        { desc = "Split Window Below" })
map('n', '<leader>w|', '<C-W>v',        { desc = "Split Window Right" })

-- File/Buffer/Telescope
local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
map('n', '<leader>fg', builtin.live_grep,  { desc = "Live Grep" })
map('n', '<leader>fb', builtin.buffers,    { desc = "Buffers" })
map('n', '<leader>fh', builtin.help_tags,  { desc = "Help Tags" })

-- Neo-tree mappings
map('n', '<leader>fe', '<cmd>Neotree toggle<cr>', { desc = 'File Explorer (Neo-tree)' })
map('n', '<leader>e', '<leader>fe', { remap = true, desc = 'File Explorer (Neo-tree)' })

-- LSP/Diagnostics
map('n', '<leader>e', vim.diagnostic.open_float, { desc = "Diagnostics Float" })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Diagnostics List" })
map('n', '[d',        vim.diagnostic.goto_prev,  { desc = "Previous Diagnostic" })
map('n', ']d',        vim.diagnostic.goto_next,  { desc = "Next Diagnostic" })

-- Trouble
map('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { desc = "Trouble Toggle" })

-- Buffers/Tabs
map('n', '<leader>bb', '<cmd>enew<cr>',          { desc = "New Buffer" })
map('n', '<leader>bd', '<cmd>bd<cr>',            { desc = "Delete Buffer" })
map('n', '<leader>tn', '<cmd>tabnext<cr>',       { desc = "Tab Next" })
map('n', '<leader>tp', '<cmd>tabprev<cr>',       { desc = "Tab Previous" })
map('n', '<leader>tt', '<cmd>tabnew<cr>',        { desc = "Tab New" })
map('n', '<A-tab>',    '<cmd>tabnext<cr>',       { desc = "Tab Next (Alt-Tab)" })

-- Spell / whitespace / common
map('n', '<leader>us', ':set spell!<CR>',        { desc = "Toggle Spellcheck" })
map('n', '<leader>tr', ':StripWhitespace<CR>',   { desc = "Trim Whitespace" })
map('n', '<leader>wh', ':ToggleWhitespace<CR>',  { desc = "Toggle Whitespace Highlight" })

-- Misc search/highlight
map('n', '<leader>no', ':nohlsearch<CR>',        { desc = "Clear Search Highlight" })

-- Which-key setup
require("which-key").setup{}

