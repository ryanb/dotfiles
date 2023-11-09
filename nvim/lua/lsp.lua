local packadd = require("packadd")

return {
    configure = function()
        packadd("cmp-nvim-lsp") -- https://github.com/sar/cmp-lsp.nvim
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local lsp_opts = {
            capabilities = cmp_nvim_lsp.default_capabilities()
        }

        packadd("nvim-lspconfig") -- https://github.com/neovim/nvim-lspconfig
        local lsp = require("lspconfig")

        -- For other language servers see:
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        lsp.lua_ls.setup(lsp_opts)
        lsp.sorbet.setup(lsp_opts)
        lsp.tsserver.setup(lsp_opts)
    end
}
