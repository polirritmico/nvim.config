-- Test manager
return {
    "polirritmico/nvim-test",
    dev = false,
    cmd = { "TestSuite", "TestFile", "TestNearest", "TestLast", "TestVisit", "TestInfo" },
    opts = {
        termOpts = {
            direction = "float", -- vertical, horizontal, float
            float_position = "bottom",
            height = 24,
            width = 200,
            stopinsert = false,
        }
    },
    keys = {
        -- {"<leader>rtf", "<CMD>silent TestFile<CR>", "n",
        --     desc = "nvim-test: Runs all test in the current file or runs the last file tests.", silent = true},
        -- {"<leader>rta", "<CMD>silent TestSuite<CR>", "n",
        --     desc = "nvim-test: Run the whole test suite following the current file or the last run test.", silent = true},
        -- {"<leader>rtu", "<CMD>silent TestNearest<CR>", "n",
        --     desc = "nvim-test: Run the test nearest to the cursor or run the last test.", silent = true},
        -- {"<leader>rtl", "<CMD>silent TestLast<CR>", "n",
        --     desc = "nvim-test: Runs the last test.", silent = true},
        -- {"<leader>glt", "<CMD>silent TestVisit<CR>", "n",
        --     desc = "nvim-test: Go/Open to the last test file that has ben run.", silent = true},
        -- {"<leader>rtI", "<CMD>silent TestInfo<CR>", "n",
        --     desc = "nvim-test: Show info about the plugin", silent = true},
        { "<leader>rtf", "<CMD>silent TestFile<CR>", desc = "nvim-test: Runs all test in the current file or runs the last file tests." },
        { "<leader>rta", "<CMD>silent TestSuite<CR>", desc = "nvim-test: Run the whole test suite following the current file or the last run test." },
        { "<leader>rtu", "<CMD>silent TestNearest<CR>", desc = "nvim-test: Run the test nearest to the cursor or run the last test." },
        { "<leader>rtl", "<CMD>silent TestLast<CR>", desc = "nvim-test: Runs the last test." },
        { "<leader>glt", "<CMD>silent TestVisit<CR>", desc = "nvim-test: Go/Open to the last test file that has ben run." },
        { "<leader>rtI", "<CMD>silent TestInfo<CR>", desc = "nvim-test: Show info about the plugin" },
    },
}
