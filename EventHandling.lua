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
		self.CHAT_PREFIX = self:FormatColours(self.CHAT_PREFIX:format(self.ADDON_NAME));

		local versionString = GetAddOnMetadata(self.ADDON_NAME, "Version");
		local version, revision = strsplit(".", versionString);

		self:Print(self.VERSION_FORMAT:format(version, revision));
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