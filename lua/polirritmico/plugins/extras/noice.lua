return {
    "folke/noice.nvim",
    -- enabled = false,
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    opts = {
        -- TODO:Move to treesitter, cmp?
        -- override markdown rendering so that cmp and ohter plugins use Treesitter
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
            -- Avoid written messages
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                },
            },
            hover = {
                enabled = true,
                opts = { border = "rounded" },
            },
        },
        cmdline = { enabled = false },
        messages = { enabled = false },
        popupmenu = { enabled = false },
        -- redirect = { view = nil, filter = { event = nil }, },
        notify = { enabled = false, },
        -- signature = { enabled = false },
        -- documentation = { view = nil },
        views = {
            mini = { position = { row = -2 } },
        }
    },
}
