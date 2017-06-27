--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	Loader.lua - Responsible for loading character data.
]]--
do
	-- [[ Local Optimization ]] --
	local _R = Resolution;
	local yield = coroutine.yield;
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
			local loaded, reason = LoadAddOn(name);
			if not loaded then
				-- Trigger a client error.
				assert(false, "Unload to load" .. name .. ": " .. reason);
			end
		end
	end
end