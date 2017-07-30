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

	-- [[ Static Non-Localized Strings ]] --
	_R.ADDON_NAME = "Resolution";
	_R.ARTWORK_PATH = "Interface\\AddOns\\Resolution\\Artwork\\";
	_R.CHAT_PREFIX = "{Normal}<{Prefix}%s{Normal}> %%s";
	_R.GUILD_TAG = "<%s>";
	_R.PLAYER_REALM_FORMAT = "%s - %s";

	-- [[ Common Strings ]] --
	_R.ANCHOR_TOP = "TOP";
	_R.ANCHOR_TOPLEFT = "TOPLEFT";
	_R.ANCHOR_TOPRIGHT = "TOPRIGHT";
	_R.ANCHOR_BOTTOM = "BOTTOM";
	_R.ANCHOR_BOTTOMRIGHT = "BOTTOMRIGHT";
	_R.ANCHOR_BOTTOMLEFT = "BOTTOMLEFT";
	_R.ANCHOR_LEFT = "LEFT";
	_R.ANCHOR_RIGHT = "RIGHT";
	_R.ANCHOR_CENTER = "CENTER";

	_R.UNIT_PLAYER = "player";

	-- [[ Pattern Matching Expressions ]] --
	_R.Patterns = {
		Palette = "{(.-)}",
	};

	-- [[ Collection Types ]] --
	_R.COLLECTION_TYPES = {
		["Toys"] = { header = _R.COLLECTION_TOYS, icon = "INV_Misc_Toy_10" },
		["Mounts"] = { header = _R.COLLECTION_MOUNTS, icon = "Ability_Mount_SpectralGryphon" },
		["Heirlooms"] = { header = _R.COLLECTION_HEIRLOOMS, icon = "INV_Icon_HeirloomToken_Armor01" },
		["Appearances"] = { header = _R.COLLECTION_APPEARANCES, icon = "Trade_Archaeology_QueenAzshara DressingGown" },
		["Pets"] = { header = _R.COLLECTION_PETS, icon = "INV_StBernardDogPet" },
		["Titles"] = { header = _R.COLLECTION_TITLES, icon = "ACHIEVEMENT_GUILDPERK_HONORABLEMENTION_RANK2" },
		["Achievements"] = { header = _R.COLLECTION_ACHIEVEMENTS, icon = "Achievement_Quests_Completed_08" },
	};

	-- [[ Pre-constructed Colour Objects ]] --
	_R.Palette = {
		Backdrop = CreateColor(0, 0, 0, 0.85),
		EtchedBorder = CreateColor(1, 1, 1, 0.3),
		Prefix = CreateColor(0.77, 0.12, 0.23, 1),
		Normal = CreateColor(0.25, 0.78, 0.92, 1),
		Highlight = CreateColor(0.67, 0.83, 0.45),
		BarGeneric = CreateColor(0.12, 0.32, 0.47, 1),
		BarBackdrop = CreateColor(1, 1, 1, 0.1),
		White = CreateColor(1, 1, 1, 1),
		Transparent = CreateColor(0, 0, 0, 0),
		Disabled = CreateColor(0.63, 0.63, 0.63),
		OverviewOrange = CreateColor(0.97, 0.55, 0.16, 1);
	};

	local WHITE_TEXTURE = _R.ARTWORK_PATH .. "UI-White";

	-- [[ Pre-constructed Frame Backdrops ]] --
	_R.DesignKits = {
		["GENERIC_FRAME_STYLE"] = {
			tile = true,
			edgeSize = 1,
			tileSize = 32,
			bgFile = WHITE_TEXTURE,
			edgeFile = WHITE_TEXTURE,
			insets = { left = 2, right = 2, top = 2, bottom = 2 }
		},
		["ETCHED_FRAME_STYLE"] = {
			tile = true,
			edgeSize = 1,
			tileSize = 32,
			bgFile = WHITE_TEXTURE,
			edgeFile = WHITE_TEXTURE,
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		},
		["FLAT_FRAME_STYLE"] = {
			tile = true,
			tileSize = 32,
			bgFile = WHITE_TEXTURE
		}
	};
end
