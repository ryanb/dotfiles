-- https://github.com/nanotech/jellybeans.vim

local function config()
    vim.g.jellybeans_overrides = {
        background = { guibg = "none" },
        DiagnosticError = { guifg = "ff6666" },
        GitSignsAdd = { guifg = "99bc80" },
        GitSignsChange = { guifg = "68aee8" },
        GitSignsDelete = { guifg = "e16d77" },
        NormalFloat = { guibg = "333333" },
        SignColumn = { guibg = "none" },
        VertSplit = { guifg = "35373b", guibg = "35373b" },
    }

    vim.cmd.sign("define", "DiagnosticSignError", "text=", "texthl=DiagnosticSignError")
    vim.cmd.sign("define", "DiagnosticSignWarn", "text=󰀪", "texthl=DiagnosticSignWarn")
    vim.cmd.sign("define", "DiagnosticSignInfo", "text=i", "texthl=DiagnosticSignInfo")
    vim.cmd.sign("define", "DiagnosticSignHint", "text=󰍉", "texthl=DiagnosticSignHint")

    vim.cmd.colorscheme("jellybeans")
end

return {
    "nanotech/jellybeans.vim",
    config = config,
    lazy = false,
    priority = 1000,
}
