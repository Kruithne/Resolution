--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	Constants.lua - Static strings and other constants.
]]--

do
	-- [[ Local Optimization ]] --
	local _R = Resolution;
	local CreateColor = CreateColor;

	-- [[ Static Addon Strings ]] --
	_R.Strings = {
		["ADDON_NAME"] = "Resolution",
		["CHAT_PREFIX"] = "%s - %%s",
	};

	-- [[ Pre-constructed Colour Objects ]] --
	_R.Palette = {
		["MAIN_BACKDROP_COLOR"] = CreateColor(0, 0, 0, 0.85),
		["CHAT_HIGHLIGHT_COLOR"] = CreateColor(0.77, 0.12, 0.23, 1),
		["CHAT_NORMAL_COLOR"] = CreateColor(0.25, 0.78, 0.92, 1)
	};

	-- [[ Pre-constructed Frame Backdrops ]] --
	_R.DesignKits = {
		["GENERIC_FRAME_STYLE"] = {
			tile = true,
			edgeSize = 1,
			tileSize = 32,
			bgFile = "TILESET\\GENERIC\\Grey",
			edgeFile = "TILESET\\GENERIC\\Grey",
			insets = { left = 2, right = 2, top = 2, bottom = 2 }
		}
	};
end