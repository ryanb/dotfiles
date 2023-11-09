local packadd = require("helpers/packadd")

local function configure_autoclosing()
    packadd("nvim-autopairs") -- https://github.com/windwp/nvim-autopairs
    local autopairs = require("nvim-autopairs")
    autopairs.setup({})

    packadd("nvim-ts-autotag") -- https://github.com/windwp/nvim-ts-autotag
    local autotag = require("nvim-ts-autotag")
    autotag.setup()
end

local function configure_autoformatting()
    packadd("neoformat") -- https://github.com/sbdchd/neoformat

    vim.g.neoformat_try_node_exe = true

    -- Remove trailing whitespace on save.
    vim.g.neoformat_basic_format_trim = true

    vim.api.nvim_create_augroup("NeoformatGroup", {clear = true})
    vim.api.nvim_create_autocmd(
        "BufWritePre",
        {
            group = "NeoformatGroup",
            command = "Neoformat"
        }
    )
end

return {
    configure = function()
        configure_autoclosing()
        configure_autoformatting()
        packadd("vim-commentary")
    end
}
