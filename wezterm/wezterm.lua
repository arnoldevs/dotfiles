local wezterm = require("wezterm")

local config = {}

config.audible_bell = "SystemBeep"
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 11
config.window_background_opacity = 0.90
config.warn_about_missing_glyphs = false
config.enable_scroll_bar = true
config.min_scroll_bar_height = "2cell"
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"


function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		config.colors = {
			scrollbar_thumb = "504945",
		}
		config.window_frame = {
			active_titlebar_bg = "#282828",
			inactive_titlebar_bg = "282828",
		}
		return "GruvboxDark"
	else
		config.colors = {
			scrollbar_thumb = "#d5c4a1",
		}
		config.window_frame = {
			active_titlebar_bg = "#fbf1c7",
			inactive_titlebar_bg = "#fbf1c7",
		}
		return "GruvboxLight"
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())

-- The art is a bit too bright and colorful to be useful as a backdrop
-- for text, so we're going to dim it down to 10% of its normal brightness
local dimmer = { brightness = 0.1 }

-- get the Wezterm configuration directory route
local config_dir = wezterm.config_dir

config.background = {
	-- This is the deepest/back-most layer. It will be rendered first
	{
		source = {
			File = config_dir .. "/alien_ship_bg/backgrounds/spaceship_bg_1.png",
		},
		-- The texture tiles vertically but not horizontally.
		-- When we repeat it, mirror it so that it appears "more seamless".
		-- An alternative to this is to set `width = "100%"` and have
		-- it stretch across the display
		repeat_x = "Mirror",
		hsb = dimmer,
		-- When the viewport scrolls, move this layer 10% of the number of
		-- pixels moved by the main viewport. This makes it appear to be
		-- further behind the text.
		attachment = { Parallax = 0.1 },
	},
	-- Subsequent layers are rendered over the top of each other
	{
		source = {
			File = config_dir .. "/alien_ship_bg/overlays/overlay_1_spines.png",
		},
		width = "100%",
		repeat_x = "NoRepeat",

		-- position the spins starting at the bottom, and repeating every
		-- two screens.
		vertical_align = "Bottom",
		repeat_y_size = "200%",
		hsb = dimmer,

		-- The parallax factor is higher than the background layer, so this
		-- one will appear to be closer when we scroll
		attachment = { Parallax = 0.2 },
	},
	{
		source = {
			File = config_dir .. "/alien_ship_bg/overlays/overlay_2_alienball.png",
		},
		width = "100%",
		repeat_x = "NoRepeat",

		-- start at 10% of the screen and repeat every 2 screens
		vertical_offset = "10%",
		repeat_y_size = "200%",
		hsb = dimmer,
		attachment = { Parallax = 0.3 },
	},
	{
		source = {
			File = config_dir .. "/alien_ship_bg/overlays/overlay_3_lobster.png",
		},
		width = "100%",
		repeat_x = "NoRepeat",

		vertical_offset = "30%",
		repeat_y_size = "200%",
		hsb = dimmer,
		attachment = { Parallax = 0.4 },
	},
	{
		source = {
			File = config_dir .. "/alien_ship_bg/overlays/overlay_4_spiderlegs.png",
		},
		width = "100%",
		repeat_x = "NoRepeat",

		vertical_offset = "50%",
		repeat_y_size = "150%",
		hsb = dimmer,
		attachment = { Parallax = 0.5 },
	},
}
return config
