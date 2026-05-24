return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig", -- предоставляет дефолтные cmd/filetypes для серверов
        },
        config = function()
            -- Биндинги через LspAttach (современный подход для nvim 0.11+)
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local map = function(keys, func)
                        vim.keymap.set("n", keys, func, { buffer = args.buf })
                    end
                    map("gd",          vim.lsp.buf.definition)
                    map("gr",          vim.lsp.buf.references)
                    map("K",           vim.lsp.buf.hover)
                    map("<leader>rn",  vim.lsp.buf.rename)
                    map("<leader>ca",  vim.lsp.buf.code_action)
                end,
            })

            -- Специфичные настройки серверов через vim.lsp.config
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                    },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",   -- Python
                    "marksman",  -- Markdown
                    "jsonls",    -- JSON
                    "lua_ls",    -- Lua
                    "bashls",    -- Bash
                },
                automatic_installation = true,
                -- handlers активируют каждый сервер через нативный vim.lsp.enable
                handlers = {
                    function(server_name)
                        vim.lsp.enable(server_name)
                    end,
                },
            })
        end,
    },
}
