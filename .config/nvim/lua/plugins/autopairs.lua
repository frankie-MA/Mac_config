return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        check_ts = true, -- учитывает treesitter контекст
    },
}
