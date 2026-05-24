return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            end

            map("]h",          gs.next_hunk,                       "Next hunk")
            map("[h",          gs.prev_hunk,                       "Prev hunk")
            map("<leader>gp",  gs.preview_hunk,                    "Preview hunk")
            map("<leader>gb",  gs.blame_line,                      "Blame line")
            map("<leader>gs",  gs.stage_hunk,                      "Stage hunk")
            map("<leader>gu",  gs.undo_stage_hunk,                 "Undo stage hunk")
            map("<leader>gr",  gs.reset_hunk,                      "Reset hunk")
            map("<leader>gd",  gs.diffthis,                        "Diff this")
        end,
    },
}
