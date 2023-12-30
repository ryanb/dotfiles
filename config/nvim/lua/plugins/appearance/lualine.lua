-- A fancy status line
--
-- https://github.com/nvim-lualine/lualine.nvim

local function copy_relative_path()
    local path = vim.fn.expand("%:.")
    vim.fn.setreg("+", path)
    vim.notify("Path copied: " .. path)
end

local opts = {
    extensions = { "lazy", "neo-tree", "man", "mason", "quickfix" },
    options = {
        globalstatus = true,
        padding = 2,
        section_separators = { left = "", right = "" },
        theme = "auto",
    },
    sections = {
        lualine_c = { { "filename", path = 1, on_click = copy_relative_path } },
    },
}

return { "nvim-lualine/lualine.nvim", opts = opts }
