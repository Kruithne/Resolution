--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	Resolution.lua - Core add-on core/functions.
]]--

Resolution = {}; -- Primary add-on container.

-- Local Optimization
local _R = Resolution;
local _K = Krutilities;

-- Constants and Colors
_R.ADDON_NAME = "Resolution";
_R.MAIN_BACKDROP_COLOR = CreateColor(0, 0, 0, 0.85);
_R.GENERIC_FRAME_STYLE = { tile = true, tileSize = 32, edgeSize = 1, bgFile = "TILESET\\GENERIC\\Grey", edgeFile = "TILESET\\GENERIC\\Grey", insets = { left = 2, right = 2, top = 2, bottom = 2 }};

_R.Print = function(self, message)
	DEFAULT_CHAT_FRAME:AddMessage(message);
end

_R.OnAddonLoaded = function(self, addonName)
	if addonName == _R.ADDON_NAME then
		self:OnLoad();
	end
end

_R.CreateCornerButton = function(self, name, icon)
	local spawnData = {
		type = "BUTTON",
		size = 32,
		name = name,
		textures = {
			{
				setAllPoints = true,
				texture = "Interface\\AddOns\\Resolution\\Artwork\\" .. icon,
			},
			{
				setAllPoints = true,
				texture = "Interface\\AddOns\\Resolution\\Artwork\\UI-Button-Highlight",
				blendMode = "ADD",
				buttonTex = "HIGHLIGHT"
			},
			{
				setAllPoints = true,
				texture = "Interface\\AddOns\\Resolution\\Artwork\\" .. icon .. "-Pushed",
				buttonTex = "PUSHED"
			}
		}
	};

	if self.lastCornerButton then
		-- Anchor to the last button that was spawned.
		spawnData.points = { point = "RIGHT", relativeTo = self.lastCornerButton, relativePoint = "LEFT", x = 5 };
	else
		-- Anchor to the main frame itself.
		spawnData.points = { point = "TOPRIGHT", x = -5, y = -5 }
	end

	self.lastCornerButton = self.frameMain:SpawnFrame(spawnData);
end

_R.OnLoad = function(self)
	self.frameMain = _K:Frame({
		width = 900, height = 500,
		strata = "FULLSCREEN",
		points = {point = "CENTER"},
		name = "ResolutionFrame",
		backdrop = self.GENERIC_FRAME_STYLE,
		backdropColor = self.MAIN_BACKDROP_COLOR,
		backdropBorderColor = self.MAIN_BACKDROP_COLOR
	});

	-- These will render from right to left.
	self:CreateCornerButton("$parentCloseButton", "UI-CloseButton");
	self:CreateCornerButton("$parentSettingsButton", "UI-SettingsButton");

	self:Print("Loaded!");
end

-- Event Handler
_K.EventHandler(_R, {
	["ADDON_LOADED"] = "OnAddonLoaded"
});


--[[local testFrame = CreateFrame("FRAME", "ResolutionFrame", UIParent);
testFrame:SetPoint("CENTER", 0, 0);
testFrame:SetWidth(64);
testFrame:SetHeight(64);

local testTex = testFrame:CreateTexture();
testTex:SetTexture("Interface\\ICONS\\6BF_Retched_Blackrock");
testTex:SetMask("Interface\\COMMON\\icon-shadow");
testTex:SetAllPoints(testFrame);]]--