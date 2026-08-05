local sidebar_width = 32

local function is_sidebar(win)
    return vim.api.nvim_win_is_valid(win)
        and vim.api.nvim_win_get_var(win, "oil_sidebar") == true
end

local function find_sidebar()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local ok, sidebar = pcall(is_sidebar, win)
        if ok and sidebar then
            return win
        end
    end
end

local function configure_sidebar(win)
    vim.api.nvim_win_set_var(win, "oil_sidebar", true)
    vim.wo[win].winfixwidth = true
    vim.api.nvim_win_set_width(win, sidebar_width)
end

local function toggle_sidebar()
    local sidebar = find_sidebar()
    if sidebar then
        vim.api.nvim_win_close(sidebar, false)
        return
    end

    local work_win = vim.api.nvim_get_current_win()
    if vim.bo.filetype == "oil" then
        sidebar = work_win

        if #vim.api.nvim_tabpage_list_wins(0) == 1 then
            vim.cmd("rightbelow vnew")
            work_win = vim.api.nvim_get_current_win()
        end
        configure_sidebar(sidebar)
    else
        vim.cmd("topleft " .. sidebar_width .. "vsplit")
        sidebar = vim.api.nvim_get_current_win()
        require("oil").open(vim.fn.getcwd())
        configure_sidebar(sidebar)
    end

    vim.api.nvim_set_current_win(work_win)
end

local function select_from_sidebar()
    local oil = require("oil")
    local win = vim.api.nvim_get_current_win()
    local ok, sidebar = pcall(is_sidebar, win)
    if not ok or not sidebar then
        oil.select()
        return
    end

    local entry = oil.get_cursor_entry()
    local dir = oil.get_current_dir()
    if not entry or not dir then
        return
    end

    local path = vim.fs.normalize(vim.fs.joinpath(dir, entry.name))
    local stat = vim.uv.fs_stat(path)
    if stat and stat.type == "directory" then
        oil.select()
        return
    end

    for _, target in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if target ~= win then
            vim.api.nvim_set_current_win(target)
            vim.cmd.edit(vim.fn.fnameescape(path))
            return
        end
    end
end

return {
    "stevearc/oil.nvim",
    lazy = false, -- нужен сразу (открытие nvim в директории)
    keys = {
        { "<leader>pv", toggle_sidebar, desc = "Toggle Oil sidebar" },
    },
    opts = {
        watch_for_changes = true,
        view_options = { show_hidden = true },
        float = { border = "rounded" },
        keymaps = {
            ["<CR>"] = select_from_sidebar,
        },
    },
}
