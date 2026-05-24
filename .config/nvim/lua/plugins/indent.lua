return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPre",
    opts = {
        indent = { char = "│" },
        scope = { enabled = true }, -- подсвечивает текущий scope
        exclude = {
            filetypes = { "help", "dashboard", "lazy", "mason", "oil" },
        },
    },
}
