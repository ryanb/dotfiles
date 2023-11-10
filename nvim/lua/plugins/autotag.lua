local function configure()
    vim.cmd.packadd({"nvim-ts-autotag", bang = true}) -- https://github.com/windwp/nvim-ts-autotag
    local autotag = require("nvim-ts-autotag")
    autotag.setup()
end

return {configure = configure}
