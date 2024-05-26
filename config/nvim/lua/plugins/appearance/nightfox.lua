local function config()
    local nightfox = require("nightfox")

    -- Set the diagnostic signs shown in the gutter to match lualine's.
    vim.fn.sign_define("DiagnosticSignError", { text = "󰅚 ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "󰀪 ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "󰋽 ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌶", texthl = "DiagnosticSignHint" })

    nightfox.setup({
        options = {
            module_default = false,
            modules = {
                diagnostic = { enabled = true, background = true },
                gitsigns = true,
                lazy = true,
                lsp_semantic_tokens = true,
                native_lsp = { enabled = true, background = true },
                neotree = true,
                telescope = true,
                treesitter = true,
                whichkey = true,
            },
            transparent = true,
        },
    })

    vim.cmd.colorscheme("nightfox")
end

return {
    "EdenEast/nightfox.nvim",
    config = config,
    lazy = false,
    priority = 1000,
}
