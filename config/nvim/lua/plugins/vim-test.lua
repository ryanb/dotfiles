local function configure()
    vim.cmd.packadd({ "vim-dispatch", bang = true }) -- https://github.com/tpope/vim-dispatch
    vim.cmd.packadd({ "asyncrun.vim", bang = true }) -- https://github.com/tpope/vim-dispatch
    vim.cmd.packadd({ "vim-test", bang = true }) -- https://github.com/vim-test/vim-test

    vim.cmd('let test#strategy = "asyncrun_background"')
    -- vim.g.test_strategy = "asyncrun_background"
end

return { configure = configure }
