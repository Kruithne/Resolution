--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.

	https://github.com/Kruithne/Resolution

	Loader.lua - Responsible for loading character data.
]]--
do
	-- [[ Local Optimization ]] --
	local _R = Resolution;

	local select = select;
	local yield = coroutine.yield;
	local math_floor = math.floor;
	local co_create = coroutine.create;

	-- [[ Loader ]] --
	_R.Loader = {
		_step = 1, -- Used to track the current executing step.
		_steps = {
			-- These will be invoked one after the other during loading.
			-- Calling yield() will suspend execution for one frame.

			-- Initial set-up.
			function(self)
				-- Bulk data is stored in ResolutionData addon for memory optimization.
				yield(self.LOADING_TEXT_DATA);
				self.Loader:RequireAddOn("ResolutionData");

				-- Initiate default storage containers.
				ResolutionDataCharacters = ResolutionDataCharacters or {};
				ResolutionDataPlayed = ResolutionDataPlayed or {};
			end,

			-- Collection: Characters
			function(self)
				yield(self.LOADING_TEXT_CHAR);
				local UnitName = UnitName;
				local GetRealmName = GetRealmName;
				local strPlayer = "player";

				local playerLevel = UnitLevel(strPlayer);
				local charStore = ResolutionDataCharacters;
				local classIndex = select(3, UnitClass(strPlayer));
				local existingChar = charStore[classIndex];

				if not existingChar or existingChar.level <= playerLevel then
					charStore[classIndex] = {
						name = UnitName(strPlayer),
						level = playerLevel,
						race = select(2, UnitRace(strPlayer)),
						realm = GetRealmName()
					};
				end

				-- Here we request the characters time played and intercept the response.
				-- The reason we intercept the ChatFrame_DisplayTimePlayed hook rather than
				-- just listening for the event ourself is to prevent unexpected chat output.
				self.orig_ChatFrame_DisplayTimePlayed = ChatFrame_DisplayTimePlayed;
				ChatFrame_DisplayTimePlayed = function(_, totalTime, levelTime)
					-- totalTime is in minutes, 86400 seconds make a day.
					local days = math_floor(totalTime / 86400);

					-- We don't care about characters with less than a day.
					if days > 0 then
						local playerName, realmName = UnitName(strPlayer), GetRealmName();
						ResolutionDataPlayed[playerName .. "-" .. realmName] = days;
					end

					-- Restore the original function and drop our reference to it.
					ChatFrame_DisplayTimePlayed = self.orig_ChatFrame_DisplayTimePlayed;
					self.orig_ChatFrame_DisplayTimePlayed = nil;

					-- Signal for the UI to update the value.
					self:UpdateTimePlayed();
				end
				RequestTimePlayed(); -- Send the actual request.
			end,

			-- Collection: Toys
			function(self)
				-- Set initial loading text.
				yield(self.LOADING_TEXT_TOYS);

				-- Require the Blizzard_Collections add-on for toy box interfacing.
				self.Loader:RequireAddOn("Blizzard_Collections"); yield();

				-- Optimize references for this routine.
				local GetToyInfo = C_ToyBox.GetToyInfo;
				local PlayerHasToy = PlayerHasToy;
				local pairs = pairs;

				-- Check toys.
				local count = 0;
				for itemID, obtainInfo in pairs(self.Data.Toys) do
					local _, name, texture = GetToyInfo(itemID);
					local collected = PlayerHasToy(itemID);

					-- ToDo: Actually store this data.

					count = count + 1;
					if count % 10 == 0 then
						yield();
					end
				end
			end,
		},
	}; _L = _R.Loader;

	--[[
		Resolution.Loader.Start
		Initiates the loading process.

			self - Reference to Resolution.Loader
	]]--
	_L.Start = function(self)
		_R.loadState = 1; -- Set load state to 1 (loading).
		_R.loaderThread = co_create(self.Run);

		self._step = 1;
	end

	--[[
		Resolution.Loader.Stop
		Abort the loading process.

			self - Reference to Resolution.Loader
	]]--
	_L.Stop = function(self)
		_R.loadState = 0; -- Set load state to 0 (inactive).
	end

	--[[
		Resolution.Loader.Run
		Execute a single loader cycle.

			self - Reference to Resolution.Loader
	]]--
	_L.Run = function(self)
		local stepCount = #self.Loader._steps;
		for i = 1, stepCount do
			self.Loader._steps[i](self);
			self.loadBar:SetBarProgress(i / stepCount * 100);
			yield();
		end

		_R:Print(self.VERSION_FORMAT, GetAddOnMetadata(_R.ADDON_NAME, "Version"));
		_R.loadState = 2; -- Set load state to 2 (complete).
	end

	--[[
		Resolution.Loader.RequireAddOn
		Load an add-on if it's not already loaded.
		Warning: Throws an error if the add-on cannot be loaded.

			self - Reference to Resolution.Loader
			name - Name of the add-on to load.
	]]--
	_L.RequireAddOn = function(self, name)
		if not IsAddOnLoaded(name) then
			-- Attempt to enable addon for this character.
			local _, _, _, canLoad, canLoadReason = GetAddOnInfo(name);
			if canLoadReason == "DISABLED" then
				EnableAddOn(name, UnitName("player"));
			end

			-- Attempt to load the add-on.
			local loaded, reason = LoadAddOn(name);
			if not loaded then
				-- Unable to load; show error and abort.
				_R:Print(_R.ERR_ADDON_LOAD, name);
				_R:Close();
			end
		end
	end
end
