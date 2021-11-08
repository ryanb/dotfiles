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

opt.hidden = true

opt.relativenumber = true

opt.showmatch = true  -- show matching brackets when typing

opt.mouse = 'a'


----------------------------------------------------------------------
-- Key bindings
--
vim.g.mapleader = ','

local set_keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

-- Reselect the visual area when changing indenting in visual mode
set_keymap('v', '<', '<gv', opts)
set_keymap('v', '>', '>gv', opts)

-- Shortcuts for navigation between windows
set_keymap('n', '<c-h>', '<c-w>h', opts)
set_keymap('n', '<c-j>', '<c-w>j', opts)
set_keymap('n', '<c-k>', '<c-w>k', opts)
set_keymap('n', '<c-l>', '<c-w>l', opts)

-- Leader mappings
set_keymap('n', '<leader>a', '<cmd>Telescope lsp_code_actions<CR>', opts)
set_keymap('n', '<leader>b', '<cmd>Telescope buffers<CR>', opts)
set_keymap('n', '<leader>d', '<cmd>Telescope lsp_document_diagnostics<CR>', opts)
set_keymap('n', '<leader>f', '<cmd>Telescope find_files<CR>', opts)
set_keymap('n', '<leader>h', '<cmd>Telescope git_bcommits<CR>', opts)
set_keymap('n', '<leader>p', '<cmd>Neoformat<CR>', opts)
set_keymap('n', '<leader>r', "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
set_keymap('n', '<leader>s', '<cmd>Telescope lsp_document_symbols<CR>', opts)
set_keymap('n', '<leader>t', '<cmd>NvimTreeToggle<CR>', opts)


----------------------------------------------------------------------
-- Remove whitespace at the end of lines on save
--
cmd [[
augroup vimrcCommands
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup END
]]


----------------------------------------------------------------------
-- Random packages
--
function packadd(package)
  cmd('packadd! '..package)
end

packadd 'plenary.nvim'
packadd 'vim-commentary'
packadd 'telescope.nvim'


----------------------------------------------------------------------
-- Colors
--
opt.termguicolors = true
packadd 'lush.nvim'
packadd 'jellybeans-nvim'
cmd 'colorscheme jellybeans-nvim'


----------------------------------------------------------------------
-- Fancy icons (for telescope, nvim-tree, and lualine)
--
packadd 'nvim-web-devicons'
local devicons = require 'nvim-web-devicons'
devicons.setup({ default = true })


----------------------------------------------------------------------
-- Fancy status line
--
packadd 'lualine.nvim'
local lualine = require('lualine')
lualine.setup({ options = { theme = 'jellybeans' } })

opt.showmode = false  -- lualine shows the mode for us


----------------------------------------------------------------------
-- Syntax highlighting
--
packadd 'nvim-treesitter'
local treesitter = require 'nvim-treesitter.configs'
treesitter.setup({
  ensure_installed = {
    'lua', 'javascript', 'typescript', 'tsx', 'css', 'scss', 'ruby'
  },
  highlight = { enable = true }
})


----------------------------------------------------------------------
-- Auto-close brackets and tags and stuff
--
packadd 'nvim-autopairs'
local autopairs = require 'nvim-autopairs'
autopairs.setup{}

packadd 'nvim-ts-autotag'
local autotag = require 'nvim-ts-autotag'
autotag.setup()


----------------------------------------------------------------------
-- Completion
--
packadd 'nvim-cmp'
packadd 'vim-vsnip' -- cmp doesn't work without a snipper plugin
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }
  })
})

opt.completeopt = { 'menu', 'menuone', 'noselect' }


----------------------------------------------------------------------
-- Language server
--
packadd 'nvim-lspconfig'
packadd 'cmp-nvim-lsp'
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
packadd 'nvim-tree.lua'
local nvim_tree = require 'nvim-tree'
nvim_tree.setup({ filters = { dotfiles = true } })


----------------------------------------------------------------------
-- Automatic formatting
--
packadd 'neoformat'
vim.g.neoformat_try_node_exe = true


----------------------------------------------------------------------
-- Git diffs in the sign column
--
packadd 'gitsigns.nvim'
local gitsigns = require 'gitsigns'
gitsigns.setup()
