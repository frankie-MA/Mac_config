return {
    "stevearc/oil.nvim",
    lazy = false, -- нужен сразу (открытие nvim в директории)
    keys = {
        { "<leader>pv", "<cmd>Oil<cr>", desc = "File explorer" },
    },
    opts = {
        view_options = { show_hidden = true },
        float = { border = "rounded" },
    },
}
