return {
    "akinsho/toggleterm.nvim", -- уже установлен, просто расширяем
    optional = true,
    config = function()
        local Terminal = require("toggleterm.terminal").Terminal

        -- Выделенный терминал для Claude (сохраняет сессию между открытиями)
        local claude = Terminal:new({
            cmd = "claude",
            direction = "float",
            float_opts = {
                border = "curved",
                width = function() return math.floor(vim.o.columns * 0.85) end,
                height = function() return math.floor(vim.o.lines * 0.85) end,
            },
            on_open = function()
                vim.cmd("startinsert!")
            end,
        })

        -- Открыть/закрыть Claude
        vim.keymap.set("n", "<leader>ac", function()
            claude:toggle()
        end, { desc = "Toggle Claude" })

        -- Закрыть из terminal mode
        vim.keymap.set("t", "<leader>ac", function()
            claude:toggle()
        end, { desc = "Toggle Claude" })

        -- Отправить визуальное выделение в Claude
        vim.keymap.set("v", "<leader>as", function()
            -- Получаем выделенный текст
            local start_pos = vim.fn.getpos("'<")
            local end_pos   = vim.fn.getpos("'>")
            local lines     = vim.fn.getline(start_pos[2], end_pos[2])
            if #lines == 0 then return end

            -- Обрезаем первую и последнюю строку по столбцам выделения
            lines[#lines] = lines[#lines]:sub(1, end_pos[3])
            lines[1]      = lines[1]:sub(start_pos[3])

            local filetype = vim.bo.filetype
            local code     = table.concat(lines, "\n")
            local message  = string.format("```%s\n%s\n```\n\nОбъясни этот код.", filetype, code)

            -- Открываем Claude и вставляем сообщение
            claude:open()
            vim.defer_fn(function()
                local escaped = message:gsub("'", "'\\''")
                vim.fn.chansend(claude.job_id, escaped .. "\n")
            end, 300)
        end, { desc = "Send selection to Claude" })

        -- Отправить текущий файл в Claude для ревью
        vim.keymap.set("n", "<leader>ar", function()
            local filepath = vim.fn.expand("%:p")
            local filetype = vim.bo.filetype
            local lines    = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local content  = table.concat(lines, "\n")
            local message  = string.format(
                "Файл: %s\n\n```%s\n%s\n```\n\nСделай code review.",
                filepath, filetype, content
            )

            claude:open()
            vim.defer_fn(function()
                local escaped = message:gsub("'", "'\\''")
                vim.fn.chansend(claude.job_id, escaped .. "\n")
            end, 300)
        end, { desc = "Send file to Claude for review" })
    end,
}
