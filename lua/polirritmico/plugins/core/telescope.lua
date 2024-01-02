--- Telescope: Searches with fzf
local on_load = require(MyUser .. ".utils").on_load
return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    tag = "0.1.5",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            enabled = vim.fn.executable("make") == 1,
            config = function()
                on_load("telescope.nvim", function()
                    require("telescope").load_extension("fzf")
                end)
            end,
        },
        { "nvim-telescope/telescope-file-browser.nvim" },
        { "crispgm/telescope-heading.nvim" },
    },
    keys = {
        -- Builtins
        {
            "<leader>ff",
            "<cmd>Telescope find_files<cr>",
            desc = "Telescope: Find files (nvim runtime path)",
        },
        {
            "<leader>fF",
            "<cmd>Telescope find_files cwd=%:p:h hidden=true<cr>",
            desc = "Telescope: Find files (from file path)",
        },
        {
            "<leader>fb",
            "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
            desc = "Telescope: Find/Switch between buffers",
        },
        {
            "<leader>fg",
            "<cmd>Telescope live_grep<cr>",
            desc = "Telescope: Find Grep",
        },
        {
            "<leader>fg",
            "<cmd>Telescope grep_string<cr>",
            mode = "x",
            desc = "Telescope: Find Grep (selected string)",
        },
        {
            "<leader>fr",
            "<cmd>Telescope registers<cr>",
            mode = { "n", "v" },
            desc = "Telescope: Select and paste from registers",
        },
        {
            "<leader>fo",
            "<cmd>Telescope oldfiles<cr>",
            desc = "Telescope: Find recent/old files",
        },
        {
            "<leader>fl",
            "<cmd>Telescope resume<cr>",
            desc = "Telescope: List results of the last telescope search",
        },
        {
            "<leader>fh",
            "<cmd>Telescope help_tags<cr>",
            desc = "Telescope: Find in help tags",
        },
        {
            "<leader>fm",
            "<cmd>Telescope marks<cr>",
            desc = "Telescope: Find buffer marks",
        },
        {
            "<leader>fT",
            "<cmd>Telescope<cr>",
            desc = "Telescope: Find telescope builtins functions",
        },

        -- Extensions
        {
            "<leader>fe",
            "<cmd>Telescope file_browser<cr>",
            desc = "Telescope: File explorer from nvim path",
        },
        {
            "<leader>fE",
            "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr> hidden=true<cr>",
            desc = "Telescope: File explorer mode from buffer path.",
        },
        {
            "<leader>fH",
            "<cmd>Telescope heading<cr>",
            ft = "markdown",
            desc = "Telescope: Get document headers (markdown).",
        },
        {
            "<leader>cc",
            [[<cmd>lua require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })<cr>]],
            desc = "Telescope: Configurations",
        },
    },
    opts = function()
        local layout_strategy, layout_config
        if Workstation then
            layout_strategy = "flex"
            layout_config = {
                flex = { flip_columns = 120 },
                horizontal = { preview_width = { 0.6, max = 100, min = 30 } },
            }
        else
            layout_strategy = "vertical"
            layout_config = { vertical = { preview_cutoff = 20, preview_height = 9 } }
        end

        return {
            defaults = {
            -- stylua: ignore
            file_ignore_patterns = {
                "venv", "__pycache__", "%.xlsx", "%.jpg", "%.png", "%.JPG",
                "%.PNG", "%.webp", "%.WEBP", "%.mp3", "%.MP3", "%.pdf",
                "%.PDF", "%.odt", "%.ODT", "%.ico", "%.ICO",
            },
                layout_strategy = layout_strategy,
                layout_config = layout_config,
                path_display = { "truncate" },
                prompt_prefix = "   ",
                selection_caret = " 󰄾  ",
                mappings = { i = { ["<C-h>"] = "which_key" } }, -- toggle keymaps help
            },
            extensions = {
                heading = {
                    treesitter = false,
                    picker_opts = {
                        layout_strategy = "horizontal",
                        sorting_strategy = "ascending",
                        layout_config = {
                            preview_cutoff = 20,
                            preview_width = 0.7,
                        },
                    },
                },
            },
        }
    end,
}
