--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	Resolution.lua - Core add-on core/functions.
]]--

do
	-- [[ Local Optimization & Addon Setup ]] --
	Resolution = {
		RoutePool = {}, -- Contains references to all lookup pools.
	};

	local _R = Resolution; -- Reference to addon container.
	local _K = Krutilities; -- Reference to Krutilities instance.

	-- [[ Constant Route Look-up ]] --
	setmetatable(_R, {
		__index = function(t, k)
			for i = 1, #t.RoutePool do
				local node = t.RoutePool[key];
				if node then return node; end
			end
		end
	});

	-- [[ Event Handler ]] --
	_K.EventHandler(_R, {
		["ADDON_LOADED"] = "OnAddonLoaded"
	});

	--[[
		Resolution.Print
		Output a message into chat, formatted for this add-on.

			self - Reference to Resolution.
			message - String to print to the chat.
	]]--
	_R.Print = function(self, message)
		message = self.CHAT_NORMAL_COLOR:WrapTextInColorCode(message);
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
				backdrop = self.GENERIC_FRAME_STYLE,
				backdropColor = self.MAIN_BACKDROP_COLOR,
				backdropBorderColor = self.MAIN_BACKDROP_COLOR
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