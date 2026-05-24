return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Help tags" },
        { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    },
    opts = {
        defaults = {
            layout_strategy = "horizontal",
            sorting_strategy = "ascending",
            layout_config = { prompt_position = "top" },
        },
    },
}
