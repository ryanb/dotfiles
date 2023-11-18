-- https://github.com/vim-test/vim-test

local function config()
    vim.cmd('let test#strategy = "asyncrun_background"')
end

return {
    "vim-test/vim-test",
    dependencies = {
        "tpope/vim-dispatch",
        "skywind3000/asyncrun.vim",
    },
    config = config,
}
