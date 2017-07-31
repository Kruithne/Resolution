--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.

	https://github.com/Kruithne/Resolution

	Strings_deDE.lua - German localization strings.
]]--

do
    if GetLocale() == "deDE" then
    	Resolution:ApplyLocalization({
            ["COLLECTION_PETS"] = "Kampfhaustiere",
            ["COLLECTION_MOUNTS"] = "Reittiere",
            ["COLLECTION_TITLES"] = "Titel",
            ["COLLECTION_APPEARANCES"] = "Vorlagen",
            ["COLLECTION_HEIRLOOMS"] = "Erbstücke",
            ["COLLECTION_ACHIEVEMENTS"] = "Erfolge",
    	});
    end
end
