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
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",    -- Python
                    "marksman",   -- Markdown
                    "jsonls",     -- JSON
                    "lua_ls",     -- Lua
                    "bashls",     -- Bash
                },
                automatic_installation = true,
            })

            local lspconfig = require("lspconfig")

            local on_attach = function(_, bufnr)
                local map = function(keys, func)
                    vim.keymap.set("n", keys, func, { buffer = bufnr })
                end
                map("gd", vim.lsp.buf.definition)
                map("gr", vim.lsp.buf.references)
                map("K",  vim.lsp.buf.hover)
                map("<leader>rn", vim.lsp.buf.rename)
                map("<leader>ca", vim.lsp.buf.code_action)
            end

            lspconfig.pyright.setup({ on_attach = on_attach })
            lspconfig.marksman.setup({ on_attach = on_attach })
            lspconfig.jsonls.setup({ on_attach = on_attach })
            lspconfig.bashls.setup({ on_attach = on_attach })
            lspconfig.lua_ls.setup({
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                    },
                },
            })
        end,
    },
}
