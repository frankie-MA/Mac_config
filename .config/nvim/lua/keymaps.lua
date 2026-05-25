local map = vim.keymap.set

-- Буфер обмена системы (вместо "+y)
map({ "n", "v" }, "<leader>y", '"+y',  { desc = "Copy to clipboard" })
map("n",          "<leader>Y", '"+Y',  { desc = "Copy line to clipboard" })
map({ "n", "v" }, "<leader>x", '"+d',  { desc = "Cut to clipboard" })
map({ "n", "v" }, "<leader>P", '"+p',  { desc = "Paste from clipboard" })

-- LSP diagnostics (глобальные; per-buffer биндинги в lsp.lua)
map("n", "[d",        vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })
map("n", "]d",        vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })
