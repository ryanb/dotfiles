local execute = vim.api.nvim_command
local fn = vim.fn
local fmt = string.format

-- Set leader key early so plugins can use it
vim.g.mapleader = ","

vim.pack.add {
  'https://github.com/catppuccin/nvim',
  'https://github.com/benmills/vimux',
  'https://github.com/vim-test/vim-test',
  'https://github.com/stevearc/oil.nvim',
  {src = 'https://github.com/stevelounsbury/context-bridge.nvim', name = 'context-bridge'},
  'https://github.com/airblade/vim-gitgutter',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter'
}

-- require('packer').startup(function(use)
--   -- install all the plugins you need here
-- 
--   -- the plugin manager can manage itself
--   use {'wbthomason/packer.nvim'}
--   use {'ajmwagar/vim-deus'}
-- 
--   -- lsp config for elixir-ls support  
--   use {'williamboman/mason.nvim'}
-- 
--   use {
--     'nvim-telescope/telescope.nvim',
--     requires = { {'nvim-lua/plenary.nvim'} }
--   }
-- 
--   -- install different completion source
--   -- cmp framework for auto-completion support
--   use {'hrsh7th/nvim-cmp'}
--   use {'hrsh7th/cmp-nvim-lsp'}
--   use {'hrsh7th/cmp-buffer'}
--   use {'hrsh7th/cmp-path'}
--   use {'hrsh7th/cmp-cmdline'}
--   use {'hrsh7th/vim-vsnip'}
--   use {'hrsh7th/cmp-vsnip'}
-- 
--   -- treesitter for syntax highlighting and more
--   use {'nvim-treesitter/nvim-treesitter'}
-- 
--   use {'Mofiqul/dracula.nvim'}
--   use {'benmills/vimux'}
--   use {'vim-test/vim-test'}
-- 
--   use {'stevearc/oil.nvim'} 
-- 
--   use {
--     "ThePrimeagen/harpoon",
--     branch = "harpoon2",
--     requires = { {'nvim-lua/plenary.nvim'} }
--   }
--   use {'simrat39/symbols-outline.nvim'}
--   use { 'stevelounsbury/context-bridge.nvim' }
--   
--   -- Git gutter for showing git changes in the sign column
--   use {'airblade/vim-gitgutter'}
-- 
--   -- Trouble for better diagnostics UI
--   use {
--     'folke/trouble.nvim',
--     requires = { 'nvim-tree/nvim-web-devicons' },
--   }
-- 
--   use { 'kylechui/nvim-surround' }
-- end)

-- `on_attach` callback will be called after a language server
-- instance has been attached to an open buffer with matching filetype
-- here we're setting key mappings for hover documentation, goto definitions, goto references, etc
-- you may set those key mappings based on your own preference
vim.lsp.log.set_level('warn')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, opts)
    vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  end,
})

local function select_vimux_pane()
  os.execute('tmux display-panes')
  local pane_num = vim.fn.input('Select vimux runner pane: ')
  if pane_num == '' then return end

  local handle = io.popen('tmux list-panes -F "#{pane_index} #{pane_id}"')
  if handle then
    local result = handle:read("*a")
    handle:close()
    for line in result:gmatch("[^\r\n]+") do
      local index, pane_id = line:match("(%d+) (.+)")
      if index == pane_num then
        vim.g.VimuxRunnerIndex = pane_id
        vim.notify("Vimux runner: " .. pane_id)
        return
      end
    end
  end
  vim.notify("Invalid pane: " .. pane_num, vim.log.levels.WARN)
end
vim.api.nvim_create_user_command('VimuxSelectPane', select_vimux_pane, {})

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('expert', {
  cmd = { 'expert', '--stdio' },
  root_markers = { 'mix.exs', '.git' },
  filetypes = { 'elixir', 'heex' },
})
vim.lsp.enable 'expert'


vim.lsp.config['ts_ls'] = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'tsconfig.json', 'package.json', '.git' },
  init_options = {
    maxTsServerMemory = 16384,
  },
}
vim.lsp.enable('ts_ls')

