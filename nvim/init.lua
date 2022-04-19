----------------------------------------------------------------------
-- General options
--
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.linebreak = true

-- Use relative line numbering, but display the actual line
-- number on the current line, and highlight it.
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

vim.opt.scrolloff = 2

vim.opt.tildeop = true  -- make the ~ command behave like an operator

vim.opt.showmatch = true  -- show matching brackets when typing

vim.opt.mouse = 'a'


----------------------------------------------------------------------
-- Remove whitespace at the end of lines on save
--
vim.cmd [[
augroup vimrcCommands
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup END
]]


----------------------------------------------------------------------
-- Random packages
--
function packadd(package)
  vim.cmd('packadd! '..package)
end

packadd('plenary.nvim')
packadd('vim-commentary')


----------------------------------------------------------------------
-- Telescope
--
packadd('telescope.nvim')
-- We need this further down for some key bindings
local telescope = require('telescope.builtin')


----------------------------------------------------------------------
-- Colors
--
vim.opt.termguicolors = true
packadd('lush.nvim')
packadd('jellybeans-nvim')
vim.cmd('colorscheme jellybeans-nvim')


----------------------------------------------------------------------
-- Fancy icons (for telescope, nvim-tree, and lualine)
--
packadd('nvim-web-devicons')
local devicons = require('nvim-web-devicons')
devicons.setup({ default = true })


----------------------------------------------------------------------
-- Fancy status line
--
packadd('lualine.nvim')
local lualine = require('lualine')
lualine.setup({ options = { theme = 'auto' } })

vim.opt.showmode = false  -- lualine shows the mode for us


----------------------------------------------------------------------
-- Syntax highlighting and text objects for functions
--
packadd('nvim-treesitter')
packadd('nvim-treesitter-textobjects')
local treesitter = require('nvim-treesitter.configs')
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
packadd('nvim-autopairs')
local autopairs = require('nvim-autopairs')
autopairs.setup{}

packadd('nvim-ts-autotag')
local autotag = require('nvim-ts-autotag')
autotag.setup()


----------------------------------------------------------------------
-- Completion
--
packadd('nvim-cmp')
packadd('cmp-nvim-lsp')
packadd('vim-vsnip') -- cmp doesn't work without a snippet plugin

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local cmp = require('cmp')
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

local cmp_nvim_lsp = require('cmp_nvim_lsp')
-- This is used to set up LSP further down.
local cmp_capabilities = cmp_nvim_lsp.update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)


----------------------------------------------------------------------
-- File navigation
--
packadd('nvim-tree.lua')
local nvim_tree = require('nvim-tree')
nvim_tree.setup({
  open_on_setup = true,
  filters = { dotfiles = true },
  update_focused_file = { enable = true },
  view = { auto_resize = true }
})


----------------------------------------------------------------------
-- Automatic formatting
--
packadd('neoformat')
vim.g.neoformat_try_node_exe = true


----------------------------------------------------------------------
-- Git diffs in the sign column
--
packadd('gitsigns.nvim')
local gitsigns = require('gitsigns')
gitsigns.setup()


----------------------------------------------------------------------
-- Key bindings
--
local bind = vim.keymap.set

vim.g.mapleader = ','

-- Shortcuts for navigation between windows
bind('n', '<c-h>', '<c-w>h')
bind('n', '<c-j>', '<c-w>j')
bind('n', '<c-k>', '<c-w>k')
bind('n', '<c-l>', '<c-w>l')

-- Reselect the visual area when changing indenting in visual mode
bind('v', '<', '<gv')
bind('v', '>', '>gv')

-- Leader mappings
bind('n', '<leader>b', telescope.buffers)
bind('n', '<leader>f', telescope.find_files)
bind('n', '<leader>p', '<cmd>Neoformat<cr>')
bind('n', '<leader>t', nvim_tree.toggle)

-- These bindings are set when a language server attaches to a buffer
local function on_lsp_attach(client, buffer_number)
  bind('n', '<leader>ca', telescope.lsp_code_actions, { buffer = buffer_number })
  bind('v', '<leader>ca', telescope.lsp_range_code_actions, { buffer = buffer_number })
  bind('n', '<leader>cd', telescope.diagnostics, { buffer = buffer_number })
  bind('n', '<leader>cr', vim.lsp.buf.rename, { buffer = buffer_number })
  bind('n', '<leader>cs', telescope.lsp_document_symbols, { buffer = buffer_number })

  bind('n', 'K', vim.lsp.buf.hover, { buffer = buffer_number })
  bind('n', 'gd', vim.lsp.buf.definition, { buffer = buffer_number })
  bind('n', 'gr', vim.lsp.buf.references, { buffer = buffer_number })
end


----------------------------------------------------------------------
-- Language server
--
packadd('nvim-lspconfig')
local lsp = require('lspconfig')

local lsp_opts = {
  on_attach = on_lsp_attach,
  capabilities = cmp_capabilities
}

lsp.tsserver.setup(lsp_opts)
lsp.solargraph.setup(lsp_opts)
