return {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").install({
            "python", "markdown", "markdown_inline",
            "json", "jsonc", "lua", "bash",
        })
    end,
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
}
