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
opt.scrolloff = 2

opt.tildeop = true  -- make the ~ command behave like an operator

opt.showmatch = true  -- show matching brackets when typing

opt.mouse = 'a'


----------------------------------------------------------------------
-- Key bindings
--
local keymaps = require 'keymaps'

vim.g.mapleader = ','

keymaps.set({
  -- Shortcuts for navigation between windows
  ['<c-h>'] = { keys = '<c-w>h' },
  ['<c-j>'] = { keys = '<c-w>j' },
  ['<c-k>'] = { keys = '<c-w>k' },
  ['<c-l>'] = { keys = '<c-w>l' },

  -- Reselect the visual area when changing indenting in visual mode
  ['<'] = { mode = 'v', keys = '<gv' },
  ['>'] = { mode = 'v', keys = '>gv' },

  -- Leader mappings
  ['<leader>b'] = { cmd = 'Telescope buffers' },
  ['<leader>f'] = { cmd = 'Telescope find_files' },
  ['<leader>p'] = { cmd = 'Neoformat' },
  ['<leader>t'] = { cmd = 'NvimTreeToggle' },
})

-- These bindings are set when a language server attaches to a buffer
local function on_lsp_attach(client, buffer_number)
  keymaps.buf_set(buffer_number, {
    ['<leader>ca'] = { cmd = 'Telescope lsp_code_actions' },
    ['<leader>cd'] = { cmd = 'Telescope lsp_document_diagnostics' },
    ['<leader>cr'] = { cmd = 'lua vim.lsp.buf.rename()' },
    ['<leader>cs'] = { cmd = 'Telescope lsp_document_symbols' },
    ['K'] = { lua = 'vim.lsp.buf.hover()' },
    ['gd'] = { lua = 'vim.lsp.buf.definition()' },
    ['gr'] = { lua = 'vim.lsp.buf.references()' },
  })
  keymaps.buf_set(buffer_number, {
    ['<leader>ca'] = { cmd = 'Telescope lsp_range_code_actions', mode = 'v' }
  })
end


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
local cmp_capabilities = cmp_nvim_lsp.update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)


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
