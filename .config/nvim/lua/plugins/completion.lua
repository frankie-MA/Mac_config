return {
    "saghen/blink.cmp",
    version = "*", -- использует pre-built бинарники (не нужен Rust)
    opts = {
        keymap = { preset = "default" },
        appearance = { nerd_font_variant = "mono" },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
        },
    },
}
