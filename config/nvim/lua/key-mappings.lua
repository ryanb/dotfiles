local actions = require("actions")
local bufdelete = require("bufdelete")
local gitsigns = require("gitsigns")
local refactoring = require("refactoring")
local telescope = require("telescope.builtin")
local treesj = require("treesj")
local which_key = require("which-key")

-- We're going to be calling this function a lot, so let's not repeat
-- vim.keymap.set(...) every time.
local map = vim.keymap.set

-- The first parameter to map is the modes in which the mappings apply.
--
-- Neovim's modes are:
--   n = Normal mode
--   i = Insert mode
--   c = Command mode, typing a command after hitting ":"
--   x = Visual mode, when text is selected
--   s = Select mode, text is selected and will be replaced with typing
--   o = Operator-pending mode, waiting for an operator after d, y, c, etc.
--   t = Terminal mode, inside a terminal
--   l = Lang-arg mode, used for language mappings
--
-- "v" is a shortcut for both visual (x) and select (s) modes.
--
-- An empty string means normal (n), visual (x), select (s), and
-- operator-pending (o) modes.
--
-- See Neovim's help for map-modes

-- Most of my keys are mapped in normal and visual modes.
local nx = { "n", "x" }

-- Some of my command keys I want to have work just about everywhere.
local everywhere = { "n", "i", "c", "x", "s", "o", "t" }

-- Set up mappings available in all buffers.
local function map_global_keys()
    -- Things I do often enough get a top-level mapping.
    map(nx, "<leader><leader>", telescope.find_files, { desc = "find files" })
    map(nx, "<leader>*", telescope.grep_string, { desc = "find word under cursor" })
    map(nx, "<leader>/", vim.cmd.nohlsearch, { desc = "clear search" })
    map(nx, "<leader>d", vim.diagnostic.open_float, { desc = "show diagnostics under cursor" })
    map(nx, "<leader>e", actions.toggle_neo_tree, { desc = "toggle neo-tree explorer" })
    map(nx, "<leader>f", actions.show_current_file_in_neo_tree, { desc = "show current file in neo-tree" })
    map(nx, "<leader>Q", actions.write_all_and_quit, { desc = "save all files and quit" })
    map(nx, "<leader>R", actions.restore_session, { desc = "restore previoius session" })
    map(nx, "<leader>s", actions.write_all, { desc = "save all files" })
    map(nx, "<leader>S", actions.save_session_and_quit, { desc = "Save session" })
    map(nx, "<leader>W", vim.cmd.close, { desc = "close window" })
    map(nx, "<leader>X", bufdelete.bufdelete, { desc = "close buffer" })

    which_key.register({ ["<leader>c"] = { name = "code changes" } })
    map(nx, "<leader>cj", treesj.join, { desc = "join lines" })
    map(nx, "<leader>cf", refactoring.select_refactor, { desc = "refactor" })
    map(nx, "<leader>cs", treesj.split, { desc = "split lines" })

    which_key.register({ ["<leader>g"] = { name = "git" } })
    map(nx, "<leader>gb", gitsigns.blame_line, { desc = "git blame" })
    map(nx, "<leader>gc", actions.choose_git_base, { desc = "change git base" })
    map(nx, "<leader>gh", actions.browse_on_github, { desc = "browse on github" })
    map(nx, "<leader>gl", vim.cmd.LazyGit, { desc = "open LazyGit" })
    map(nx, "<leader>gp", gitsigns.preview_hunk_inline, { desc = "preview hunk" })

    which_key.register({ ["<leader>t"] = { name = "telescope" } })
    map(nx, "<leader>t.", telescope.resume, { desc = "repeat last find" })
    map(nx, "<leader>t/", telescope.live_grep, { desc = "live grep" })
    map(nx, "<leader>tb", telescope.buffers, { desc = "find buffers" })
    map(nx, "<leader>td", telescope.diagnostics, { desc = "find diagnostics" })
    map(nx, "<leader>tg", telescope.git_status, { desc = "find git status" })
    map(nx, "<leader>th", telescope.help_tags, { desc = "find help" })
    map(nx, "<leader>tj", telescope.jumplist, { desc = "find in jumplist" })
    map(nx, "<leader>tt", telescope.builtin, { desc = "find telescope builtins" })

    -- Make command keys do sensible things. There's some stuff in kitty.conf
    -- to tell Kitty to pass these through to Neovim.
    map("x", "<d-x>", '"*d', { desc = "cut to system clipboard" })
    map("x", "<d-c>", '"*ygv', { desc = "copy to system clipboard" })
    map(nx, "<d-v>", '"*p', { desc = "paste from system clipboard" })
    map("c", "<d-v>", "<c-R>*", { desc = "paste from system clipboard" })
    map(everywhere, "<d-s>", actions.write_all, { desc = "save all files" })
    map(everywhere, "<d-q>", actions.write_all_and_quit, { desc = "save all files and quit" })
    map(nx, "<d-w>", vim.cmd.close, { desc = "close window" })

    -- Jump between git changes in the buffer.
    map(nx, "[g", gitsigns.prev_hunk, { desc = "previous git hunk in buffer" })
    map(nx, "]g", gitsigns.next_hunk, { desc = "next git hunk in buffer" })

    -- Navigate between windows.
    map(nx, "<c-h>", "<c-w>h", { desc = "Go to the left window" })
    map(nx, "<c-j>", "<c-w>j", { desc = "Go to the down window" })
    map(nx, "<c-k>", "<c-w>k", { desc = "Go to the up window" })
    map(nx, "<c-l>", "<c-w>l", { desc = "Go to the right window" })

    -- Reselect the visual area when changing indenting in visual mode.
    map("x", "<", "<gv", { desc = "Indent left" })
    map("x", ">", ">gv", { desc = "Indent right" })
end

-- Set up mappings for buffers with a language server attached.
local function map_lsp_keys(args)
    local buffer = args.buf

    map("n", "gd", telescope.lsp_definitions, { buffer = buffer, desc = "Go to defintion" })
    map("n", "gr", telescope.lsp_references, { buffer = buffer, desc = "Go to references" })

    map(nx, "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code actions" })
    map(nx, "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "rename symbol under cursor" })

    map(nx, "<leader>ts", telescope.lsp_document_symbols, { buffer = buffer, desc = "find document symbols" })
end

-- This sets things up so we tell Kitty when Neovim is open, so it can pass
-- command keys through correctly.
local function let_kitty_know_about_editor()
    -- Code Taken from:
    -- https://sw.kovidgoyal.net/kitty/mapping/#conditional-mappings-depending-on-the-state-of-the-focused-window

    vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
        group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
        callback = function()
            io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
        end,
    })

    vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
        group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
        callback = function()
            io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
        end,
    })
end

-- Configure all the key mappings to my liking.
local function configure()
    map_global_keys()

    local group = vim.api.nvim_create_augroup("lspKeyBindings", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", { group = group, callback = map_lsp_keys })

    let_kitty_know_about_editor()
end

return { configure = configure }
