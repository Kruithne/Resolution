--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	UI.lua - Contains functions responsible for rendering the addon UI.
]]--

do
	local _R = Resolution;

	--[[
		Resolution.InitializeInterface
		Construct the foundation interface and begin loading.

			self - Reference to Resolution.
	]]--
	_R.InitializeInterface = function(self)
		if not self.frameMain then
			-- Generate the main UI frame.
			self.frameMain = _K:Frame({
				width = 900, height = 500,
				strata = "FULLSCREEN",
				points = {point = "CENTER"},
				name = "ResolutionFrame",
				backdrop = self.DesignKits.GENERIC_FRAME_STYLE,
				backdropColor = self.Palette.Backdrop,
				backdropBorderColor = self.Palette.Backdrop
			});

			-- Create utility buttons, these will render from right to left.
			self:CreateCornerButton("$parentCloseButton", "UI-CloseButton", self.OnCloseButtonClicked);
			--self:CreateCornerButton("$parentSettingsButton", "UI-SettingsButton", self.OnSettingsButtonClicked);

			self.frameMain:Show();
		end

		-- Initiate the loading process.
		self:BeginLoading();
	end

	--[[
		Resolution.BeginLoading
		Initiate the loading process.

			self - Reference to Resolution.
	]]--
	_R.BeginLoading = function(self)
		-- ToDo: Implement.
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
end