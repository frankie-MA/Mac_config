local map = vim.keymap.set

-- Netrw (файловый браузер)
map("n", "<leader>pv", vim.cmd.Ex)

-- LSP (задаются также в lsp.lua per-buffer, здесь глобальные)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "<leader>e", vim.diagnostic.open_float)
