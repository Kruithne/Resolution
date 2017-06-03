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
	local _K = GetKrutilities(1.7); -- Reference to Krutilities instance.

	-- [[ String Lookup Router ]] --
	setmetatable(_R, { __index = function(t, k) return t.Strings[k]; end });

	--[[
		Resolution.Print
		Output a message into chat, formatted for this add-on.

			self - Reference to Resolution.
			message - String to print to the chat.
	]]--
	_R.Print = function(self, message)
		message = self.Palette.CHAT_NORMAL_COLOR:WrapTextInColorCode(message);
		DEFAULT_CHAT_FRAME:AddMessage(self.CHAT_PREFIX:format(message));
	end
end