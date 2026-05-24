return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local autopairs = require("nvim-autopairs")
        autopairs.setup({ check_ts = true }) -- учитывает treesitter контекст

        -- Интеграция с blink.cmp: добавляет скобки после выбора функции
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local ok, cmp = pcall(require, "blink.cmp")
        if ok and cmp.event then
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    end,
}
