--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	Core.lua - Core add-on core/functions.
]]--

do
	local _R = Resolution; -- Reference to addon container.
	local _K = GetKrutilities(1.7); -- Reference to Krutilities instance.

	-- [[ Register Event Hooks ]] --
	_K.EventHandler(_R, {
		["ADDON_LOADED"] = "OnAddonLoaded"
	});

	-- [[ Register Addon Commands ]] --
	_K.CommandHandler(_R, {
		["RESOLUTION"] = {
			commands = { "/resolution" },
			handler = "OnChatCommand"
		}
	});

	--[[
		Resolution.Print
		Output a message into chat, formatted for this add-on.

			self - Reference to Resolution.
			message - String to print to the chat.
	]]--
	_R.Print = function(self, message)
		DEFAULT_CHAT_FRAME:AddMessage(self.CHAT_PREFIX:format(self:FormatColours(message)));
	end

	--[[
		Resolution.FormatColours
		Replaces colour tokens within the given string using the add-on palette.

		self - Reference to Resolution.
		str - String to make the replacements in.

		Returns the formatted string.
	]]--
	_R.FormatColours = function(self, str)
		return str:gsub(self.Patterns.Palette, self.ReplaceColourTokens);
	end

	--[[
		Resolution.ReplaceColourTokens
		Internal function for colour format pattern matching.

		token - The token currently being iterated over.
	]]--
	_R.ReplaceColourTokens = function(token)
		return "|c" .. _R.Palette[token]:GenerateHexColor() or token;
	end

	--[[
		Resolution.Open
		Open the main panel of the add-on.

			self - Reference to Resolution.
	]]--
	_R.Open = function(self)
		if not self.hasLoaded then
			self:InitializeInterface();
		else
			self.frameMain:Show();
		end
	end

	--[[
		Resolution.Close
		Close the main panel of the add-on.

			self - Reference to Resolution.
	]]--
	_R.Close = function(self)
		if self.frameMain then
			self.frameMain:Hide();
		end
	end
end