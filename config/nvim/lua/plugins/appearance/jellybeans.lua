-- https://github.com/nanotech/jellybeans.vim

local function config()
    -- Use the terminal's background instead of black.
    vim.g.jellybeans_overrides = {
        background = { guibg = "none" },
        DiagnosticError = { guifg = "ff6666" },
        NormalFloat = { guibg = "333333" },
        SignColumn = { guibg = "none" },
    }

    vim.cmd.colorscheme("jellybeans")

    -- While we're fixing diagnostic colours, let's give them some nice icons too.
    vim.cmd.sign("define", "DiagnosticSignError", "text=󰈸", "texthl=DiagnosticSignError")
    vim.cmd.sign("define", "DiagnosticSignWarn", "text=", "texthl=DiagnosticSignWarn")
    vim.cmd.sign("define", "DiagnosticSignInfo", "text=i", "texthl=DiagnosticSignInfo")
    vim.cmd.sign("define", "DiagnosticSignHint", "text=󰍉", "texthl=DiagnosticSignHint")
end

return { "nanotech/jellybeans.vim", config = config, lazy = false, priority = 1000 }
