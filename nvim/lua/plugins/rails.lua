local function configure()
    vim.cmd.packadd({ "vim-rails", bang = true }) -- https://github.com/tpope/vim-rails
end

return { configure = configure }
