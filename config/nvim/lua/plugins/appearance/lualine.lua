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
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "diagnostics" },
        lualine_c = { { "filename", path = 1, on_click = copy_relative_path } },
        lualine_x = { "branch" },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
    },
}

return { "nvim-lualine/lualine.nvim", opts = opts }
