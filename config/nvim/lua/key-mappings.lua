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
-- An empty string sets the mapping for all these modes:
--
-- * Normal (n)
-- * Visual (x)
-- * Select (s)
-- * Operator (o)
--
-- Note that "v" means both visual (x) and select (s) modes.
--
-- See Neovim's help for map-modes

-- Most of my keys are mapped in normal, visual, and operator modes, but not
-- select mode. I don't want to map printable characters in select mode.
local nxo = { "n", "x", "o" }

-- Set up mappings available in all buffers.
local function map_global_keys()
    -- Things I do often enough get a top-level mapping.
    map(nxo, "<leader><leader>", telescope.find_files, { desc = "find files" })
    map(nxo, "<leader>*", telescope.grep_string, { desc = "find word under cursor" })
    map(nxo, "<leader>/", vim.cmd.nohlsearch, { desc = "clear search" })
    map(nxo, "<leader>d", vim.diagnostic.open_float, { desc = "show diagnostics under cursor" })
    map(nxo, "<leader>e", actions.toggle_neo_tree, { desc = "toggle neo-tree explorer" })
    map(nxo, "<leader>f", actions.show_current_file_in_neo_tree, { desc = "show current file in neo-tree" })
    map(nxo, "<leader>Q", actions.write_all_and_quit, { desc = "save all files and quit" })
    map(nxo, "<leader>R", actions.restore_session, { desc = "restore previoius session" })
    map(nxo, "<leader>s", actions.write_all, { desc = "save all files" })
    map(nxo, "<leader>S", actions.save_session_and_quit, { desc = "Save session" })
    map(nxo, "<leader>W", vim.cmd.close, { desc = "close window" })
    map(nxo, "<leader>X", bufdelete.bufdelete, { desc = "close buffer" })

    which_key.register({ ["<leader>c"] = { name = "code changes" } })
    map(nxo, "<leader>cj", treesj.join, { desc = "join lines" })
    map(nxo, "<leader>cf", refactoring.select_refactor, { desc = "refactor" })
    map(nxo, "<leader>cs", treesj.split, { desc = "split lines" })

    which_key.register({ ["<leader>g"] = { name = "git" } })
    map(nxo, "<leader>gb", gitsigns.blame_line, { desc = "git blame" })
    map(nxo, "<leader>gc", actions.choose_git_base, { desc = "change git base" })
    map(nxo, "<leader>gh", actions.browse_on_github, { desc = "browse on github" })
    map(nxo, "<leader>gp", gitsigns.preview_hunk_inline, { desc = "preview hunk" })

    which_key.register({ ["<leader>t"] = { name = "telescope" } })
    map(nxo, "<leader>t.", telescope.resume, { desc = "repeat last find" })
    map(nxo, "<leader>t/", telescope.live_grep, { desc = "live grep" })
    map(nxo, "<leader>tb", telescope.buffers, { desc = "find buffers" })
    map(nxo, "<leader>td", telescope.diagnostics, { desc = "find diagnostics" })
    map(nxo, "<leader>tg", telescope.git_status, { desc = "find git status" })
    map(nxo, "<leader>th", telescope.help_tags, { desc = "find help" })
    map(nxo, "<leader>tj", telescope.jumplist, { desc = "find in jumplist" })
    map(nxo, "<leader>tt", telescope.builtin, { desc = "find telescope builtins" })

    -- Make command keys do sensible things. There's some stuff in kitty.conf
    -- to tell Kitty to pass these through to Neovim.
    map("x", "<D-c>", '"*ygv', { desc = "copy to system clipboard" })
    map("", "<D-q>", actions.write_all_and_quit, { desc = "save all files and quit" })
    map("", "<D-s>", actions.write_all, { desc = "save all files" })
    map("", "<D-v>", '"*p', { desc = "paste from system clipboard" })
    map({ "c", "i", "s" }, "<D-v>", "<C-R>*", { desc = "paste from system clipboard" })
    map("", "<D-w>", vim.cmd.close, { desc = "close window" })
    map("v", "<D-x>", '"*d', { desc = "cut to system clipboard" })

    -- Jump between git changes in the buffer.
    map(nxo, "[g", gitsigns.prev_hunk, { desc = "previous git hunk in buffer" })
    map(nxo, "]g", gitsigns.next_hunk, { desc = "next git hunk in buffer" })

    -- Navigate between windows.
    map("", "<c-h>", "<c-w>h", { desc = "Go to the left window" })
    map("", "<c-j>", "<c-w>j", { desc = "Go to the down window" })
    map("", "<c-k>", "<c-w>k", { desc = "Go to the up window" })
    map("", "<c-l>", "<c-w>l", { desc = "Go to the right window" })

    -- Reselect the visual area when changing indenting in visual mode.
    map("x", "<", "<gv", { desc = "Indent left" })
    map("x", ">", ">gv", { desc = "Indent right" })
end

-- Set up mappings for buffers with a language server attached.
local function map_lsp_keys(args)
    local buffer = args.buf

    map(nxo, "gd", telescope.lsp_definitions, { buffer = buffer, desc = "Go to defintion" })
    map(nxo, "gr", telescope.lsp_references, { buffer = buffer, desc = "Go to references" })

    map(nxo, "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code actions" })
    map(nxo, "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "rename symbol under cursor" })

    map(nxo, "<leader>ts", telescope.lsp_document_symbols, { buffer = buffer, desc = "find document symbols" })
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
