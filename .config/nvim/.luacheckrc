-- luacheck: globals vim Snacks
-- Luacheck configuration for Neovim

-- Allow globals
globals = { "vim", "Snacks" }

-- Disable line length check
max_line_length = false

-- Allow reading globals
read_globals = { "vim", "Snacks" }

-- Ignore specific warnings
ignore = {
    "631", -- Line is too long
    "212", -- Unused argument
    "213", -- Unused loop variable
    "122", -- Shadowing variable
    "542", -- Unused variable (cargo_check in lazy.lua)
}

