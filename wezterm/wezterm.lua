-- return {
-- 	-- initial_cols = 150,
-- 	-- initial_rows = 50,
-- 	font_size = 16.0,
-- 	-- window_background_opacity = 0.97,
-- 	-- macos_window_background_blur = 99,
-- 	-- color_scheme = "tokyonight",
-- 	color_scheme = "Ayu Light",
-- 	-- window_decorations = "MACOS_FORCE_DISABLE_SHADOW|RESIZE",
-- 	-- enable_tab_bar = false,
-- 	window_decorations = "RESIZE",
-- 	max_fps = 120,
-- }

local wezterm = require("wezterm")
local config = {
	font_size = 14.0,
	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	-- max_fps = 120,
	initial_cols = 150,
	initial_rows = 50,
}

config.window_frame = {
	active_titlebar_bg = "#7e56c2",
	inactive_titlebar_bg = "#a572ff",
}

config.colors = {
	background = "white",
	tab_bar = {
		background = "#fafafa",
		inactive_tab_edge = "#7e56c2",
	},
}

config.color_scheme = "Ayu Light"

return config
