local function configure()
    vim.cmd.packadd({ "conform.nvim", bang = true }) -- https://github.com/stevearc/conform.nvim
    local conform = require("conform")
    conform.setup({
        formatters_by_ft = {
            css = { "prettier" },
            html = { "prettier" },
            javascript = { "prettier" },
            json = { "prettier" },
            lua = { "stylua" },
            ruby = { { "standardrb", "prettier" } },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
        },
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 10000,
        },
        notify_on_error = true,
    })
end

return { configure = configure }
