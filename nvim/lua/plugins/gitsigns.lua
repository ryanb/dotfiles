local function configure()
    vim.cmd.packadd({"gitsigns.nvim", bang = true}) -- https://github.com/lewis6991/gitsigns.nvim
    local gitsigns = require("gitsigns")
    gitsigns.setup()
end

return {configure = configure}
