local packadd = require("helpers").packadd
local bind = require("helpers").bind

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

    local function bind_lsp_keys(args)
        local telescope_builtin = require("telescope.builtin")

        local buffer = args.buf

        bind("n", "<leader>ca", vim.lsp.buf.code_action, {buffer = buffer, desc = "code actions"})
        bind("n", "<leader>cd", telescope_builtin.diagnostics, {buffer = buffer, desc = "diagnostics"})
        bind("n", "<leader>cr", vim.lsp.buf.rename, {buffer = buffer, desc = "rename"})
        bind("n", "<leader>cs", telescope_builtin.lsp_document_symbols, {buffer = buffer, desc = "document symbols"})

        bind("n", "K", vim.lsp.buf.hover, {buffer = buffer})
        bind("n", "gd", vim.lsp.buf.definition, {buffer = buffer})
        bind("n", "gr", vim.lsp.buf.references, {buffer = buffer})
    end

    vim.api.nvim_create_augroup("lspKeyBindings", {clear = true})
    vim.api.nvim_create_autocmd("LspAttach", {group = "lspKeyBindings", callback = bind_lsp_keys})
end

return {configure = configure}
