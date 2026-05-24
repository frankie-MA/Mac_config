return {
    "nvim-treesitter/nvim-treesitter",
    -- Lua-функция в build запускается один раз при установке/обновлении плагина
    build = function()
        require("nvim-treesitter.install").install(
            "python", "markdown", "markdown_inline",
            "json", "jsonc", "lua", "bash"
        )
    end,
    config = function()
        -- Подсветка через встроенный vim.treesitter (новый API)
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
}
