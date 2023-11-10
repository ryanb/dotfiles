local packadd = require("helpers").packadd

local function configure()
    packadd("nvim-lspconfig") -- https://github.com/neovim/nvim-lspconfig
    packadd("cmp-nvim-lsp") -- https://github.com/sar/cmp-lsp.nvim

    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Hook completion up to the language server.
    local lsp_opts = {
        capabilities = cmp_nvim_lsp.default_capabilities()
    }

    local lsp = require("lspconfig")

    -- For other language servers see:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    lsp.lua_ls.setup(lsp_opts)
    lsp.sorbet.setup(lsp_opts)
    lsp.tsserver.setup(lsp_opts)

    local function map_lsp_keys(args)
        local telescope_builtin = require("telescope.builtin")

        local buffer = args.buf

        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {buffer = buffer, desc = "code actions"})
        vim.keymap.set("n", "<leader>cd", telescope_builtin.diagnostics, {buffer = buffer, desc = "diagnostics"})
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {buffer = buffer, desc = "rename"})
        vim.keymap.set(
            "n",
            "<leader>cs",
            telescope_builtin.lsp_document_symbols,
            {buffer = buffer, desc = "document symbols"}
        )

        vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = buffer})
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = buffer})
        vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer = buffer})
    end

    local group = vim.api.nvim_create_augroup("lspKeyBindings", {clear = true})
    vim.api.nvim_create_autocmd("LspAttach", {group = group, callback = map_lsp_keys})
end

return {configure = configure}
