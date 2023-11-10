local function packadd(package)
    vim.cmd.packadd({package, bang = true})
end

return {
    packadd = packadd
}
