--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	UI.lua - Contains functions responsible for rendering the addon UI.
]]--

do
	-- [[ Local Optimization ]] --
	local _R = Resolution; -- Reference to addon container.
	local _K = _R.refKrutilities; -- Reference to Krutilities instance.

	local min = math.min;
	local max = math.max;
	local ceil = math.ceil;
	local t_remove = table.remove;
	local t_insert = table.insert;

	-- [[ Design Constants ]] --
	local GRID_ICON_MARGIN = 15; -- Distance between grid frame sections.
	local GRID_ICON_SIZE = 36; -- Width/height of the grid frame icon regions.

	-- This is the mark-up used for rendering icons. Given the volume of 
	-- these rendered, we re-use the same table to avoid excessive garbage.
	local markup_gridIcon = {
		size = GRID_ICON_SIZE,
		textures = {
			{
				-- Base shadow.
				subLevel = 5,
				setAllPoints = true,
				texture = _R.ARTWORK_PATH .. "UI-GridIcon",
				texCoord = {0.71875, 1, 0, 0.5625},
			},
			{
				-- Texture
				texture = "Interface\\ICONS\\inv_misc_questionmark",
				subLevel = 6,
				desaturate = true,
				injectSelf = "Icon",
				points = {
					{ point = "TOPLEFT", x = 4, y = -4 },
					{ point = "BOTTOMRIGHT", x = -4, y = 4 }
				}
			},
			{
				-- Overlay
				texture = _R.ARTWORK_PATH .. "UI-GridIcon",
				subLevel = 7,
				setAllPoints = true,
				injectSelf = "Overlay",
				texCoord = {0, 0.28125, 0, 0.5625},
				color = {1, 0, 0}
			}
		}
	};

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

	--[[
		Resolution.CreateGridGrame
		Create a grid frame.

			self - Reference to Resolution
	]]--
	_R.CreateGridFrame = function(self)
		return self.frameMain:SpawnFrame({
			points = {
				{ point = "TOPLEFT", x = 20, y = -40 },
				{ point = "BOTTOMRIGHT", x = -20, y = 20 }
			},
			textures = {
				texture = "InvalidTexturePath",
				setAllPoints = true
			},
			data = {
				_sections = {}, -- References to each section in this grid.
				_dirtySections = {}, -- Section garbage is stored per-grid.
				_dirtyIcons = {}, -- Icon garbage is stored per-grid.

				-- Helper functions.
				CreateSection = self.GridFrame_CreateSection,
			}
		});
	end

	--[[
		Resolution.GridFrame_CreateSection
		Creates a new grid frame section.

			self - Reference to the grid frame region.
	]]--
	_R.GridFrame_CreateSection = function(self, name)
		local section = nil;
		if #self._dirtySections > 0 then
			-- Grab an old section out of the garbage.
			section = t_remove(self._dirtySections, 1);
		else
			-- Create a new shiny text object.
			section = self:SpawnFrame({
				size = 1,
				texts = {
					text = name,
					injectSelf = "Text",
					points = { point = "TOPLEFT" },
					inherit = "Game11Font_o1"
				},
				data = {
					_icons = {}, -- References to each icon in this section.
				}
			});
		end

		-- Anchoring
		local previous = self._previousSection;
		if previous then
			-- Previous section exists, anchor to it.
			section:SetPoint("LEFT", previous, "RIGHT");
		else
			-- This is the first section, default anchor.
			section:SetPoint("TOPLEFT", self, "TOPLEFT");
		end

		self._previousSection = section; -- Set reference as previous entry.
		t_insert(self._sections, section); -- Store reference in section table.

		return section;
	end

	--[[
		Resolution.GridFrame_AddIcon
		Adds an icon to the grid frame section.

			self - Reference to the section region.
	]]--
	_R.GridFrame_AddIcon = function(self, section)
		local grid = section:GetParent();
		local icon = nil;

		if #grid._dirtyIcons > 0 then
			-- Grab an old icon from the grid garbage.
			icon = t_remove(grid._dirtyIcons, 1);
		else
			-- Create a new shiny icon.
			icon = section:SpawnFrame(markup_gridIcon);
		end

		-- Anchoring
		local previous = section._previousIcon;
		if previous then
			-- Previous icon exists, anchor to it.
			icon:SetPoint("LEFT", previous, "RIGHT");
		else
			-- No previous icon exists, anchor to section.
			icon:SetPoint("TOPLEFT", section, "TOPLEFT", 5, -GRID_ICON_MARGIN);
		end

		section._previousIcon = icon; -- Set reference as previous entry.
		t_insert(section._icons, icon); -- Store reference in icon table.

		-- Recalculate frame sizing.
		section:SetWidth((#section._icons * GRID_ICON_SIZE) + GRID_ICON_MARGIN);

		return icon;
	end
end