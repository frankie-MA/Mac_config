return {
    "nvim-treesitter/nvim-treesitter",
    -- :TSInstall запускается один раз при установке плагина
    build = ":TSInstall python markdown markdown_inline json jsonc lua bash",
    cmd = { "TSInstall", "TSUpdate", "TSUninstall" },
    config = function()
        -- В новом nvim-treesitter подсветка идёт через встроенный vim.treesitter
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
}
