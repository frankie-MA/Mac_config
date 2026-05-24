return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<leader>tt", "<cmd>ToggleTerm<cr>",                    desc = "Toggle terminal" },
        { "<leader>td", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal bottom" },
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",    desc = "Terminal float" },
    },
    opts = {
        direction = "float",
        float_opts = { border = "curved" },
        shell = "/opt/homebrew/bin/fish",
    },
}
