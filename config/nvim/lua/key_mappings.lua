local bufdelete = require("bufdelete")
local neo_tree_command = require("neo-tree.command")
local telescope_builtin = require("telescope.builtin")
local gitsigns = require("gitsigns")

local function explore_files()
    neo_tree_command.execute({ action = "focus", source = "filesystem" })
end

local function explore_buffers()
    neo_tree_command.execute({ action = "focus", source = "buffers" })
end

local function write_all_and_quit()
    vim.cmd("confirm xall")
end

-- Set up all my key mappings.
local function configure()
    local keymap = vim.keymap

    -- Shortcuts for navigation between windows
    keymap.set("n", "<c-h>", "<c-w>h")
    keymap.set("n", "<c-j>", "<c-w>j")
    keymap.set("n", "<c-k>", "<c-w>k")
    keymap.set("n", "<c-l>", "<c-w>l")

    -- Reselect the visual area when changing indenting in visual mode.
    keymap.set("v", "<", "<gv")
    keymap.set("v", ">", ">gv")

    -- Move through the quickfix list.
    keymap.set("n", "[q", vim.cmd.cbefore, { desc = "previous quickfix error in buffer" })
    keymap.set("n", "]q", vim.cmd.cafter, { desc = "next quickfix error in buffer" })

    -- We do this often enought that we want it fast.
    vim.keymap.set("n", "<leader><leader>", telescope_builtin.find_files, { desc = "find files" })

    -- Leader + single key stuff:
    keymap.set("n", "<leader>b", explore_buffers, { desc = "find buffers" })
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "show diagnostics under cursor" })
    keymap.set("n", "<leader>e", explore_files, { desc = "explore files" })
    keymap.set("n", "<leader>q", write_all_and_quit, { desc = "write all files and quit" })
    keymap.set("n", "<leader>s", telescope_builtin.live_grep, { desc = "search files" })
    keymap.set("n", "<leader>x", bufdelete.bufdelete, { desc = "close current buffer" })

    local function map_lsp_keys(args)
        local buffer = args.buf

        keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code actions" })
        keymap.set("n", "<leader>cd", telescope_builtin.diagnostics, { buffer = buffer, desc = "search diagnostics" })
        keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "rename symbol under cursor" })
        keymap.set(
            "n",
            "<leader>cs",
            telescope_builtin.lsp_document_symbols,
            { buffer = buffer, desc = "document symbols" }
        )

        keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "show info about symbol under cursor" })
        keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "go to defintion" })
        keymap.set("n", "gr", telescope_builtin.lsp_references, { buffer = buffer, desc = "go to references" })

        -- Move through diagnostics.
        keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = buffer, desc = "previous diagnostic in buffer" })
        keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = buffer, desc = "next diagnostic in buffer" })
    end

    local group = vim.api.nvim_create_augroup("lspKeyBindings", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", { group = group, callback = map_lsp_keys })

    -- Git:
    keymap.set("n", "<leader>gs", telescope_builtin.git_status, { desc = "git status" })
    keymap.set("n", "[g", gitsigns.prev_hunk, { desc = "previous git hunk in buffer" })
    keymap.set("n", "]g", gitsigns.next_hunk, { desc = "next git hunk in buffer" })

    -- Running tests:
    keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "run tests in current file" })
    keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "run last test" })
    keymap.set("n", "<leader>tn", ":TestNearest<CR>", { desc = "run nearest test" })

    -- Window management:
    keymap.set("n", "<leader>wc", vim.cmd.close, { desc = "close the current window" })
end

return { configure = configure }
