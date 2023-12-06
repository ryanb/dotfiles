-- https://github.com/ThePrimeagen/refactoring.nvim

local function config()
    require("refactoring").setup()
    require("telescope").load_extension("refactoring")
end

return {
    "ThePrimeagen/refactoring.nvim",
    config = config,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
    },
}
