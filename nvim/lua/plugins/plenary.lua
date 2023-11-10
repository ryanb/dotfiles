local function configure()
    vim.cmd.packadd({"plenary.nvim", bang = true}) -- https://github.com/nvim-lua/plenary.nvim
end

return {configure = configure}
