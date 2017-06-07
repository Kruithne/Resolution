--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	Core.lua - Core add-on core/functions.
]]--

do
	local _R = Resolution; -- Reference to addon container.
	local _K = GetKrutilities(1.7); -- Reference to Krutilities instance.

	-- [[ Register Event Hooks ]] --
	_K.EventHandler(_R, {
		["ADDON_LOADED"] = "OnAddonLoaded"
	});

	-- [[ Register Addon Commands ]] --
	_K.CommandHandler(_R, {
		["RESOLUTION"] = {
			commands = { "/resolution" },
			handler = "OnChatCommand"
		}
	});

	--[[
		Resolution.Print
		Output a message into chat, formatted for this add-on.

			self - Reference to Resolution.
			message - String to print to the chat.
	]]--
	_R.Print = function(self, message)
		message = self.Palette.CHAT_NORMAL_COLOR:WrapTextInColorCode(message);
		DEFAULT_CHAT_FRAME:AddMessage(self.CHAT_PREFIX:format(message));
	end

	--[[
		Resolution.Open
		Open the main panel of the add-on.

			self - Reference to Resolution.
	]]--
	_R.Open = function(self)
		if not self.frameMain then
			-- Generate the main UI frame.
			self.frameMain = _K:Frame({
				width = 900, height = 500,
				strata = "FULLSCREEN",
				points = {point = "CENTER"},
				name = "ResolutionFrame",
				backdrop = self.DesignKits.GENERIC_FRAME_STYLE,
				backdropColor = self.Palette.MAIN_BACKDROP_COLOR,
				backdropBorderColor = self.Palette.MAIN_BACKDROP_COLOR
			});

			-- Create utility buttons, these will render from right to left.
			self:CreateCornerButton("$parentCloseButton", "UI-CloseButton", self.OnCloseButtonClicked);
			self:CreateCornerButton("$parentSettingsButton", "UI-SettingsButton", self.OnSettingsButtonClicked);
		end

		self.frameMain:Show();
	end

	--[[
		Resolution.Close
		Close the main panel of the add-on.

			self - Reference to Resolution.
	]]--
	_R.Close = function(self)
		if self.frameMain then
			self.frameMain:Hide();
		end
	end
end