return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = {
            "python", "markdown", "markdown_inline",
            "json", "jsonc", "lua", "bash",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    },
}
