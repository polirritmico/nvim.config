--- Globals

-- Improve load time
vim.loader.enable()

---@type boolean true on workstation machine or false for laptop.
Workstation = vim.fn.hostname() == "hal-9002"

-- Helper functions

local utils = require("config.utils") ---@type Utils
P = utils.custom_print
CustomFoldText = utils.fold_text

-- Paths

---@type string -- Path of the neovim config folder (`~/.config/nvim`)
NeovimPath = vim.fn.stdpath("config")
---@type string -- Path of the lua config. (`nvim/lua/config/`)
MyConfigPath = NeovimPath .. "/lua/config/"
---@type string -- Path of my custom plugins sources outside Nvim's rtp.
MyPluginsPath = Workstation and vim.fn.expand("$HOME/Informática/Programación/")
  or vim.fn.expand("$HOME/Proyectos/")

-- Check paths
assert(vim.fn.finddir(MyConfigPath) ~= "", "Error: Missing configuration path?!")
assert(vim.fn.finddir(MyPluginsPath) ~= "", "Error: Missing personal plugins path.")

-- Set variables for vimscript env
vim.api.nvim_set_var("NeovimPath", NeovimPath)
vim.api.nvim_set_var("MyConfigPath", MyConfigPath)

--- Load configs

utils.load_config("settings")
utils.load_config("mappings")
if not utils.detected_errors() then
  require("config.lazy")
end
