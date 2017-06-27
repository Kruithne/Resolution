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
		-- The first section of strings do not need to be localized.
		["ADDON_NAME"] = "Resolution",
		["ARTWORK_PATH"] = "Interface\\AddOns\\Resolution\\Artwork\\",
		["CHAT_PREFIX"] = "{Normal}<{Prefix}%s{Normal}> %%s",

		["VERSION_FORMAT"] = "Version {Highlight}%s {Normal}revison {Highlight}%s {Normal}loaded!",

		["LOADING_TEXT_INIT"] = "Initializing, please wait...",
		["LOADING_TEXT_DATA"] = "Loading data...",
		["LOADING_TEXT_TOYS"] = "Checking toy collection...",
	};
end