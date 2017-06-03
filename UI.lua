--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.
	
	https://github.com/Kruithne/Resolution

	UI.lua - Contains functions responsible for rendering the addon UI.
]]--

do
	local _R = Resolution;

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
			pushedTexture = "Interface\\AddOns\\Resolution\\Artwork\\" .. icon .. "-Pushed",
			highlightTexture = "Interface\\AddOns\\Resolution\\Artwork\\UI-Button-Highlight",
			normalTexture = "Interface\\AddOns\\Resolution\\Artwork\\" .. icon
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
end