--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	Constants.lua - Constant/pre-compiled values for the add-on.
]]--

do
	-- [[ Local Optimization ]] --
	local _R = Resolution;
	local CreateColor = CreateColor;

	-- [[ Pattern Matching Expressions ]] --
	_R.Patterns = {
		Palette = "{(.-)}",
	};

	-- [[ Pre-constructed Colour Objects ]] --
	_R.Palette = {
		Backdrop = CreateColor(0, 0, 0, 0.85),
		Prefix = CreateColor(0.77, 0.12, 0.23, 1),
		Normal = CreateColor(0.25, 0.78, 0.92, 1),
		Highlight = CreateColor(0.67, 0.83, 0.45),
		BarGeneric = CreateColor(0.25, 0.65, 0.95, 1),
		BarBackdrop = CreateColor(1, 1, 1, 0.1),
		White = CreateColor(1, 1, 1, 1),
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
		},
		["FLAT_FRAME_STYLE"] = {
			tile = true,
			tileSize = 32,
			bgFile = "TILESET\\GENERIC\\Grey"
		}
	};
end