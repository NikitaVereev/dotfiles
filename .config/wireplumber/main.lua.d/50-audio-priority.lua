-- Universal audio priority rules for any hardware

-- Built-in speakers (Ryzen/Intel/AMD)
table.insert(alsa_monitor.rules, {
	matches = {
		{
			{ "node.name", "matches", "~alsa_output.*analog-stereo$" },
		},
	},
	apply_properties = {
		["priority.session"] = 1000,
	},
})

-- Bluetooth headphones (any device)
table.insert(alsa_monitor.rules, {
	matches = {
		{
			{ "node.name", "matches", "^bluez_output.*" },
		},
	},
	apply_properties = {
		["priority.session"] = 3000,
		["node.autoconnect"] = true,
	},
})

-- USB speakers/microphones (any device)
table.insert(alsa_monitor.rules, {
	matches = {
		{
			{ "node.name", "matches", "~alsa_output.usb-.*" },
		},
	},
	apply_properties = {
		["priority.session"] = 2000,
	},
})
