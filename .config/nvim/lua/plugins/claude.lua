return {
    "akinsho/toggleterm.nvim",
    optional = true,
    config = function()
        local Terminal = require("toggleterm.terminal").Terminal

        local claude = Terminal:new({
            cmd = "claude",
            direction = "float",
            float_opts = {
                border = "curved",
                width  = function() return math.floor(vim.o.columns * 0.85) end,
                height = function() return math.floor(vim.o.lines * 0.85) end,
            },
            on_open = function() vim.cmd("startinsert!") end,
        })

        -- <leader>ai — toggle (i = interactive, не пересекается с другими группами)
        vim.keymap.set({ "n", "t" }, "<leader>ai", function()
            claude:toggle()
        end, { desc = "Toggle Claude" })

        -- <leader>ae — explain (visual: объяснить выделенный код)
        vim.keymap.set("v", "<leader>ae", function()
            local s = vim.fn.getpos("'<")
            local e = vim.fn.getpos("'>")
            local lines = vim.fn.getline(s[2], e[2])
            if #lines == 0 then return end
            lines[#lines] = lines[#lines]:sub(1, e[3])
            lines[1]      = lines[1]:sub(s[3])

            local ft  = vim.bo.filetype
            local msg = string.format("```%s\n%s\n```\n\nОбъясни этот код.", ft, table.concat(lines, "\n"))
            claude:open()
            vim.defer_fn(function()
                vim.fn.chansend(claude.job_id, msg:gsub("'", "'\\''") .. "\n")
            end, 300)
        end, { desc = "Explain selection" })

        -- <leader>av — review (v = review текущего файла)
        vim.keymap.set("n", "<leader>av", function()
            local ft      = vim.bo.filetype
            local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
            local msg     = string.format(
                "Файл: %s\n\n```%s\n%s\n```\n\nСделай code review.",
                vim.fn.expand("%:p"), ft, content
            )
            claude:open()
            vim.defer_fn(function()
                vim.fn.chansend(claude.job_id, msg:gsub("'", "'\\''") .. "\n")
            end, 300)
        end, { desc = "Review current file" })
    end,
}
