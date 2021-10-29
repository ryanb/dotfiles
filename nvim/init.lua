----------------------------------------------------------------------
-- Packages
--
local packer = require 'packer'
packer.startup(function()
  use 'wbthomason/packer.nvim'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'

  use 'neovim/nvim-lspconfig'

  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'

  use 'rktjmp/lush.nvim'
  use 'metalelf0/jellybeans-nvim'

  use 'kyazdani42/nvim-web-devicons'
end)


----------------------------------------------------------------------
-- Syntax highlighting
--
local treesitter = require('nvim-treesitter.configs')
treesitter.setup({
  ensure_installed = { 'lua', 'javascript', 'typescript', 'tsx' },
  highlight = { enable = true }
})


----------------------------------------------------------------------
-- Completion
--
local cmp = require 'cmp'
cmp.setup({
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }
  })
})

local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local client_capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_capabilities = cmp_nvim_lsp.update_capabilities(client_capabilities)


----------------------------------------------------------------------
-- Language server
--
local lsp = require 'lspconfig'

local on_attach = function(client, buffer_number)
  local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }
  nvim_buf_set_keymap(buffer_number, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  nvim_buf_set_keymap(buffer_number, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

lsp.tsserver.setup({
  capabilities = cmp_capabilities,
  on_attach = on_attach
})

lsp.solargraph.setup({
  capabilities = cmp_capabilities,
  on_attach = on_attach
})


----------------------------------------------------------------------
-- Dev icons to make Telescope better
--
require('nvim-web-devicons').setup({ default = true })


----------------------------------------------------------------------
-- Key bindings
--
vim.g.mapleader = ','

local nvim_set_keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

nvim_set_keymap('n', '<leader>f', '<cmd>Telescope find_files<CR>', opts)
nvim_set_keymap('n', '<leader>b', '<cmd>Telescope buffers<CR>', opts)
nvim_set_keymap('n', '<leader>a', '<cmd>Telescope lsp_code_actions<CR>', opts)


----------------------------------------------------------------------
-- General options
--
local opt = vim.opt
local cmd = vim.cmd

opt.termguicolors = true
cmd 'colorscheme jellybeans-nvim'

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.breakindent = true

opt.relativenumber = true

opt.mouse = 'a'

opt.hidden = true

opt.completeopt = {'menu', 'menuone', 'noselect'}
