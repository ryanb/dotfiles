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

-- Use relative line numbering, but display the actual line
-- number on the current line, and highlight it.
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = 'number'

opt.scrolloff = 2

opt.tildeop = true  -- make the ~ command behave like an operator

opt.showmatch = true  -- show matching brackets when typing

opt.mouse = 'a'


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


----------------------------------------------------------------------
-- Telescope
--
packadd 'telescope.nvim'
-- We need this further down for some key bindings
local telescope = require 'telescope.builtin'


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
local lualine = require 'lualine'
lualine.setup({ options = { theme = 'auto' } })

opt.showmode = false  -- lualine shows the mode for us


----------------------------------------------------------------------
-- Syntax highlighting and text objects for functions
--
packadd 'nvim-treesitter'
packadd 'nvim-treesitter-textobjects'
local treesitter = require 'nvim-treesitter.configs'
treesitter.setup({
  ensure_installed = {
    'lua', 'javascript', 'typescript', 'tsx', 'css', 'scss', 'ruby'
  },
  highlight = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner"
      }
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { ["]m"] = "@function.outer" },
      goto_next_end = { ["]M"] = "@function.outer" },
      goto_previous_start = { ["[m"] = "@function.outer" },
      goto_previous_end = { ["[M"] = "@function.outer" },
    }
  }
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
packadd 'cmp-nvim-lsp'
packadd 'vim-vsnip' -- cmp doesn't work without a snippet plugin

opt.completeopt = { 'menu', 'menuone', 'noselect' }

local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  sources = {
    { name = 'nvim_lsp' }
  }
})

local cmp_nvim_lsp = require 'cmp_nvim_lsp'
-- This is used to set up LSP further down.
local cmp_capabilities = cmp_nvim_lsp.update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)


----------------------------------------------------------------------
-- File navigation
--
packadd 'nvim-tree.lua'
local nvim_tree = require 'nvim-tree'
nvim_tree.setup({
  open_on_setup = true,
  filters = { dotfiles = true },
  update_focused_file = { enable = true },
  view = { auto_resize = true }
})


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


----------------------------------------------------------------------
-- Key bindings
--
local keymap = vim.keymap

vim.g.mapleader = ','

-- Shortcuts for navigation between windows
keymap.set('n', '<c-h>', '<c-w>h')
keymap.set('n', '<c-j>', '<c-w>j')
keymap.set('n', '<c-k>', '<c-w>k')
keymap.set('n', '<c-l>', '<c-w>l')

-- Reselect the visual area when changing indenting in visual mode
keymap.set('v', '<', '<gv')
keymap.set('v', 'r', 'rgv')

-- Leader mappings
keymap.set('n', '<leader>b', function() telescope.buffers() end)
keymap.set('n', '<leader>f', function() telescope.find_files() end)
keymap.set('n', '<leader>p', '<cmd>Neoformat<cr>')
keymap.set('n', '<leader>t', function() nvim_tree.toggle() end)

-- These bindings are set when a language server attaches to a buffer
local function on_lsp_attach(client, buffer_number)
  keymap.set('n', '<leader>ca', function() telescope.lsp_code_actions() end, { buffer = buffer_number })
  keymap.set('v', '<leader>ca', function() telescope.lsp_range_code_actions() end, { buffer = buffer_number })
  keymap.set('n', '<leader>cd', function() telescope.diagnostics() end, { buffer = buffer_number })
  keymap.set('n', '<leader>cr', function() vim.lsp.buf.rename() end, { buffer = buffer_number })
  keymap.set('n', '<leader>cs', function() telescope.lsp_document_symbols() end, { buffer = buffer_number })

  keymap.set('n', 'K', function() vim.lsp.buf.hover() end, { buffer = buffer_number })
  keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, { buffer = buffer_number })
  keymap.set('n', 'gr', function() vim.lsp.buf.references() end, { buffer = buffer_number })
end


----------------------------------------------------------------------
-- Language server
--
packadd 'nvim-lspconfig'
local lsp = require 'lspconfig'

local lsp_opts = {
  on_attach = on_lsp_attach,
  capabilities = cmp_capabilities
}

lsp.tsserver.setup(lsp_opts)
lsp.solargraph.setup(lsp_opts)
