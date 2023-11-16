local function configure()
    vim.cmd.packadd({ "conform.nvim", bang = true }) -- https://github.com/stevearc/conform.nvim
    local conform = require("conform")
    conform.setup({
        formatters_by_ft = {
            css = { { "prettierd", "prettier" } },
            html = { { "prettierd", "prettier" } },
            javascript = { { "prettierd", "prettier" } },
            json = { { "prettierd", "prettier" } },
            lua = { "stylua" },
            ruby = { { "standardrb", "prettierd", "prettier" } },
            typescript = { { "prettierd", "prettier" } },
            typescriptreact = { { "prettierd", "prettier" } },
        },
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 10000,
        },
        notify_on_error = true,
    })
end

return { configure = configure }
