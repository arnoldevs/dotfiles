local wezterm = require("wezterm")

local config = {}

--[[ config.enable_scroll_bar = true
config.min_scroll_bar_height = "1cell"
config.warn_about_missing_glyphs = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Gnome"
config.audible_bell = "SystemBeep" ]]
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.window_background_opacity = 0.95

function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		--[[ config.colors = {
			scrollbar_thumb = "504945",
		} ]]
		config.window_frame = {
			active_titlebar_bg = "#282828",
			inactive_titlebar_bg = "282828",
		}
		return "GruvboxDark"
	else
		--[[ config.colors = {
			scrollbar_thumb = "#d5c4a1",
		} ]]
		config.window_frame = {
			active_titlebar_bg = "#fbf1c7",
			inactive_titlebar_bg = "#fbf1c7",
		}
		return "GruvboxLight"
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())

return config
