-- Init config
local user = "polirritmico"

-- Helper function to load the passed module. If the module returns an error,
-- then print it and load the fallback config module (user.fallback.file).
-- (This expect a fallback config named <module.lua> in the fallback folder)
local catched_errors = {}
local load_config = function(module)
    local ok, error = pcall(require, user .. "." .. module)
    if not ok then
        table.insert(catched_errors, module)
        local fallback_cfg = user .. ".fallback." .. module
        print("- Error loading the module '" .. module .. "':\n  " .. error)
        print("  Loading fallback config file: '" .. fallback_cfg .. "'\n")
        require(fallback_cfg)
    end
end

-- Helper function to open config files when errors are detected.
local detected_errors = function(errors)
    if #errors == 0 then
        return false
    end
    if vim.fn.input("Open offending files for editing? (y/n): ") == "y" then
        print(" "); print("Opening files...")
        local config_path = "~/.config/nvim/lua/" .. user
        for _, module in pairs(errors) do
            vim.cmd("edit " .. config_path .. "/" .. module .. ".lua")
        end
    end
    return true
end
-------------------------------------------------------------------------------

-- Load the config modules (globals expected first)
load_config("globals")
load_config("disable-builtin")
load_config("settings")
load_config("mappings")
if not detected_errors(catched_errors) then
    require(user .. ".plugins")
end