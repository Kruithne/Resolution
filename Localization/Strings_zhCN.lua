--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.

	https://github.com/Kruithne/Resolution

	Strings_zhCN.lua - Chinese (Simplified) localization strings.
]]--

do
    if GetLocale() == "zhCN" then
    	Resolution:ApplyLocalization({
            ["COLLECTION_PETS"] = "战斗宠物",
			["COLLECTION_MOUNTS"] = "坐骑",
			["COLLECTION_TITLES"] = "头衔",
			["COLLECTION_APPEARANCES"] = "外观",
			["COLLECTION_HEIRLOOMS"] = "传家宝",
			["COLLECTION_ACHIEVEMENTS"] = "成就",
    	});
    end
end
