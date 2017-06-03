--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	EventHandling.lua - Contains functions responsible for handling events.
]]--

do
	local _R = Resolution;

	--[[
		Resolution.OnLoad
		Invoked when this add-on is loaded.

			self - Reference to Resolution
	]]--
	_R.OnLoad = function(self)
		self:Open();

		-- Cache chat prefix.
		local addonName = self.CHAT_HIGHLIGHT_COLOR:WrapTextInColorCode(self.ADDON_NAME);
		self.CHAT_PREFIX = self.CHAT_PREFIX:format(addonName);

		local version = GetAddOnMetadata(self.ADDON_NAME, "Version");
		self:Print(version .. " loaded!");
	end

	--[[
		Resolution.OnAddonLoaded
		Invoked when an add-on is loaded.

			self - Reference to Resolution.
			addonName - Name of the add-on which loaded.
	]]--
	_R.OnAddonLoaded = function(self, addonName)
		if addonName == _R.ADDON_NAME then
			self:OnLoad();
		end
	end

	--[[
		Resolution.OnCloseButtonClicked
		Invoked when the close utility button is pressed.

			self - Reference to the button that was pressed.
	]]--
	_R.OnCloseButtonClicked = function(self)
		_R:Close();
	end

	--[[
		Resolution.OnSettingsButtonClicked
		Invoked when the settings utility button is clicked.

			self - Reference to the button that was pressed.
	]]--
	_R.OnSettingsButtonClicked = function(self)
		_R:Print("DEBUG: Settings button clicked!");
	end
end