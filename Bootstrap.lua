--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	Bootstrap.lua - Handles initial setup of the addon.
]]--

do
	-- [[ Local Optimization & Addon Setup ]] --
	Resolution = {
		refKrutilities = GetKrutilities(1.8), -- Reference to UI factory.
		loadState = 0, -- Initiate load state at 0 (inactive).
		Data = {}, -- Contains static data tables from data files.
	};
	local _R = Resolution; -- Reference to addon container.

	--[[
		Resolution.ApplyLocalization
		Copies all given localization into the string table.

			self - Reference to Resolution.
			locale - Localization table.
	]]--
	_R.ApplyLocalization = function(self, locale)
		local strings = self.Strings;
		for key, str in pairs(locale) do
			strings[key] = str;
		end
	end

	-- [[ String Lookup Router ]] --
	setmetatable(_R, { __index = function(t, k) return t.Strings[k]; end });
end