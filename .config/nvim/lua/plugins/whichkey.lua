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

            -- Буфер обмена
            { "<leader>y",  desc = "Copy to clipboard",      mode = { "n", "v" } },
            { "<leader>Y",  desc = "Copy line to clipboard" },
            { "<leader>x",  desc = "Cut to clipboard",       mode = { "n", "v" } },
            { "<leader>P",  desc = "Paste from clipboard",   mode = { "n", "v" } },

            -- AI prompts
            { "<leader>a",  group = "AI prompt" },
            { "<leader>ap", desc = "Open prompt scratch buffer" },

            -- Сохранение и закрытие
            { "<leader>w",  desc = "Save file" },
            { "<leader>q",  desc = "Close window" },
            { "<leader>Q",  desc = "Quit Neovim" },
            { "<leader>b",  group = "buffers" },
            { "<leader>bd", desc = "Delete buffer, keep layout" },

            -- LSP
            { "<leader>r",  group = "rename" },
            { "<leader>rn", desc = "Rename symbol" },
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
            { "<leader>lg", desc = "Toggle bottom LazyGit", mode = { "n", "t" } },

            -- Venv / uv
            { "<leader>v",  group = "venv (uv)" },
            { "<leader>vs", desc = "Select venv" },
            { "<leader>vc", desc = "Use cached venv" },

            -- Markdown
            { "<leader>m",  group = "markdown" },
            { "<leader>mp", desc = "Toggle preview" },

            -- Терминал
            { "<leader>t",  group = "terminal" },
            { "<leader>tt", desc = "Toggle bottom terminal", mode = { "n", "t" } },
            { "<leader>tm", desc = "Maximize bottom panel", mode = { "n", "t" } },

            -- Code & Claude
            { "<leader>c",  group = "code & claude" },
            { "<leader>ca", desc = "Code action" },
            { "<leader>cc", desc = "Toggle Claude" },
            { "<leader>ce", desc = "Explain selection",      mode = "v" },
            { "<leader>cv", desc = "Review current file" },

            -- Комментарии
            { "gc",         group = "comment" },
            { "gcc",        desc = "Comment line" },
            { "gbc",        desc = "Comment block" },

            -- Навигация (LSP)
            { "g",          group = "goto" },
            { "gd",         desc = "Definition" },
            { "gr",         desc = "References" },
            { "K",          desc = "Hover docs" },

            -- Навигация (hunks / diagnostics)
            { "]",          group = "next" },
            { "]d",         desc = "Next diagnostic" },
            { "]h",         desc = "Next git hunk" },
            { "[",          group = "prev" },
            { "[d",         desc = "Prev diagnostic" },
            { "[h",         desc = "Prev git hunk" },
        })
    end,
}
