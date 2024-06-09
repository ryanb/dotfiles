local bufdelete = require("bufdelete")
local gitsigns = require("gitsigns")
local refactoring = require("refactoring")
local repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")
local telescope = require("telescope.builtin")
local treesj = require("treesj")
local which_key = require("which-key")
local actions = require("actions")

local map = vim.keymap.set

-- Set up mappings available in all buffers.
local function map_global_keys()
    -- Things I do often enough get a top-level mapping.
    map("", "<leader><leader>", telescope.find_files, { desc = "find files" })
    map("", "<leader>*", telescope.grep_string, { desc = "find word under cursor" })
    map("", "<leader>/", vim.cmd.nohlsearch, { desc = "clear search" })
    map("", "<leader>d", vim.diagnostic.open_float, { desc = "show diagnostics under cursor" })
    map("", "<leader>e", actions.toggle_neo_tree, { desc = "toggle neo-tree explorer" })
    map("", "<leader>f", actions.show_current_file_in_neo_tree, { desc = "show current file in neo-tree" })
    map("", "<leader>Q", actions.write_all_and_quit, { desc = "save all files and quit" })
    map("", "<leader>R", actions.restore_session, { desc = "restore previoius session" })
    map("", "<leader>s", actions.write_all, { desc = "save all files" })
    map("", "<leader>S", actions.save_session_and_quit, { desc = "Save session" })
    map("", "<leader>W", vim.cmd.close, { desc = "close window" })
    map("", "<leader>X", bufdelete.bufdelete, { desc = "close buffer" })

    -- Make command keys do sensible things.
    map("v", "<D-c>", '"*y', { desc = "copy to system clipboard" })
    map("", "<D-q>", actions.write_all_and_quit, { desc = "save all files and quit" })
    map("", "<D-s>", actions.write_all, { desc = "save all files" })
    map("", "<D-v>", '"*p', { desc = "paste from system clipboard" })
    map({ "c", "i" }, "<D-v>", "<C-R>*", { desc = "paste from system clipboard" })
    map("", "<D-w>", vim.cmd.close, { desc = "close window" })
    map("v", "<D-x>", '"*d', { desc = "cut to system clipboard" })

    which_key.register({ ["<leader>c"] = { name = "code changes" } })
    map("", "<leader>cj", treesj.join, { desc = "join lines" })
    map("", "<leader>cf", refactoring.select_refactor, { desc = "refactor" })
    map("", "<leader>cs", treesj.split, { desc = "split lines" })

    which_key.register({ ["<leader>g"] = { name = "git" } })
    map("", "<leader>gb", gitsigns.blame_line, { desc = "git blame" })
    map("", "<leader>gp", gitsigns.preview_hunk_inline, { desc = "preview hunk" })
    map("", "<leader>gc", actions.choose_git_base, { desc = "change git base" })

    which_key.register({ ["<leader>t"] = { name = "telescope" } })
    map("", "<leader>t.", telescope.resume, { desc = "repeat last find" })
    map("", "<leader>t/", telescope.live_grep, { desc = "live grep" })
    map("", "<leader>tb", telescope.buffers, { desc = "find buffers" })
    map("", "<leader>td", telescope.diagnostics, { desc = "find diagnostics" })
    map("", "<leader>tg", telescope.git_status, { desc = "find git status" })
    map("", "<leader>th", telescope.help_tags, { desc = "find help" })
    map("", "<leader>tj", telescope.jumplist, { desc = "find in jumplist" })
    map("", "<leader>tt", telescope.builtin, { desc = "find telescope builtins" })

    -- Move around in the buffer
    map({ "n", "x", "o" }, "[g", gitsigns.prev_hunk, { desc = "previous git hunk in buffer" })
    map({ "n", "x", "o" }, "]g", gitsigns.next_hunk, { desc = "next git hunk in buffer" })

    -- Make , and ; repeat the last move.
    map({ "n", "x", "o" }, ";", repeatable_move.repeat_last_move_next)
    map({ "n", "x", "o" }, ",", repeatable_move.repeat_last_move_previous)

    -- Make repeating the builtins work properly too.
    map({ "n", "x", "o" }, "f", repeatable_move.builtin_f)
    map({ "n", "x", "o" }, "F", repeatable_move.builtin_F)
    map({ "n", "x", "o" }, "t", repeatable_move.builtin_t)
    map({ "n", "x", "o" }, "T", repeatable_move.builtin_T)

    -- Navigate between windows
    map("", "<c-h>", "<c-w>h")
    map("", "<c-j>", "<c-w>j")
    map("", "<c-k>", "<c-w>k")
    map("", "<c-l>", "<c-w>l")

    -- Reselect the visual area when changing indenting in visual mode
    map("v", "<", "<gv")
    map("v", ">", ">gv")
end

-- Set up mappings for buffers with a language server attached.
local function map_lsp_keys(args)
    local buffer = args.buf

    map({ "n", "x", "o" }, "gd", telescope.lsp_definitions, { buffer = buffer, desc = "Go to defintion" })
    map({ "n", "x", "o" }, "gr", telescope.lsp_references, { buffer = buffer, desc = "Go to references" })

    map("", "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code actions" })
    map("", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "rename symbol under cursor" })

    map("", "<leader>td", telescope.diagnostics, { buffer = buffer, desc = "find diagnostics" })
    map("", "<leader>ts", telescope.lsp_document_symbols, { buffer = buffer, desc = "find document symbols" })
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
