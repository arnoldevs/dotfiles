local wezterm = require("wezterm")
local config = {}

-- =====================================================================
-- General & Appearance Settings
-- =====================================================================
config.audible_bell = "SystemBeep"
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 11
config.window_background_opacity = 0.88
config.enable_scroll_bar = true
config.min_scroll_bar_height = "2cell"
config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 800
config.window_close_confirmation = "NeverPrompt"

-- =====================================================================
-- Dynamic Color Scheme & Environment Context Handler
-- =====================================================================
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function apply_theme_context(appearance)
	local config_dir = wezterm.config_dir
	local dimmer = { brightness = 0.1 }

	if appearance:find("Dark") then
		config.color_scheme = "GruvboxDark"
		config.colors = {
			scrollbar_thumb = "#504945",
			split = "#3c3836",
			cursor_bg = "#ebdbb2",
			cursor_border = "#ebdbb2",
			tab_bar = {
				background = "#1d2021",
				active_tab = { bg_color = "#282828", fg_color = "#ebdbb2" },
				inactive_tab = { bg_color = "#1d2021", fg_color = "#928374" },
			},
		}
		config.window_frame = {
			active_titlebar_bg = "#282828",
			inactive_titlebar_bg = "#282828",
		}
		config.background = {
			{ source = { File = config_dir .. "/alien_ship_bg/backgrounds/spaceship_bg_1.png" }, repeat_x = "Mirror", hsb = dimmer, attachment = { Parallax = 0.1 } },
			{ source = { File = config_dir .. "/alien_ship_bg/overlays/overlay_1_spines.png" }, width = "100%", repeat_x = "NoRepeat", vertical_align = "Bottom", repeat_y_size = "200%", hsb = dimmer, attachment = { Parallax = 0.2 } },
			{ source = { File = config_dir .. "/alien_ship_bg/overlays/overlay_2_alienball.png" }, width = "100%", repeat_x = "NoRepeat", vertical_offset = "10%", repeat_y_size = "200%", hsb = dimmer, attachment = { Parallax = 0.3 } },
			{ source = { File = config_dir .. "/alien_ship_bg/overlays/overlay_3_lobster.png" }, width = "100%", repeat_x = "NoRepeat", vertical_offset = "30%", repeat_y_size = "200%", hsb = dimmer, attachment = { Parallax = 0.4 } },
			{ source = { File = config_dir .. "/alien_ship_bg/overlays/overlay_4_spiderlegs.png" }, width = "100%", repeat_x = "NoRepeat", vertical_offset = "50%", repeat_y_size = "150%", hsb = dimmer, attachment = { Parallax = 0.5 } },
		}
		config.set_environment_variables = {
			WEZTERM_THEME_MODE = "dark",
		}
	else
		config.color_scheme = "GruvboxLight"
		config.colors = {
			scrollbar_thumb = "#bdae93",
			split = "#d5c4a1",
			cursor_bg = "#3c3836",
			cursor_border = "#3c3836",
			tab_bar = {
				background = "#ebdbb2",
				active_tab = { bg_color = "#fbf1c7", fg_color = "#3c3836" },
				inactive_tab = { bg_color = "#ebdbb2", fg_color = "#7c6f64" },
			},
		}
		config.window_frame = {
			active_titlebar_bg = "#fbf1c7",
			inactive_titlebar_bg = "#fbf1c7",
		}
		config.background = nil
		
		config.set_environment_variables = {
			WEZTERM_THEME_MODE = "light",
		}
	end
end

apply_theme_context(get_appearance())

return config
