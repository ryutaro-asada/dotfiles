local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Appearance
config.color_scheme = "GitHub Dark"
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"Hiragino Kaku Gothic ProN",
})
config.font_size = 14
-- Disable ligatures
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

-- Rendering
config.front_end = "WebGpu"
config.max_fps = 120
config.scrollback_lines = 10000

-- macOS input
config.use_ime = true
-- Let the IME see Ctrl keys so Ctrl+N/P can move through conversion candidates.
-- Downside: while the Japanese IME is on, it may swallow Ctrl combos it binds itself.
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"
-- Left Option sends Alt/Meta; right Option still types composed characters
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- Splits and tabs are handled by Herdr, so no leader key or extra bindings here.

return config
