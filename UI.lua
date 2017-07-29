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

	local pairs = pairs;
	local ceil = math.ceil;
	local floor = math.floor;

	local GetBindingFromClick = GetBindingFromClick;
	local UnitFactionGroup = UnitFactionGroup;
	local GetMaxPlayerLevel = GetMaxPlayerLevel;

	-- [[ Design Constants ]] --
	local GRID_SECTION_MARGIN = 15; -- Distance between grid frame sections.
	local GRID_SECTION_MARGIN_TOTAL = GRID_SECTION_MARGIN * 2; -- Total margin size for sections.
	local GRID_ICON_SIZE = 36; -- Width/height of the grid frame icon regions.
	local GRID_ROW_HEIGHT = 20; -- Height of a grid row, not including icon heights.

	-- [[ Local Strings ]] --
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
				points = "CENTER",
				name = "ResolutionFrame",
				enableKeyboard = true,
				scripts = {
					OnKeyDown = function(frame, key)
						local binding = GetBindingFromClick(key);
						if binding == "TOGGLEGAMEMENU" then
							self:Close();
						end
					end
				}
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

			local fontMixin = {
				fontFile = STANDARD_TEXT_FONT,
				fontFlags = "OUTLINE"
			};

			self.frameInterface = self.frameMain:SpawnFrame({
				setAllPoints = true,
				injectSelf = "Container",
				data = { totalElapsed = 0, currentTipIndex = 0, tips = self.TIP_TEXTS },
				scripts = {
					OnUpdate = function(self, elapsed)
						self.totalElapsed = self.totalElapsed + elapsed;
						if not self.hasUpdated or self.totalElapsed >= 5 then
							-- Move to the next tip, reset if needed.
							self.currentTipIndex = self.currentTipIndex + 1;
							if self.currentTipIndex > #self.tips then
								self.currentTipIndex = 1;
							end

							 -- Update tip text.
							self.TipText:SetText(self.tips[self.currentTipIndex]);

							self.totalElapsed = 0; -- Reset timer.
							if not self.hasUpdated then
								-- This is used to force the first tip update without waiting.
								self.hasUpdated = true;
							end
						end
					end
				},
				frames = {
					{
						type = "PlayerModel",
						injectSelf = "BackgroundModel",
						strata = "HIGH",
						points = {
							"TOPLEFT",
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
					},
					{
						injectSelf = "Tooltip",
						inherit = "TooltipBorderedFrameTemplate",
						strata = "TOOLTIP",
						topLevel = true,
						clampedToScreen = true,
						hidden = true,
						texts = {
							{
								injectSelf = "Title",
								inherit = "GameTooltipHeaderText",
								justifyH = "LEFT",
								points = { point = "TOPLEFT", x = 10, y = -11 }
							},
							{
								injectSelf = "Info",
								inherit = "GameFontNormal",
								justifyH = "LEFT",
								points = { point = "TOPLEFT", relativeKey = "Title", relativePoint = "BOTTOMLEFT", y = -2 }
							}
						}
					}
				},
				textures = {
					{
						injectSelf = "ClassIcon",
						size = 90,
						points = { point = "TOPLEFT", x = 15, y = -15 }
					}
				},
				texts = {
					{
						text = UnitPVPName(UNIT_PLAYER),
						injectSelf = "PlayerTitle",
						fontSize = 25,
						mixin = fontMixin,
						points = { point = "TOPLEFT", x = 115, y = -33 }
					},
					{
						text = self.GUILD_TAG:format((GetGuildInfo(UNIT_PLAYER)) or self.PLAYER_NO_GUILD),
						injectSelf = "PlayerGuild",
						fontSize = 25,
						mixin = fontMixin,
						points = { point = "TOPLEFT", x = 115, y = -63 },
					},
					{
						text = "79.5%",
						injectSelf = "OverviewValue",
						fontSize = 34,
						mixin = fontMixin,
						points = { point = "LEFT", x = 140 }
					},
					{
						text = "Overall Progress",
						injectSelf = "OverviewHeader",
						fontSize = 24,
						mixin = fontMixin,
						points = { point = "BOTTOM", relativePoint = "TOP", relativeKey = "OverviewValue", y = 10 }
					},
					{
						text = "1025 Days Played",
						injectSelf = "OverviewPlayed",
						fontSize = 24,
						mixin = fontMixin,
						points = { point = "TOP", relativePoint = "BOTTOM", relativeKey = "OverviewValue", y = -10 }
					},
					{
						text = "Tip: This here is a test, some kind of tip!",
						injectSelf = "TipText",
						fontSize = 14,
						mixin = fontMixin,
						points = { point = "BOTTOMRIGHT", x = -10, y = 10 },
					}
				}
			});

			-- Set class icon for the current class.
			local _, className = UnitClass(UNIT_PLAYER);
			self.frameInterface.ClassIcon:SetAtlas("classhall-circle-" .. className);

			-- Set the player model to the actual player.
			self.frameInterface.PlayerModel:SetUnit(UNIT_PLAYER);
		end

		-- Render/update class icons.
		self:RenderClassIcons();

		-- Background model needs to be reset every time.
		local model = self.frameInterface.BackgroundModel;
		model.isCameraSet = false;
		model.isNotFirstFrame = false;

		local modelPath = "UI_Pandaren\\UI_Pandaren.m2";
		local playerFaction = UnitFactionGroup(UNIT_PLAYER);

		if playerFaction == "Alliance" then
			modelPath = "UI_Human\\UI_Human.m2";
		elseif playerFaction == "Horde" then
			modelPath = "UI_Horde\\UI_Horde.m2";
		end

		model:SetModel("Interface\\Glues\\Models\\" .. modelPath);

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
			local GetClassInfo = GetClassInfo; -- Local ref to func.
			local RAID_CLASS_COLORS = RAID_CLASS_COLORS;

			-- String chunks.
			local texturePath = _K.StringChunk("Interface\\ICONS\\ClassIcon_");
			local injectName = _K.StringChunk("ClassIcon");

			-- Construction tables.
			local icons = {}; -- Storage for texture references.
			local point = { point = "BOTTOMLEFT", x = 15, y = 15 };
			local texture = { injectSelf = "Icon" };

			local frameStructure = {
				size = 32,
				points = point, -- Added by reference for easy modification below!
				textures = texture, -- Added by reference for easy modification below!
				scripts = {
					OnEnter = function(icon)
						self:ShowTooltip(icon._tooltipHeaderString, icon._tooltipInfoString, icon, icon._tooltipHeaderColor);
					end,

					OnLeave = function()
						self:HideTooltip();
					end
				}
			};

			-- Loop through all available classes.
			for i = 1, GetNumClasses() do
				local _, classTag, classID = GetClassInfo(i);

				-- Update creation strings.
				texturePath:Set(2, classTag);
				texture.texture = texturePath:Get();

				injectName:Set(2, classID);
				frameStructure.injectSelf = injectName:Get();

				local icon = self.frameInterface:SpawnFrame(frameStructure);

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
		local infoChunk = _K.StringChunk(LEVEL);
		local noCharInfo = self.CLASS_NO_CHARACTER_INFO:format(maxLevel);

		for classID, classIcon in pairs(self.classIcons) do
			local storedClass = classData[classID];
			local activated = storedClass and storedClass.level >= maxLevel;

			classIcon.Icon:SetAlpha(activated and 1 or 0.5);
			classIcon.Icon:SetDesaturated(not activated);

			-- Pre-compile tooltip info string.
			local className, classTag = GetClassInfo(classID);
			classIcon._tooltipHeaderString = storedClass and self.PLAYER_REALM_FORMAT:format(storedClass.name, storedClass.realm) or self.CLASS_NO_CHARACTER;
			classIcon._tooltipHeaderColor = storedClass and RAID_CLASS_COLORS[classTag] or self.Palette.Disabled;
			classIcon._tooltipInfoString = noCharInfo:format(className); -- Default, replaced in next scope.

			if storedClass then
				infoChunk:Set(2, storedClass.level);
				infoChunk:Set(3, storedClass.race);
				infoChunk:Set(4, className);

				classIcon._tooltipInfoString = infoChunk:Get(" ");
			end
		end
	end

	--[[
		Resolution.ShowTooltip
		Activate the tooltip with the provided details.

			self - Reference to Resolution.
			titleText - Text to appear in the tooltip header.
			infoText - Information text to fill the tooltip.
			anchor - Region to anchor the tooltip to (visually).
			color - Color for the title text. Defaults to white.
	]]--
	_R.ShowTooltip = function(self, titleText, infoText, anchor, color)
		local tooltip = self.frameInterface.Tooltip;
		local regionTitle, regionInfo = tooltip.Title, tooltip.Info;

		-- Set the tooltip text.
		regionTitle:SetText(titleText);
		regionInfo:SetText(infoText);

		-- Update the tooltip region dimensions.
		tooltip:SetHeight(regionTitle:GetHeight() + regionInfo:GetHeight() + 24); -- 24 for padding
		tooltip:SetWidth(regionInfo:GetWidth() + 24); -- We just assume the info is always longest.

		-- Color the title text (default to white).
		color = color or self.Palette.White;
		regionTitle:SetTextColor(color.r or 1, color.g or 1, color.b or 1, color.a or 1);

		-- Position tooltip relative to the anchor region.
		tooltip:SetPoint("BOTTOMLEFT", anchor, "CENTER", 5, 5);
		tooltip:Show();
	end

	--[[
		Resolution.HideTooltip
		Hide the interface tooltip

			self - Reference to Resolution.
	]]--
	_R.HideTooltip = function(self)
		self.frameInterface.Tooltip:Hide();
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
		-- Ensure value is between 0-100.
		if value > 100 then
			value = 100;
		elseif value < 0 then
			value = 0;
		end

		-- Reverse, and scale to 0-1.
		value = (100 - value) / 100;

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
				points = "TOPLEFT" ,
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
			local headerWidth = frame.Text:GetStringWidth() + GRID_SECTION_MARGIN_TOTAL;
			if headerWidth > sectionWidth then
				sectionWidth = headerWidth;
			end

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
					if isMulti and i % maxIcons == 0 then
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
