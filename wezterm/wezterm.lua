local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.font =
  wezterm.font_with_fallback(
  {
    {family = "Input Mono Narrow", stretch = "Normal"},
    {family = "Hack Nerd Font", stretch = "Normal"}
  }
)

config.allow_square_glyphs_to_overflow_width = "Always"
config.treat_east_asian_ambiguous_width_as_wide = true

config.default_prog = {"zsh"}
config.use_fancy_tab_bar = false
config.font_size = 11
config.front_end = "WebGpu"
config.max_fps = 60
config.animation_fps = 60
config.colors = {
  foreground = "#c5c8c6",
  background = "#1d1f21",
  cursor_bg = "#c5c8c6",
  cursor_border = "#c5c8c6",
  cursor_fg = "#1d1f21",
  selection_bg = "#373b41",
  selection_fg = "#c5c8c6",
  ansi = {
    "#282a2e", -- black
    "#a54242", -- red
    "#8c9440", -- green
    "#f79d1e", -- yellow
    "#5f819d", -- blue
    "#85678f", -- magenta
    "#049494", -- cyan
    "#707880" -- white
  },
  brights = {
    "#373b41", -- bright black
    "#cc6666", -- bright red
    "#b5bd68", -- bright green
    "#f7c530", -- bright yellow
    "#81a2be", -- bright blue
    "#b294bb", -- bright magenta
    "#66fbfb", -- bright cyan
    "#c5c8c6" -- bright white
  }
}

return config
