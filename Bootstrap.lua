--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	Bootstrap.lua - Handles initial setup of the addon.
]]--

do
	-- [[ Local Optimization & Addon Setup ]] --
	Resolution = {};
	local _R = Resolution; -- Reference to addon container.

	-- [[ String Lookup Router ]] --
	setmetatable(_R, { __index = function(t, k) return t.Strings[k]; end });
end