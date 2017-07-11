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
	local pairs = pairs;
	local ceil = math.ceil;
	local floor = math.floor;
	local mod = math.fmod;
	local t_remove = table.remove;
	local t_insert = table.insert;

	local UnitFactionGroup = UnitFactionGroup;
	local GetMaxPlayerLevel = GetMaxPlayerLevel;

	-- [[ Design Constants ]] --
	local GRID_SECTION_MARGIN = 15; -- Distance between grid frame sections.
	local GRID_SECTION_MARGIN_TOTAL = GRID_SECTION_MARGIN * 2; -- Total margin size for sections.
	local GRID_ICON_SIZE = 36; -- Width/height of the grid frame icon regions.
	local GRID_ROW_HEIGHT = 20; -- Height of a grid row, not including icon heights.

	-- [[ Local Strings ]] --
	local BACK_MODEL_PREFIX = "Interface\\Glues\\Models\\";
	local BACK_MODEL_ALLIANCE = "UI_Human\\UI_Human.m2";
	local BACK_MODEL_HORDE = "UI_Horde\\UI_Horde.m2";
	local BACK_MODEL_NEUTRAL = "UI_Pandaren\\UI_Pandaren.m2";
	local UNIT_FACTION_ALLIANCE = "Alliance";
	local UNIT_FACTION_HORDE = "Horde";
	local UNIT_PLAYER = "player";

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
				strata = "DIALOG",
				points = {point = "CENTER"},
				name = "ResolutionFrame",
			});

			-- Apply border overlay.
			self.frameMain:SpawnFrame({
				setAllPoints = true,
				injectSelf = "Border",
				backdrop = self.DesignKits.ETCHED_FRAME_STYLE,
				backdropColor = self.Palette.Transparent,
				backdropBorderColor = self.Palette.EtchedBorder
			});

			-- Apply frame shadow.
			self.frameMain:SpawnFrame({
				width = 924,
				height = 520,
				strata = "HIGH",
				injectSelf = "Shadow",
				textures = {
					texture = self.ARTWORK_PATH .. "UI-BackdropShadow",
					texCoord = {0, 0.90234375, 0, 0.51171875},
				}
			});

			-- Create utility buttons, these will render from right to left.
			self:CreateCornerButton("Close", "UI-CloseButton", self.OnCloseButtonClicked);
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

		self:HideUI();
	end

	--[[
		Resolution.ShowUI
		Show/construct the region containing all main UI components.
	]]--
	_R.ShowUI = function(self)
		if not self.frameInterface then
			self:CreateCornerButton("Settings", "UI-SettingsButton", self.OnSettingsButtonClicked);

			self.frameInterface = self.frameMain:SpawnFrame({
				setAllPoints = true,
				injectSelf = "Container",
				frames = {
					{
						type = "PlayerModel",
						injectSelf = "BackgroundModel",
						strata = "HIGH",
						points = {
							{ point = "TOPLEFT" },
							{ point = "BOTTOMRIGHT", x = -1 } -- Model over-clips by 1 pixel, for some reason.
						},
						scripts = {
							OnUpdate = function(self)
								-- Model camera needs to be set after the first frame.
								if not self.isCameraSet then
									if not self.isNotFirstFrame then
										self.isNotFirstFrame = true;
										return;
									end

									self:SetCamera(0);
									self.isCameraSet = true;
								end
							end
						}
					},
					{
						type = "PlayerModel",
						injectSelf = "PlayerModel",
						size = 400,
						points = { point = "CENTER", x = -17, y = -25 }
					}
				},
				textures = {
					{
						injectSelf = "ClassIcon",
						size = 90,
						points = { point = "TOPLEFT", x = 15, y = -15 }
					}
				}
			});

			-- Render class icons.
			self:RenderClassIcons();

			-- Set class icon for the current class.
			local _, className = UnitClass(UNIT_PLAYER);
			self.frameInterface.ClassIcon:SetAtlas("classhall-circle-" .. className);

			-- Set the player model to the actual player.
			self.frameInterface.PlayerModel:SetUnit(UNIT_PLAYER);
		end

		-- Background model needs to be reset every time.
		local model = self.frameInterface.BackgroundModel;
		model.isCameraSet = false;
		model.isNotFirstFrame = false;

		local modelPath = BACK_MODEL_NEUTRAL;
		local playerFaction = UnitFactionGroup(UNIT_PLAYER);

		if playerFaction == UNIT_FACTION_ALLIANCE then
			modelPath = BACK_MODEL_ALLIANCE;
		elseif playerFaction == UNIT_FACTION_HORDE then
			modelPath = BACK_MODEL_HORDE;
		end

		model:SetModel(BACK_MODEL_PREFIX .. modelPath);

		-- Show that which needs showing.
		self.frameInterface:Show();
		self.frameMain.ButtonSettings:Show();
	end

	--[[
		Resolution.CreateClassIcons
		Render the class icons onto the main UI frame.

			self - Reference to Resolution.

	]]--
	_R.RenderClassIcons = function(self)
		-- Construct icons if needed.
		if not self.classIcons then
			local icons = {}; -- Storage for texture references.
			local GetClassInfo = GetClassInfo; -- Local ref to func.
			local texturePrefix = "Interface\\ICONS\\ClassIcon_";
			local point = { point = "BOTTOMLEFT", x = 15, y = 15 };

			for i = 1, GetNumClasses() do
				local _, classTag, classID = GetClassInfo(i);
				local icon = self.frameInterface:SpawnTexture({
					texture = texturePrefix .. classTag,
					injectSelf = "ClassIcon" .. classID,
					size = 32,
					points = point
				});

				-- Update point position for the next icon.
				if i % 6 == 0 then
					-- Shift up a row.
					point.x = 15; -- Reset to spacing.
					point.y = point.y + 37; -- 32 (icon width) + 5 (spacing).
				else
					-- Shift over a position.
					point.x = point.x + 37; -- 32 (icon width) + 5 (spacing).
				end

				icons[classID] = icon; -- Store refrence to texture.
			end

			self.classIcons = icons;
		end

		-- Update icons.
		local classData = ResolutionDataCharacters;
		local maxLevel = GetMaxPlayerLevel();

		for classID, classIcon in pairs(self.classIcons) do
			local storedClass = classData[classID];
			local activated = storedClass and storedClass.level >= maxLevel;

			classIcon:SetAlpha(activated and 1 or 0.5);
			classIcon:SetDesaturated(not activated);
		end
	end

	--[[
		Resolution.HideUI
		Hide the region containing all main UI components.

			self - Reference to Resolution.
	]]--
	_R.HideUI = function(self)
		if self.frameInterface then
			self.frameMain.ButtonSettings:Hide();
			self.frameInterface:Hide();
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
				injectSelf = "LoadFrame",
				subLevel = 6,
				strata = "HIGH",
				setAllPoints = true,
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
			injectSelf = "Button" .. name,
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
	_R.CreateGridFrame = function(self, name)
		local _K = _K;

		local scrollFrame = self.frameMain:SpawnFrame({
			parentName = name,
			type = "ScrollFrame",
			points = {
				{ point = "TOPLEFT", x = 20, y = -40 },
				{ point = "BOTTOMRIGHT", x = -20, y = 20 }
			}
		});

		local frame = scrollFrame:SpawnFrame({
			injectSelf = "InnerFrame",
			width = scrollFrame:GetWidth(),
			height = scrollFrame:GetHeight(),
			textures = {
				texture = "InvalidTexturePath",
				setAllPoints = true
			},
			data = {
				-- Inject helper functions.
				RenderSections = self.GridFrame_RenderSections,
			}
		});

		scrollFrame:SetScrollChild(frame);

		-- Create a factory for generation sections.
		frame.sectionFactory = _K.Factory({
			size = 1,
			parent = frame,
			factoryName = "$parentSection",
			texts = {
				injectSelf = "Text",
				points = { point = "TOPLEFT" },
				inherit = "Game11Font_o1"
			}
		});

		-- Create a factory for generating icons.
		frame.iconFactory = _K.Factory({
			size = GRID_ICON_SIZE,
			parent = frame,
			factoryName = "$parentIcon",
			textures = {
				{
					-- Base shadow.
					subLevel = 5,
					setAllPoints = true,
					injectSelf = "Shadow",
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
		});

		return frame;
	end

	--[[
		Resolution.GridFrame_RenderSections
		Render sections into a grid frame.

			self - Reference to the grid section region.
			sections - Table containing section data.
	]]--
	_R.GridFrame_RenderSections = function(self, sections)
		-- Calculate maximum amount of icons a section can contain
		-- before it needs to be split into multiple rows.
		local maxWidth = self:GetWidth() - GRID_SECTION_MARGIN_TOTAL;
		local maxIcons = floor(maxWidth / GRID_ICON_SIZE);

		local rowFirstSection = nil;
		local previousSection = nil;
		local previousIsMulti = false;
		local currentRowWidth = 0;

		for sectionName, section in pairs(sections) do
			local iconCount = #section;
			local sectionWidth = GRID_SECTION_MARGIN_TOTAL + (iconCount * GRID_ICON_SIZE);

			-- Generate the frame so we can calculate the string width.
			local frame = self.sectionFactory:Generate();
			frame.Text:SetText(sectionName);

			-- If the header is longer than the icons, use that width instead.
			sectionWidth = max(sectionWidth, frame.Text:GetStringWidth() + GRID_SECTION_MARGIN_TOTAL);

			local isMulti = sectionWidth > maxWidth;
			frame:SetSize(sectionWidth, GRID_ROW_HEIGHT + (ceil(iconCount / maxIcons) * GRID_ICON_SIZE));

			-- Calculate frame position, and attach.
			if previousSection then
				-- This is not the first section, anchor to another.
				if isMulti or previousIsMulti or currentRowWidth + sectionWidth > maxWidth then
					-- Section requires its own row (isMulti) or clips over the max-width.
					frame:SetPoint("TOPLEFT", rowFirstSection, "BOTTOMLEFT");
					rowFirstSection = frame; -- Mark this as the first frame for this row.
					currentRowWidth = 0; -- Reset the row width.
				else
					-- Section can fit on to the current row.
					frame:SetPoint("LEFT", previousSection, "RIGHT");
				end
			else
				-- This is the first section, default anchor.
				frame:SetPoint("TOPLEFT", self, "TOPLEFT");
				rowFirstSection = frame; -- Mark this as the first frame for this row.
			end

			-- Store these for next section calculations.
			previousIsMulti = isMulti;
			previousSection = frame;

			-- Update current row width.
			if not isMulti then
				currentRowWidth = currentRowWidth + sectionWidth;
			end

			-- Render all of the icons for the section.
			local previousIcon = nil;
			local rowFirstIcon = nil;

			for i = 1, iconCount do
				local icon = self.iconFactory:Generate();

				if previousIcon then
					-- Not the first icon, attach to the correct icon.
					if isMulti and mod(i, maxIcons) == 0 then
						-- Cascade onto the next row.
						icon:SetPoint("TOP", rowFirstIcon, "BOTTOM");
						rowFirstIcon = icon; -- Mark as first icon in this row.
					else
						-- Continue the row from left to right.
						icon:SetPoint("LEFT", previousIcon, "RIGHT");
					end
				else
					-- This is the first icon, default anchoring.
					icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -GRID_SECTION_MARGIN);
					rowFirstIcon = icon; -- Mark as first icon in this row.
				end

				previousIcon = icon;
			end
		end
	end
end