----------------------------------------------------------------------
-- General options
--
local opt = vim.opt
local cmd = vim.cmd

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.breakindent = true
opt.linebreak = true

opt.relativenumber = true

opt.mouse = 'a'

opt.completeopt = { 'menu', 'menuone', 'noselect' }


----------------------------------------------------------------------
-- Key bindings
--
vim.g.mapleader = ','

local set_keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

set_keymap('n', '<leader>f', '<cmd>Telescope find_files<CR>', opts)
set_keymap('n', '<leader>b', '<cmd>Telescope buffers<CR>', opts)
set_keymap('n', '<leader>a', '<cmd>Telescope lsp_code_actions<CR>', opts)
set_keymap('n', '<leader>t', '<cmd>NvimTreeToggle<CR>', opts)

-- Reselect the visual area when changing indenting in visual mode.
set_keymap('v', '<', '<gv', opts)
set_keymap('v', '>', '>gv', opts)

-- Shortcuts for navigation between windows
set_keymap('n', '<c-h>', '<c-w>h', opts)
set_keymap('n', '<c-j>', '<c-w>j', opts)
set_keymap('n', '<c-k>', '<c-w>k', opts)
set_keymap('n', '<c-l>', '<c-w>l', opts)


----------------------------------------------------------------------
-- Fancy icons (for telescope, nvim-tree, and lualine)
--
local devicons = require 'nvim-web-devicons'
devicons.setup({ default = true })


----------------------------------------------------------------------
-- Syntax highlighting
--
local treesitter = require 'nvim-treesitter.configs'
treesitter.setup({
  ensure_installed = { 'lua', 'javascript', 'typescript', 'tsx', 'css', 'scss', 'ruby' },
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


----------------------------------------------------------------------
-- Language server
--
local lsp = require 'lspconfig'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'

-- This gets run when LSP attaches to a buffer.
local on_attach = function(client, buffer_number)
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }
  buf_set_keymap(buffer_number, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(buffer_number, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(buffer_number, 'n', 'K', "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
end

local client_capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_capabilities = cmp_nvim_lsp.update_capabilities(client_capabilities)

lsp.tsserver.setup({
  on_attach = on_attach,
  capabilities = cmp_capabilities
})

lsp.solargraph.setup({
  on_attach = on_attach,
  capabilities = cmp_capabilities
})


----------------------------------------------------------------------
-- File navigation
--
local nvim_tree = require 'nvim-tree'
nvim_tree.setup({ filters = { dotfiles = true } })


----------------------------------------------------------------------
-- Git diffs in the sign column
--
local gitsigns = require 'gitsigns'
gitsigns.setup()


----------------------------------------------------------------------
-- Colors
--
opt.termguicolors = true
cmd 'colorscheme jellybeans-nvim'


----------------------------------------------------------------------
-- Fancy status line
--
local lualine = require('lualine')
lualine.setup({ options = { theme = 'jellybeans' } })
