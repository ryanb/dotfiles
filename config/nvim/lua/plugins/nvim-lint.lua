local function configure()
    vim.cmd.packadd({ "nvim-lint", bang = true }) -- https://github.com/mfussenegger/nvim-lint
    local lint = require("lint")
    lint.linters_by_ft = {
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
    }

    local group = vim.api.nvim_create_augroup("lintOnSave", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        callback = function()
            lint.try_lint()
        end,
    })
end

return { configure = configure }
