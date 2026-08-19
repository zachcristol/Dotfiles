-- WezTerm configuration
-- Rose Pine Moon colorscheme, JetBrains Mono Nerd Font, transparent + blurred window

local wezterm = require("wezterm")
local config  = wezterm.config_builder()

-- ── Font ──────────────────────────────────────────────────────────────────────
config.font      = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 15

-- ── Colorscheme ───────────────────────────────────────────────────────────────
config.color_scheme = "rose-pine-moon"

-- ── Window appearance ─────────────────────────────────────────────────────────
-- Transparent background with macOS blur
config.window_background_opacity    = 0.92
config.macos_window_background_blur = 20

-- Remove the native window title bar; keep resize handles
config.window_decorations = "RESIZE"

-- Subtle padding inside the window
config.window_padding = {
  left   = 12,
  right  = 12,
  top    = 8,
  bottom = 8,
}

-- ── Tab bar ───────────────────────────────────────────────────────────────────
-- Hide when only one tab is open; the tab bar appears automatically with 2+
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar            = false   -- simpler tab bar that fits the Rose Pine aesthetic

-- ── Cursor ────────────────────────────────────────────────────────────────────
config.default_cursor_style         = "BlinkingBar"
config.cursor_blink_rate            = 500

-- ── Scrollback ────────────────────────────────────────────────────────────────
config.scrollback_lines = 10000

-- ── Bell ─────────────────────────────────────────────────────────────────────
config.audible_bell = "Disabled"

return config
