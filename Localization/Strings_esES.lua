--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.

	https://github.com/Kruithne/Resolution

	Strings_esES.lua - Spanish/Mexican localization strings.
]]--

do
    local locale = GetLocale();
    if locale == "esES" or locale == "esMX" then
    	Resolution:ApplyLocalization({
            ["COLLECTION_PETS"] = "Mascotas de duelo",
            ["COLLECTION_MOUNTS"] = "Monturas",
            ["COLLECTION_TITLES"] = "Títulos",
            ["COLLECTION_APPEARANCES"] = "Apariencias",
            ["COLLECTION_HEIRLOOMS"] = "Reliquias",
            ["COLLECTION_ACHIEVEMENTS"] = "Logros",
    	});
    end
end
