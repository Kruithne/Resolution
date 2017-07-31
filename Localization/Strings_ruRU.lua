--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.

	https://github.com/Kruithne/Resolution

	Strings_ruRU.lua - Russian localization strings.
]]--

do
    if GetLocale() == "ruRU" then
    	Resolution:ApplyLocalization({
            ["COLLECTION_PETS"] = "Боевые питомцы",
			["COLLECTION_MOUNTS"] = "Транспорт",
			["COLLECTION_TITLES"] = "Звания",
			["COLLECTION_APPEARANCES"] = "Модели",
			["COLLECTION_HEIRLOOMS"] = "Наследуемые предметы",
			["COLLECTION_ACHIEVEMENTS"] = "Достижения",
    	});
    end
end
