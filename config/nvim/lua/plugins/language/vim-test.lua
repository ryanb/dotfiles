local function init()
    vim.cmd('let test#strategy = "asyncrun_background"')
end

return {
    "vim-test/vim-test",
    dependencies = {
        "tpope/vim-dispatch",
        "skywind3000/asyncrun.vim",
    },
    init = init,
}
