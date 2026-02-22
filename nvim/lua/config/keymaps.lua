-- Keymaps configuration
-- Inspired by VS Code Vim extension settings

local map = vim.keymap.set

-- ============================================================================
-- Insert Mode
-- ============================================================================

-- Exit insert mode with jk
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Emacs-style navigation in insert mode
-- map('i', '<C-b>', '<Left>', { desc = 'Move cursor left' })
-- map('i', '<C-f>', '<Right>', { desc = 'Move cursor right' })
-- map('i', '<C-p>', '<Up>', { desc = 'Move cursor up' })
-- map('i', '<C-n>', '<Down>', { desc = 'Move cursor down' })
-- map('i', '<C-d>', '<Del>', { desc = 'Delete character right' })

-- ============================================================================
-- Normal Mode
-- ============================================================================

-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Buffer navigation with Shift+H/L
-- map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
-- map('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })

-- Window navigation with Ctrl+hjkl
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Diagnostic quickfix list
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Redo
map("n", "U", "<C-r>", { desc = "Redo" })

-- ============================================================================
-- Visual Mode
-- ============================================================================

-- Stay in visual mode while indenting
-- map('v', '<', '<gv', { desc = 'Outdent and reselect' })
-- map('v', '>', '>gv', { desc = 'Indent and reselect' })

-- Move selected lines up/down while staying in visual mode
-- map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
-- map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Buffer navigation in visual mode
-- map('v', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
-- map('v', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })

-- ============================================================================
-- Terminal Mode
-- ============================================================================

-- Exit terminal mode with double Escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
