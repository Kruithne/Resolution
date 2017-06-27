--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	UI.lua - Contains functions responsible for rendering the addon UI.
]]--

do
	local _R = Resolution; -- Reference to addon container.
	local _K = _R.refKrutilities; -- Reference to Krutilities instance.

	local min = math.min;
	local max = math.max;
	local ceil = math.ceil;

	--[[
		Resolution.ShowMainFrame
		Show the main frame, constructing if it needed.

			self - Reference to Resolution.
	]]--
	_R.ShowMainFrame = function(self)
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
		end

		self.frameMain:Show();
	end

	--[[
		Resolution.HideMainFrame
		Hides the main frame. If the add-on is loading, loading will be cancelled.

			self - Reference to Resolution.
	]]--
	_R.HideMainFrame = function(self)
		if self.frameMain then
			self.frameMain:Hide();
		end
	end

	--[[
		Resolution.ShowLoadFrame
		Show the loading frame, constructing it if needed.

			self - Reference to Resolution.
	]]--
	_R.ShowLoadFrame = function(self)
		if not self.loadFrame then
			-- Shared values for the loading models.
			local loadModelMixin = {
				type = "PlayerModel",
				width = 300,
				height = 400,
				facing = 4.6646,
				animation = 5
			};

			self.loadFrame = self.frameMain:SpawnFrame({
				injectSelf = "loadFrame",
				subLevel = 6,
				points = {
					{ point = "TOPLEFT", relativePoint = "TOPLEFT", y = -3, x = 3 },
					{ point = "BOTTOMRIGHT", relativePoint = "BOTTOMRIGHT", y = 3, x = -3 }
				},
				textures = {
					{
						texture = self.ARTWORK_PATH .. "UI-LoadingBackground",
						injectSelf = "backdrop",
						texCoord = {0, 1, 0, 1},
						setAllPoints = true,
						tileX = true,
					},
					{
						texture = self.ARTWORK_PATH .. "UI-ResolutionLogo",
						points = { point = "CENTER", y = 170 },
						injectSelf = "logo",
						size = {512, 256},
						blendMode = "ADD",
						subLevel = 7,
					}
				},
				scripts = {
					OnUpdate = self.LoadFrame_OnUpdate
				},
				frames = {
					{ displayID = 68845, mixin = loadModelMixin, points = { point = "CENTER", y = -120, x = 150 } },
					{ displayID = 15398, mixin = loadModelMixin, points = { point = "CENTER", y = -120, x = -150 } }
				}
			});

			self.loadBar = self:CreateProgressBar(self.loadFrame, "TestProgressBar", {
				points = { point = "TOP", y = -135 }
			});
		end

		self.loadFrame:Show();
	end

	--[[
		Resolution.HideLoadFrame
		Hides the loading frame.
	]]--
	_R.HideLoadFrame = function(self)
		if self.loadFrame then
			self.loadFrame:Hide();
		end
	end

	--[[
		Resolution.LoadFrame_OnUpdate
		Invoked on every frame the LoadFrame is rendered.

			self - Reference to the loading frame.
			elapsed - Seconds elapsed since last frame.
	]]--
	_R.LoadFrame_OnUpdate = function(self, elapsed)
		local changeBack = 0.8 * elapsed;
		local backL, _, _, _, backR = self.backdrop:GetTexCoord();
		
		backL = backL - changeBack;
		backR = backR - changeBack;
		
		-- Prevent overflowing texture bounds.
		if backL <= -1 then
			local excess = ceil(backL);
			backL = backL - excess;
			backR = backR - excess;
		end
		
		self.backdrop:SetTexCoord(backL, backR, 0, 1);
	end

	--[[
		Resolution.CreateProgressBar
		Construct a progress bar region.

			self - Reference to Resolution.
	]]--
	_R.CreateProgressBar = function(self, parent, name, data)
		-- ToDo: SetBarColor

		local bar = parent:SpawnFrame({
			width = 400, height = 30,
			name = name,
			points = data.points,
			backdrop = self.DesignKits.GENERIC_FRAME_STYLE,
			backdropColor = self.Palette.BarBackdrop,
			backdropBorderColor = self.Palette.BarGeneric,
			frames = {
				backdrop = self.DesignKits.FLAT_FRAME_STYLE,
				backdropColor = self.Palette.BarGeneric,
				injectSelf = "BarFill",
				points = {
					{ point = "TOP", y = -2 },
					{ point = "BOTTOM", y = 2 },
					{ point = "LEFT", x = 2 },
					{ point = "RIGHT", x = -400 }
				},
				texts = {
					points = { point = "CENTER", relativeTo = name },
					inherit = "GameFontNormal",
					color = self.Palette.White,
					injectSelf = "Text",
				},
			},
			data = {
				SetBarProgress = self.ProgressBar_SetBarProgress,
				SetBarText = self.ProgressBar_SetBarText,
				SetBarColor = self.ProgressBar_SetBarColor
			}
		});

		-- Support pre-programmed values for bar-related calls.
		if data.progress then bar:SetBarProgress(data.progress); end
		if data.color then bar:SetBarColor(data.color); end
		if data.text then bar:SetBarText(data.text); end

		return bar;
	end

	--[[
		Resolution.ProgressBar_SetBarProgress
		Region-linked function used to set the visual progress of a bar.

			self - Bar region.
			value - Percentage value between 0-100.
	]]--
	_R.ProgressBar_SetBarProgress = function(self, value)
		-- Ensure value is between 0-100, reversed, and scaled to 0-1.
		value = (100 - max(0, min(100, value))) / 100;
		self.BarFill:SetPoint("RIGHT", (-398 * value) - 2, 0);
	end

	--[[
		Resolution.ProgressBar_SetBarColor
		Region-linked function used to set the color of a progress bar.

			self - Bar region.
			color - Reference to a color object.
	]]--
	_R.ProgressBar_SetBarColor = function(self, color)
		self.BarFill:SetBackdropColor(color);
		self:SetBackdropBorderColor(color);
	end

	--[[
		Resolution.ProgressBar_SetBarText
		Region-linked function used to set the ext of the bar.

			self - Bar region.
			text - Text to display on the bar.
	]]--
	_R.ProgressBar_SetBarText = function(self, text)
		self.BarFill.Text:SetText(text);
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
			subLevel = 7,
			pushedTexture = self.ARTWORK_PATH .. icon .. "-Pushed",
			highlightTexture = self.ARTWORK_PATH .. "UI-Button-Highlight",
			normalTexture = self.ARTWORK_PATH .. icon
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