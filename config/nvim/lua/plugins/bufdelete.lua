local function configure()
    vim.cmd.packadd({ "bufdelete.nvim", bang = true }) -- https://github.com/famiu/bufdelete.nvim
end

return { configure = configure }
