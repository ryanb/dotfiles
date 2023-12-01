local bufdelete = require("bufdelete")
local gitsigns = require("gitsigns")
local telescope_builtin = require("telescope.builtin")
local helpers = require("helpers")

local map = vim.keymap.set

local function map_global_keys()
    -- Reselect the visual area when changing indenting in visual mode.
    map("v", "<", "<gv")
    map("v", ">", ">gv")

    -- Navigate between windows.
    map("n", "<c-h>", "<c-w>h")
    map("n", "<c-j>", "<c-w>j")
    map("n", "<c-k>", "<c-w>k")
    map("n", "<c-l>", "<c-w>l")

    -- Move around in the buffer.
    map("n", "[d", vim.diagnostic.goto_prev, { desc = "previous diagnostic in buffer" })
    map("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic in buffer" })
    map("n", "[g", gitsigns.prev_hunk, { desc = "previous git hunk in buffer" })
    map("n", "]g", gitsigns.next_hunk, { desc = "next git hunk in buffer" })
    map("n", "[q", vim.cmd.cbefore, { desc = "previous quickfix error in buffer" })
    map("n", "]q", vim.cmd.cafter, { desc = "next quickfix error in buffer" })

    -- Leader + single key stuff.
    map("n", "<leader><leader>", telescope_builtin.find_files, { desc = "find files" })
    map("n", "<leader>.", telescope_builtin.resume, { desc = "resume last find" })
    map("n", "<leader>/", telescope_builtin.live_grep, { desc = "find in project" })
    map("n", "<leader>b", helpers.explore_buffers, { desc = "explore buffers" })
    map("n", "<leader>d", vim.diagnostic.open_float, { desc = "show diagnostics under cursor" })
    map("n", "<leader>e", helpers.explore_files, { desc = "explore files" })
    map("n", "<leader>g", helpers.explore_git_status, { desc = "explore git status" })
    map("n", "<leader>q", helpers.write_all_and_quit, { desc = "write all files and quit" })
    map("n", "<leader>x", bufdelete.bufdelete, { desc = "close current buffer" })

    -- Restart things.
    map("n", "<leader>re", helpers.restart_eslint, { desc = "restart eslint" })
    map("n", "<leader>rl", vim.cmd.LspRestart, { desc = "restart LSP" })

    -- Run tests.
    map("n", "<leader>t.", helpers.test_last, { desc = "repeat the last test run" })
    map("n", "<leader>tf", helpers.test_file, { desc = "run tests in current file" })
    map("n", "<leader>tn", helpers.test_nearest, { desc = "run nearest test" })
end

-- These mappings only apply when a buffer has a language server attached.
local function map_lsp_keys(args)
    local buffer = args.buf

    map("n", "<leader>c/", telescope_builtin.lsp_document_symbols, { buffer = buffer, desc = "document symbols" })
    map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code actions" })
    map("n", "<leader>cd", telescope_builtin.diagnostics, { buffer = buffer, desc = "search diagnostics" })
    map("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "rename symbol under cursor" })

    map("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "show info about symbol under cursor" })
    map("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "go to defintion" })
    map("n", "gr", telescope_builtin.lsp_references, { buffer = buffer, desc = "go to references" })
end

local function configure()
    map_global_keys()

    local group = vim.api.nvim_create_augroup("lspKeyBindings", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", { group = group, callback = map_lsp_keys })
end

return { configure = configure }
