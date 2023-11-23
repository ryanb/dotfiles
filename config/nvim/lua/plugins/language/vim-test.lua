-- https://github.com/vim-test/vim-test

local function config()
    vim.cmd('let test#strategy = "asyncrun_background"')

    -- Open the quickfix window when running tests.
    vim.cmd("let g:asyncrun_open = 8")

    local group = vim.api.nvim_create_augroup("testNotifications", { clear = true })

    -- vim.api.nvim_create_autocmd("User", {
    --     pattern = "AsyncRunStart",
    --     callback = function()
    --         vim.notify("Started.", vim.log.levels.INFO, { title = "Test" })
    --     end,
    --     group = group,
    -- })

    vim.api.nvim_create_autocmd("User", {
        pattern = "AsyncRunStop",
        callback = function()
            if vim.g.asyncrun_status == "success" then
                vim.notify("Passed.", vim.log.levels.INFO, { title = "Test" })
            elseif vim.g.asyncrun_status == "failure" then
                vim.notify("Failed.", vim.log.levels.ERROR, { title = "Test" })
            end
        end,
        group = group,
    })
end

return {
    "vim-test/vim-test",
    config = config,
    dependencies = {
        "tpope/vim-dispatch",
        "skywind3000/asyncrun.vim",
    },
}
