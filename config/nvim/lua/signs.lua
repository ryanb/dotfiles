-- Set the diagnostic signs shown in the gutter to match lualine's.
local function configure()
    vim.fn.sign_define("DiagnosticSignError", { text = "󰅚 ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "󰀪 ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "󰋽 ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌶", texthl = "DiagnosticSignHint" })
end

return { configure = configure }
