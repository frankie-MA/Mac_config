return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<leader>tt", "<cmd>ToggleTerm<cr>",                       desc = "Toggle terminal", mode = { "n", "t" } },
        { "<leader>td", "<cmd>ToggleTerm direction=horizontal<cr>",  desc = "Terminal bottom", mode = { "n", "t" } },
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",       desc = "Terminal float",  mode = { "n", "t" } },
    },
    config = function()
        require("toggleterm").setup({
            direction = "float",
            float_opts = { border = "curved" },
            shell = "/opt/homebrew/bin/fish",
        })

        local Terminal = require("toggleterm.terminal").Terminal
        local claude   = Terminal:new({
            cmd = "claude",
            direction = "float",
            float_opts = {
                border = "curved",
                width  = function() return math.floor(vim.o.columns * 0.85) end,
                height = function() return math.floor(vim.o.lines * 0.85) end,
            },
            on_open = function() vim.cmd("startinsert!") end,
        })

        vim.keymap.set({ "n", "t" }, "<leader>cc", function() claude:toggle() end,
            { desc = "Toggle Claude" })

        vim.keymap.set("v", "<leader>ce", function()
            local s     = vim.fn.getpos("'<")
            local e     = vim.fn.getpos("'>")
            local lines = vim.fn.getline(s[2], e[2])
            if #lines == 0 then return end
            lines[#lines] = lines[#lines]:sub(1, e[3])
            lines[1]      = lines[1]:sub(s[3])
            local msg = string.format("```%s\n%s\n```\n\nОбъясни этот код.",
                vim.bo.filetype, table.concat(lines, "\n"))
            claude:open()
            vim.defer_fn(function()
                vim.fn.chansend(claude.job_id, msg:gsub("'", "'\\''") .. "\n")
            end, 300)
        end, { desc = "Explain selection" })

        vim.keymap.set("n", "<leader>cv", function()
            local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
            local msg     = string.format("Файл: %s\n\n```%s\n%s\n```\n\nСделай code review.",
                vim.fn.expand("%:p"), vim.bo.filetype, content)
            claude:open()
            vim.defer_fn(function()
                vim.fn.chansend(claude.job_id, msg:gsub("'", "'\\''") .. "\n")
            end, 300)
        end, { desc = "Review current file" })
    end,
}
