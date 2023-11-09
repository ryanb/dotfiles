return {
    configure = function()
        vim.g.mapleader = ","

        local telescope_builtin = require("telescope.builtin")
        local nvim_tree_api = require("nvim-tree.api")

        local bind = vim.keymap.set

        -- Shortcuts for navigation between windows
        bind("n", "<c-h>", "<c-w>h")
        bind("n", "<c-j>", "<c-w>j")
        bind("n", "<c-k>", "<c-w>k")
        bind("n", "<c-l>", "<c-w>l")

        -- Reselect the visual area when changing indenting in visual mode.
        bind("v", "<", "<gv")
        bind("v", ">", ">gv")

        -- Leader mappings
        bind("n", "<leader>b", telescope_builtin.buffers)
        bind("n", "<leader>f", telescope_builtin.find_files)
        bind("n", "<leader>p", "<cmd>Neoformat<cr>")
        bind("n", "<leader>t", nvim_tree_api.tree.toggle)

        vim.api.nvim_create_autocmd(
            "LspAttach",
            {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(args)
                    local buffer_number = args.buf

                    bind("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer_number })
                    bind("n", "<leader>cd", telescope_builtin.diagnostics, { buffer = buffer_number })
                    bind("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer_number })
                    bind("n", "<leader>cs", telescope_builtin.lsp_document_symbols, { buffer = buffer_number })

                    bind("n", "K", vim.lsp.buf.hover, { buffer = buffer_number })
                    bind("n", "gd", vim.lsp.buf.definition, { buffer = buffer_number })
                    bind("n", "gr", vim.lsp.buf.references, { buffer = buffer_number })
                end
            }
        )
    end
}
