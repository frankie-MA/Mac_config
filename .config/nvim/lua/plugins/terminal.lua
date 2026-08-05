local bottom_terminal
local bottom_lazygit
local active_bottom_panel

local function toggle_bottom_panel(panel)
    if active_bottom_panel and active_bottom_panel:is_open() then
        active_bottom_panel:close()
        if active_bottom_panel == panel then
            active_bottom_panel = nil
            return
        end
    end

    panel:open()
    active_bottom_panel = panel
end

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<leader>tt", function() toggle_bottom_panel(bottom_terminal) end,
            desc = "Toggle bottom terminal", mode = { "n", "t" } },
        { "<leader>lg", function() toggle_bottom_panel(bottom_lazygit) end,
            desc = "Toggle bottom LazyGit", mode = { "n", "t" } },
    },
    config = function()
        require("toggleterm").setup({
            direction = "horizontal",
            size = 15,
            persist_size = true,
            start_in_insert = true,
            shell = "/opt/homebrew/bin/fish",
        })

        local Terminal = require("toggleterm.terminal").Terminal
        local function bottom_panel_options(name)
            return {
                direction = "horizontal",
                display_name = name,
                close_on_exit = true,
                on_open = function(term)
                    vim.wo.winfixheight = true
                    vim.api.nvim_win_set_height(0, 15)
                    vim.cmd("startinsert!")
                    vim.keymap.set("t", "<C-Space>", [[<C-\><C-n>]],
                        { buffer = term.bufnr, desc = "Terminal normal mode" })
                end,
            }
        end

        bottom_terminal = Terminal:new(bottom_panel_options("Terminal"))

        local lazygit_options = bottom_panel_options("LazyGit")
        lazygit_options.cmd = "lazygit"
        bottom_lazygit = Terminal:new(lazygit_options)

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
