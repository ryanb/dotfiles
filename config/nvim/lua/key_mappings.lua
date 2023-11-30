local bufdelete = require("bufdelete")
local gitsigns = require("gitsigns")
local telescope_builtin = require("telescope.builtin")
local helpers = require("helpers")

local keymap = vim.keymap

-- These mappings only apply when a buffer has a language server attached.
local function map_lsp_keys(args)
    local buffer = args.buf

    keymap.set(
        "n",
        "<leader>c/",
        telescope_builtin.lsp_document_symbols,
        { buffer = buffer, desc = "document symbols" }
    )
    keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code actions" })
    keymap.set("n", "<leader>cd", telescope_builtin.diagnostics, { buffer = buffer, desc = "search diagnostics" })
    keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "rename symbol under cursor" })

    keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "show info about symbol under cursor" })
    keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "go to defintion" })
    keymap.set("n", "gr", telescope_builtin.lsp_references, { buffer = buffer, desc = "go to references" })
end

-- Set up all my key mappings.
local function configure()
    -- Reselect the visual area when changing indenting in visual mode.
    keymap.set("v", "<", "<gv")
    keymap.set("v", ">", ">gv")

    -- Navigate between windows.
    keymap.set("n", "<c-h>", "<c-w>h")
    keymap.set("n", "<c-j>", "<c-w>j")
    keymap.set("n", "<c-k>", "<c-w>k")
    keymap.set("n", "<c-l>", "<c-w>l")

    -- Move around in the buffer.
    keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "previous diagnostic in buffer" })
    keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic in buffer" })
    keymap.set("n", "[g", gitsigns.prev_hunk, { desc = "previous git hunk in buffer" })
    keymap.set("n", "]g", gitsigns.next_hunk, { desc = "next git hunk in buffer" })
    keymap.set("n", "[q", vim.cmd.cbefore, { desc = "previous quickfix error in buffer" })
    keymap.set("n", "]q", vim.cmd.cafter, { desc = "next quickfix error in buffer" })

    -- Leader + single key stuff.
    keymap.set("n", "<leader><leader>", telescope_builtin.find_files, { desc = "find files" })
    keymap.set("n", "<leader>.", telescope_builtin.resume, { desc = "resume last find" })
    keymap.set("n", "<leader>/", telescope_builtin.live_grep, { desc = "find in project" })
    keymap.set("n", "<leader>b", helpers.explore_buffers, { desc = "explore buffers" })
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "show diagnostics under cursor" })
    keymap.set("n", "<leader>e", helpers.explore_files, { desc = "explore files" })
    keymap.set("n", "<leader>g", helpers.explore_git_status, { desc = "explore git status" })
    keymap.set("n", "<leader>q", helpers.write_all_and_quit, { desc = "write all files and quit" })
    keymap.set("n", "<leader>x", bufdelete.bufdelete, { desc = "close current buffer" })

    -- Restart things.
    keymap.set("n", "<leader>re", helpers.restart_eslint, { desc = "restart eslint" })
    keymap.set("n", "<leader>rl", vim.cmd.LspRestart, { desc = "restart LSP" })

    -- Run tests.
    keymap.set("n", "<leader>t.", helpers.test_last, { desc = "repeat the last test run" })
    keymap.set("n", "<leader>tf", helpers.test_file, { desc = "run tests in current file" })
    keymap.set("n", "<leader>tn", helpers.test_nearest, { desc = "run nearest test" })

    -- Configure LSP mappings when a language server attaches to a buffer.
    local group = vim.api.nvim_create_augroup("lspKeyBindings", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", { group = group, callback = map_lsp_keys })
end

return { configure = configure }
