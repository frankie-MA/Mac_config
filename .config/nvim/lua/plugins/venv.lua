-- Выбор Python-окружения (поддерживает uv venvs — папки .venv)
return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    branch = "regexp",
    config = function()
        require("venv-selector").setup()
    end,
    keys = {
        { "<leader>vs", "<cmd>VenvSelect<cr>",       desc = "Select Python venv (uv)" },
        { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Use cached venv" },
    },
}
