return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        delay = 400, -- мс до появления подсказки
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        -- Описания групп клавиш
        wk.add({
            { "<leader>p",  group = "files" },
            { "<leader>l",  group = "lazygit" },
            { "<leader>v",  group = "venv (uv)" },
            { "<leader>r",  group = "rename" },
            { "<leader>c",  group = "code action" },
        })
    end,
}
