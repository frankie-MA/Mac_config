return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<leader>tt", "<cmd>ToggleTerm<cr>",                      desc = "Toggle terminal",  mode = { "n", "t" } },
        { "<leader>td", "<cmd>ToggleTerm direction=horizontal<cr>",  desc = "Terminal bottom",  mode = { "n", "t" } },
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",       desc = "Terminal float",   mode = { "n", "t" } },
    },
    opts = {
        direction = "float",
        float_opts = { border = "curved" },
        shell = "/opt/homebrew/bin/fish",
    },
}
