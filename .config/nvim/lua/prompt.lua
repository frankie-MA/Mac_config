local M = {}

local prompt_buf

local function prompt_text(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    while #lines > 0 and lines[#lines]:match("^%s*$") do
        table.remove(lines)
    end
    return table.concat(lines, "\n")
end

local function copy_prompt(buf)
    local text = prompt_text(buf)
    if text:match("^%s*$") then
        vim.notify("Prompt is empty", vim.log.levels.WARN)
        return false
    end

    vim.fn.setreg("+", text)
    vim.notify(string.format("Prompt copied: %d lines", select(2, text:gsub("\n", "\n")) + 1))
    return true
end

local function close_prompt(buf)
    vim.bo[buf].modified = false
    vim.cmd.tabclose()
end

function M.open()
    if prompt_buf and vim.api.nvim_buf_is_valid(prompt_buf) then
        local win = vim.fn.bufwinid(prompt_buf)
        if win ~= -1 then
            vim.api.nvim_set_current_win(win)
            return
        end
    end

    vim.cmd.tabnew()
    prompt_buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_name(prompt_buf, "[Prompt]")
    vim.bo[prompt_buf].buftype = "nofile"
    vim.bo[prompt_buf].bufhidden = "wipe"
    vim.bo[prompt_buf].swapfile = false
    vim.bo[prompt_buf].buflisted = false
    vim.bo[prompt_buf].filetype = "markdown"

    vim.api.nvim_buf_set_lines(prompt_buf, 0, -1, false, {
        "# Задача",
        "",
        "",
        "# Контекст",
        "",
        "",
        "# Требования",
        "",
        "",
        "# Критерии готовности",
        "",
    })
    vim.api.nvim_win_set_cursor(0, { 3, 0 })

    local opts = { buffer = prompt_buf }
    vim.keymap.set("n", "<leader>ay", function()
        copy_prompt(prompt_buf)
    end, vim.tbl_extend("force", opts, { desc = "Copy prompt" }))

    vim.keymap.set("n", "<leader>aY", function()
        if copy_prompt(prompt_buf) then
            close_prompt(prompt_buf)
        end
    end, vim.tbl_extend("force", opts, { desc = "Copy and close prompt" }))

    vim.keymap.set("n", "<leader>aq", function()
        close_prompt(prompt_buf)
    end, vim.tbl_extend("force", opts, { desc = "Discard prompt" }))

    vim.cmd.startinsert()
end

return M
