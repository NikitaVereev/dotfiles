-- Luacheck configuration for Neovim
globals = {
	"vim", -- Neovim global
}

max_line_length = false

read_globals = {
	"vim",
}

ignore = {
	"631", -- Line is too long (if you prefer longer lines)
	"212", -- Unused argument (common in callbacks)
	"213", -- Unused loop variable
	"122",
}

files["*_spec.lua"] = {
	std = "+busted",
}

self = false
