-- My favourite colorscheme, with some tweaks
--
-- https://github.com/nanotech/jellybeans.vim

local function config()
    vim.g.jellybeans_overrides = {
        background = { guibg = "none" },
        DiagnosticError = { guifg = "ff6666" },
        DiffDelete = { guifg = "d2ebbe" },
        GitSignsAdd = { guifg = "99bc80" },
        GitSignsChange = { guifg = "68aee8" },
        GitSignsDelete = { guifg = "e16d77" },
        NormalFloat = { guibg = "333333" },
        SignColumn = { guibg = "none" },
        WinSeparator = { guifg = "2f2f2b" },
    }

    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

    vim.cmd.colorscheme("jellybeans")
end

return {
    "nanotech/jellybeans.vim",
    config = config,
    lazy = false,
    priority = 1000,
}
