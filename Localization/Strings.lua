--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	Strings.lua - Default (English) localization strings.
]]--

do
	-- Below are the default, English strings used in the add-on.
	-- If no substitute is provided in the used localization, it will fallback to this.

	-- Note: Localization of specific collection strings is done in the ResolutionData add-on.

	Resolution.Strings = {
		["LOAD_PROMPT"] = "%s is enabled, type {Highlight}/resolution{Normal} to open.",
		["VERSION_FORMAT"] = "Successfully loaded version {Highlight}%s{Normal}!",

		["ERR_ADDON_LOAD"] = "Unable to load {Highlight}%s{Normal}, aborting!",

		["LOADING_TEXT_INIT"] = "Initializing, please wait...",
		["LOADING_TEXT_DATA"] = "Loading data...",
		["LOADING_TEXT_CHAR"] = "Checking character details...",
		["LOADING_TEXT_TOYS"] = "Checking toy collection...",

		["PLAYER_NO_GUILD"] = "No Guild",
	};
end