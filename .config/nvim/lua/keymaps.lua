local map = vim.keymap.set

-- LSP diagnostics (глобальные; per-buffer биндинги в lsp.lua)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "<leader>e", vim.diagnostic.open_float)
