local bufdelete = require("bufdelete")
-- local neotest = require("neotest")
local neo_tree_command = require("neo-tree.command")
local telescope_builtin = require("telescope.builtin")

local function explore_files()
    neo_tree_command.execute({ reveal_file = vim.fn.expand("%:p"), toggle = true })
end

-- local function run_tests_for_current_buffer()
--     neotest.run.run(vim.fn.expand("%"))
-- end

local function write_all_and_quit()
    vim.cmd("confirm xall")
end

local function configure()
    -- Shortcuts for navigation between windows
    vim.keymap.set("n", "<c-h>", "<c-w>h")
    vim.keymap.set("n", "<c-j>", "<c-w>j")
    vim.keymap.set("n", "<c-k>", "<c-w>k")
    vim.keymap.set("n", "<c-l>", "<c-w>l")

    -- Reselect the visual area when changing indenting in visual mode.
    vim.keymap.set("v", "<", "<gv")
    vim.keymap.set("v", ">", ">gv")

    -- Move through the quickfix list.
    vim.keymap.set("n", "[q", vim.cmd.cbefore, { desc = "previous quickfix error in buffer" })
    vim.keymap.set("n", "]q", vim.cmd.cafter, { desc = "next quickfix error in buffer" })

    -- We do this often enought that we want it fast.
    vim.keymap.set("n", "<leader><leader>", telescope_builtin.find_files, { desc = "find files" })

    -- Leader + single key stuff:
    vim.keymap.set("n", "<leader>b", telescope_builtin.buffers, { desc = "find buffers" })
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "show diagnostics under cursor" })
    vim.keymap.set("n", "<leader>e", explore_files, { desc = "explore files" })
    vim.keymap.set("n", "<leader>q", write_all_and_quit, { desc = "write all files and quit" })
    vim.keymap.set("n", "<leader>s", telescope_builtin.live_grep, { desc = "search files" })
    vim.keymap.set("n", "<leader>x", bufdelete.bufdelete, { desc = "close current buffer" })

    local function map_lsp_keys(args)
        local buffer = args.buf

        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code actions" })
        vim.keymap.set(
            "n",
            "<leader>cd",
            telescope_builtin.diagnostics,
            { buffer = buffer, desc = "search diagnostics" }
        )
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "rename symbol under cursor" })
        vim.keymap.set(
            "n",
            "<leader>cs",
            telescope_builtin.lsp_document_symbols,
            { buffer = buffer, desc = "document symbols" }
        )

        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "show info about symbol under cursor" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "go to defintion" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buffer, desc = "go to references" })
    end

    local group = vim.api.nvim_create_augroup("lspKeyBindings", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", { group = group, callback = map_lsp_keys })

    -- Git:
    vim.keymap.set("n", "<leader>gs", telescope_builtin.git_status, { desc = "git status" })

    -- Running tests:
    vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "run tests in current file" })
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "run last test" })
    vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { desc = "run nearest test" })
    -- vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, { desc = "toggle test summary" })
    -- vim.keymap.set("n", "<leader>tb", run_tests_for_current_buffer, { desc = "run tests in current buffer" })
    -- vim.keymap.set("n", "<leader>tl", neotest.run.run_last, { desc = "run last test" })
    -- vim.keymap.set("n", "<leader>tn", neotest.run.run, { desc = "run nearest test" })
    -- vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, { desc = "toggle test summary" })
end

return { configure = configure }
