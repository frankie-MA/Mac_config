return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { delay = 400 },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        wk.add({
            -- Файлы
            { "<leader>p",  group = "files" },
            { "<leader>pv", desc = "File explorer (oil)" },

            -- Поиск (telescope)
            { "<leader>f",  group = "find" },
            { "<leader>ff", desc = "Find files" },
            { "<leader>fg", desc = "Live grep" },
            { "<leader>fb", desc = "Buffers" },
            { "<leader>fh", desc = "Help tags" },
            { "<leader>fd", desc = "Diagnostics" },

            -- Форматирование
            { "<leader>fm", desc = "Format file" },

            -- LSP
            { "<leader>r",  group = "rename" },
            { "<leader>rn", desc = "Rename symbol" },
            { "<leader>c",  group = "code" },
            { "<leader>ca", desc = "Code action" },
            { "<leader>e",  desc = "Diagnostic float" },

            -- Git (gitsigns)
            { "<leader>g",  group = "git" },
            { "<leader>gp", desc = "Preview hunk" },
            { "<leader>gb", desc = "Blame line" },
            { "<leader>gs", desc = "Stage hunk" },
            { "<leader>gu", desc = "Undo stage hunk" },
            { "<leader>gr", desc = "Reset hunk" },
            { "<leader>gd", desc = "Diff this" },

            -- LazyGit
            { "<leader>l",  group = "lazygit" },
            { "<leader>lg", desc = "Open LazyGit" },

            -- Venv / uv
            { "<leader>v",  group = "venv (uv)" },
            { "<leader>vs", desc = "Select venv" },
            { "<leader>vc", desc = "Use cached venv" },

            -- Терминал
            { "<leader>t",  group = "terminal" },
            { "<leader>tt", desc = "Toggle terminal" },
            { "<leader>td", desc = "Terminal bottom" },
            { "<leader>tf", desc = "Terminal float" },

            -- Claude AI
            { "<leader>a",  group = "claude AI" },
            { "<leader>ai", desc = "Toggle Claude" },
            { "<leader>ae", desc = "Explain selection",        mode = "v" },
            { "<leader>av", desc = "Review current file" },

            -- Комментарии (подсказка, сами биндинги от Comment.nvim)
            { "gc",         group = "comment (motion)" },
            { "gcc",        desc = "Comment line" },
            { "gbc",        desc = "Comment block" },
        })
    end,
}
