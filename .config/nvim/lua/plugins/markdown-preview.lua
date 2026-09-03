-- Предпросмотр Markdown в браузере с синхронной прокруткой.
-- Собираем через npm (build = function() vim.fn["mkdp#util#install"]() end
-- из README не работает с ленивой загрузкой по ft в lazy.nvim: build-хук
-- запускается раньше, чем автозагрузочная функция плагина попадает в rtp,
-- и падает с E117 Unknown function: mkdp#util#install).
return {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npm install",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
        { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown preview", ft = "markdown" },
    },
}
