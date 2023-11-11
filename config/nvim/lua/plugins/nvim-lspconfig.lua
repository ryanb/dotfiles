local function configure()
    vim.cmd.packadd({ "nvim-lspconfig", bang = true }) -- https://github.com/neovim/nvim-lspconfig
    vim.cmd.packadd({ "cmp-nvim-lsp", bang = true }) -- https://github.com/sar/cmp-lsp.nvim

    local lsp = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- I need to figure out how to make these behave on a per-project basis.
    -- This might help: https://github.com/tamago324/nlsp-settings.nvim

    lsp.lua_ls.setup({ capabilities = cmp_nvim_lsp.default_capabilities() })

    lsp.ruby_ls.setup({
        cmd = { "bundle", "exec", "ruby-lsp" },
    })

    -- lsp.sorbet.setup({
    --     cmd = { "bundle", "exec",  "srb", "tc", "--lsp" }
    -- })

    lsp.tsserver.setup({
        cmd = { "npx", "typescript-language-server", "--stdio" },
        capabilities = cmp_nvim_lsp.default_capabilities(),
    })

    -- For other language servers see:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

    local function map_lsp_keys(args)
        local telescope_builtin = require("telescope.builtin")

        local buffer = args.buf

        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "code actions" })
        vim.keymap.set("n", "<leader>cd", telescope_builtin.diagnostics, { buffer = buffer, desc = "diagnostics" })
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "rename" })
        vim.keymap.set(
            "n",
            "<leader>cs",
            telescope_builtin.lsp_document_symbols,
            { buffer = buffer, desc = "document symbols" }
        )

        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buffer })
    end

    local group = vim.api.nvim_create_augroup("lspKeyBindings", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", { group = group, callback = map_lsp_keys })
end

return { configure = configure }
