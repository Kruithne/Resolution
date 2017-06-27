--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	EventHandling.lua - Contains functions responsible for handling events.
]]--

do
	-- [[ Local Optimization ]] --
	local _R = Resolution;
	local co_status = coroutine.status;
	local co_resume = coroutine.resume;

	--[[
		Resolution.OnLoad
		Invoked when this add-on is loaded.

			self - Reference to Resolution
	]]--
	_R.OnLoad = function(self)
		-- Cache chat prefix.
		self.CHAT_PREFIX = self:FormatColours(self.CHAT_PREFIX:format(self.ADDON_NAME));

		-- Display load prompt.
		self:Print(self.LOAD_PROMPT, self.ADDON_NAME);

		self:Open(); -- DEBUG: Auto-load during development.
	end

	--[[
		Resolution.OnUpdate
		Invoked on every frame.

			self - Reference to Resolution.
			elapsed - Seconds since the last frame.
	]]--
	_R.OnUpdate = function(self, elapsed)
		--	Load states:
		--		0 = Inactive
		--		1 = Loading
		--		2 = Complete
		if self.loadState > 0 then
			if self.loadState == 1 then
				-- Loading is in process.
				local success, text = co_resume(self.loaderThread, self);
				if success and text then
					self.loadBar:SetBarText(text);
				end
			elseif self.loadState == 2 then
				-- Loading has completed.
				self:HideLoadFrame();
				self.loadState = 0;
			end
		end
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

	--[[
		Resolution.OnChatCommand
		Invoked when this add-ons chat command is used.

			msg - User-input for the command.
			editbox - The editbox used to enter the command.
	]]--
	_R.OnChatCommand = function(msg, editbox)
		_R:Open();
	end
end