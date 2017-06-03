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
		Resolution.CreateCornerButton
		Create an automatically positoned utility button (top-right).

			self - Reference to Resolution.
			name - Frame name, used for debugging/idenity purposes.
			icon - Artwork file to use for this button.
			handler - Callback function to hook to this button.
	]]--
	_R.CreateCornerButton = function(self, name, icon, handler)
		local spawnData = {
			size = 32,
			name = name,
			type = "BUTTON",
			scripts = { OnClick = handler },
			pushedTexture = "Interface\\AddOns\\Resolution\\Artwork\\" .. icon .. "-Pushed",
			highlightTexture = "Interface\\AddOns\\Resolution\\Artwork\\UI-Button-Highlight",
			normalTexture = "Interface\\AddOns\\Resolution\\Artwork\\" .. icon
		};

		if self.lastCornerButton then
			-- Anchor to the last button that was spawned.
			spawnData.points = { point = "RIGHT", relativeTo = self.lastCornerButton, relativePoint = "LEFT", x = 5 };
		else
			-- Anchor to the main frame itself.
			spawnData.points = { point = "TOPRIGHT", x = -5, y = -5 }
		end

		-- Keep track of the last button we spawned to assist with positioning.
		self.lastCornerButton = self.frameMain:SpawnFrame(spawnData);
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