-- My favourite colorscheme, with some tweaks
--
-- https://github.com/nanotech/jellybeans.vim

local function config()
    -- The completion highlights below are taken from:
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu

    vim.g.jellybeans_overrides = {
        background = { guibg = "none" },
        CmpItemAbbrDeprecated = { guibg = "none", strikethrough = true, guifg = "808080" },
        CmpItemAbbrMatch = { guibg = "none", guifg = "569cd6" },
        CmpItemAbbrMatchFuzzy = { link = "CmpIntemAbbrMatch" },
        CmpItemMenu = { guibg = "none", guifg = "aaaaaa" },
        CmpItemKindVariable = { guibg = "none", guifg = "9cdcfe" },
        CmpItemKindInterface = { link = "CmpItemKindVariable" },
        CmpItemKindText = { link = "CmpItemKindVariable" },
        CmpItemKindFunction = { guibg = "none", guifg = "c586c0" },
        CmpItemKindMethod = { link = "CmpItemKindFunction" },
        CmpItemKindKeyword = { guibg = "none", guifg = "d4d4d4" },
        CmpItemKindProperty = { link = "CmpItemKindKeyword" },
        CmpItemKindUnit = { link = "CmpItemKindKeyword" },
        DiagnosticError = { guifg = "ff6666" },
        DiffDelete = { guifg = "d2ebbe" },
        GitSignsAdd = { guifg = "99bc80" },
        GitSignsChange = { guifg = "68aee8" },
        GitSignsDelete = { guifg = "e16d77" },
        NormalFloat = { guibg = "333333" },
        NotifyBackground = { guibg = "000000" },
        SignColumn = { guibg = "none" },
        StatusLine = { guibg = "30302c" },
        StatusLineNC = { guibg = "30302c" },
        WinSeparator = { guifg = "30302c" },
    }
end

return {
    "nanotech/jellybeans.vim",
    config = config,
    dependencies = { "rktjmp/lush.nvim" },
    enabled = false,
    lazy = false,
    priority = 1000,
}
