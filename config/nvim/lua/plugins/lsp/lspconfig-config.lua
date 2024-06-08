return function()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    if os.getenv("DOTFILES_ENV") == "home" then
        lspconfig.bashls.setup({ capabilities = capabilities })
        lspconfig.eslint.setup({ capabilities = capabilities })
        lspconfig.solargraph.setup({ capabilities = capabilities })
        lspconfig.standardrb.setup({ capabilities = capabilities })
        lspconfig.tsserver.setup({ capabilities = capabilities })
    end

    if os.getenv("DOTFILES_ENV") == "work" then
        lspconfig.bashls.setup({ capabilities = capabilities })
        lspconfig.eslint.setup({ capabilities = capabilities })
        lspconfig.relay_lsp.setup({ capabilities = capabilities })
        lspconfig.rubocop.setup({ capabilities = capabilities })
        lspconfig.sorbet.setup({ capabilities = capabilities })
        lspconfig.tsserver.setup({ capabilities = capabilities })
    end

    -- Set the diagnostic signs shown in the gutter to match lualine's.
    vim.fn.sign_define("DiagnosticSignError", { text = "󰅚 ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "󰀪 ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "󰋽 ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌶", texthl = "DiagnosticSignHint" })

    -- Language servers can be configured on a per-project basis using exrc.
    -- See the .nvim.lua file in .dotfiles for an example.
end