-- require("mason").setup()
require("context-bridge").setup({
  keymaps = {
    -- Send (auto-submit)
    visual_send = '<leader>cc',
    line_send = '<leader>cl',
    file_send = '<leader>cb',   -- Changed from cf (conflicts with LSP formatting)
    text_send = '<leader>ct',
    -- Stage (no submit)
    visual_stage = '<leader>sc',
    line_stage = '<leader>sl',
    file_stage = '<leader>sb',
    text_stage = '<leader>st',
  }
})
-- require("nvim-surround").setup()

-- local cmp = require'cmp'
-- 
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       -- setting up snippet engine
--       -- this is for vsnip, if you're using other
--       -- snippet engine, please refer to the `nvim-cmp` guide
--       vim.fn["vsnip#anonymous"](args.body)
--     end,
--   },
--   mapping = {
--     ['<CR>'] = cmp.mapping.confirm({ select = true }),
--   },
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp' },
--     { name = 'vsnip' }, -- For vsnip users.
--     { name = 'buffer' }
--   })
-- })

local treesitter = require('nvim-treesitter')
treesitter.setup()
treesitter.install({ "lua", "elixir", "heex", "eex", "vim", "python", "vimdoc", "luadoc", "markdown", "typescript", "tsx", "javascript", "json", "css", "html", "prisma" })

-- Enable treesitter highlighting and indentation for all filetypes
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("oil").setup({
  view_options = {
    show_hidden = true,
  },
})

vim.g['test#strategy'] = "vimux"
-- vim.cmd [[let test#strategy = "vimux"]]
vim.cmd [[noremap <leader>r :wa<CR>:TestNearest<CR>]]
vim.cmd [[noremap <leader>R :wa<CR>:TestFile<CR>]]

-- Git gutter configuration
vim.g.gitgutter_enabled = 1
vim.g.gitgutter_sign_added = '+'
vim.g.gitgutter_sign_modified = '~'
vim.g.gitgutter_sign_removed = '-'
vim.g.gitgutter_sign_removed_first_line = '^'
vim.g.gitgutter_sign_modified_removed = '~-'
vim.g.gitgutter_max_signs = 500
vim.g.gitgutter_map_keys = 0  -- Disable default mappings

-- Git gutter keymaps
vim.keymap.set('n', '<leader>gp', '<cmd>GitGutterPreviewHunk<CR>', { desc = 'Preview git hunk' })
vim.keymap.set('n', '<leader>gs', '<cmd>GitGutterStageHunk<CR>', { desc = 'Stage git hunk' })
vim.keymap.set('n', '<leader>gu', '<cmd>GitGutterUndoHunk<CR>', { desc = 'Undo git hunk' })
vim.keymap.set('n', ']c', '<cmd>GitGutterNextHunk<CR>', { desc = 'Next git hunk' })
vim.keymap.set('n', '[c', '<cmd>GitGutterPrevHunk<CR>', { desc = 'Previous git hunk' })
-- Trouble setup for diagnostics
-- require('trouble').setup()
-- vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Toggle Trouble diagnostics' })

vim.keymap.set('n', '<leader>/', ':grep ""<Left>')
vim.keymap.set('n', ']q', ':cnext<CR>')
vim.keymap.set('n', '[q', ':cprev<CR>')
vim.cmd [[noremap <leader>K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR><CR>]]
vim.cmd [[colorscheme catppuccin]]
vim.cmd([[
  set number
  
  set tabstop=2
  set shiftwidth=2
  set expandtab
  set grepprg=rg\ --vimgrep\ --no-heading\ --hidden\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
]])
vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>Telescope find_files<CR>', { noremap=true, silent=true })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = '[^l]*',
  command = 'cwindow'
})

-- -- HARPOON SETUP --
-- local harpoon = require("harpoon")
-- -- REQUIRED
-- harpoon:setup()
-- -- REQUIRED
-- vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
-- vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
-- 
-- vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)
-- 
-- -- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
-- -- HARPOON SETUP --

