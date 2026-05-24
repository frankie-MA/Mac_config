return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
        { "<leader>fm", function() require("conform").format({ async = true }) end, desc = "Format file" },
    },
    opts = {
        formatters_by_ft = {
            python   = { "ruff_format", "ruff_organize_imports" },
            lua      = { "stylua" },
            json     = { "prettier" },
            yaml     = { "prettier" },
            markdown = { "prettier" },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    },
}
