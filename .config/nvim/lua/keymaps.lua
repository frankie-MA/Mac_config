local map = vim.keymap.set

-- Быстрый выход из insert mode (terminal mode использует <C-Space>)
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Буфер обмена системы (вместо "+y)
map({ "n", "v" }, "<leader>y", '"+y',  { desc = "Copy to clipboard" })
map("n",          "<leader>Y", '"+Y',  { desc = "Copy line to clipboard" })
map({ "n", "v" }, "<leader>x", '"+d',  { desc = "Cut to clipboard" })
map({ "n", "v" }, "<leader>P", '"+p',  { desc = "Paste from clipboard" })

local function current_file_path(kind)
    if vim.bo.filetype == "oil" then
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        local dir = oil.get_current_dir()
        if not entry or not dir then
            return nil
        end

        local absolute = vim.fs.normalize(vim.fs.joinpath(dir, entry.name))
        if kind == "name" then
            return entry.name
        elseif kind == "relative" then
            return vim.fn.fnamemodify(absolute, ":.")
        end
        return absolute
    end

    local modifiers = {
        name = ":t",
        relative = ":p:.",
        absolute = ":p",
    }
    return vim.fn.expand("%" .. modifiers[kind])
end

local function copy_file_path(kind, label)
    return function()
        local path = current_file_path(kind)
        if not path or path == "" then
            vim.notify("No file under cursor", vim.log.levels.WARN)
            return
        end

        vim.fn.setreg("+", path)
        vim.notify(label .. ": " .. path)
    end
end

map("n", "<leader>yp", copy_file_path("relative", "Copied relative path"), { desc = "Copy relative file path" })
map("n", "<leader>yP", copy_file_path("absolute", "Copied absolute path"), { desc = "Copy absolute file path" })
map("n", "<leader>yf", copy_file_path("name",     "Copied file name"),     { desc = "Copy file name" })

-- Временный Markdown-буфер для составления промтов
map("n", "<leader>ap", function()
    require("prompt").open()
end, { desc = "Open prompt scratch buffer" })

-- Безопасное сохранение и закрытие
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>close<cr>", { desc = "Close window" })

local function delete_file_buffer()
    local current = vim.api.nvim_get_current_buf()

    if vim.bo[current].buftype ~= "" then
        vim.notify("Use the panel's own toggle to close it", vim.log.levels.WARN)
        return
    end
    if vim.bo[current].modified then
        vim.notify("Buffer has unsaved changes", vim.log.levels.WARN)
        return
    end

    local replacement
    local alternate = vim.fn.bufnr("#")
    if alternate > 0
        and alternate ~= current
        and vim.api.nvim_buf_is_valid(alternate)
        and vim.bo[alternate].buflisted
        and vim.bo[alternate].buftype == ""
    then
        replacement = alternate
    else
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if buf ~= current
                and vim.api.nvim_buf_is_valid(buf)
                and vim.bo[buf].buflisted
                and vim.bo[buf].buftype == ""
            then
                replacement = buf
                break
            end
        end
    end

    replacement = replacement or vim.api.nvim_create_buf(true, false)
    for _, win in ipairs(vim.fn.win_findbuf(current)) do
        vim.api.nvim_win_set_buf(win, replacement)
    end
    vim.api.nvim_buf_delete(current, { force = false })
end

map("n", "<leader>bd", delete_file_buffer, { desc = "Delete buffer, keep layout" })
map("n", "<leader>Q", "<cmd>confirm qall<cr>", { desc = "Quit Neovim" })

-- LSP diagnostics (глобальные; per-buffer биндинги в lsp.lua)
map("n", "[d",        vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })
map("n", "]d",        vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })
