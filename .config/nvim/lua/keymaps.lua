local map = vim.keymap.set

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

-- LSP diagnostics (глобальные; per-buffer биндинги в lsp.lua)
map("n", "[d",        vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })
map("n", "]d",        vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })
