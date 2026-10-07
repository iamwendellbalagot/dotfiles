local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13.0
config.line_height = 1.1
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" } -- ligatures

-- Cursor
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Window
config.window_padding = { left = 8, right = 8, top = 6, bottom = 6 }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"
config.adjust_window_size_when_changing_font_size = false

-- macOS: Option as Alt, sensible key behavior
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

-- Keybindings (mirrors the tmux binds)
config.keys = {
	{ key = "|", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "CMD", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "LeftArrow", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Down") },
}

-- Scrollback
config.scrollback_lines = 10000

-- Cursor gradient in pane borders
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.8 }

return config
