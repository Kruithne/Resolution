--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.

	https://github.com/Kruithne/Resolution

	Strings_zhTW.lua - Chinese (Traditional) localization strings.
]]--

do
    if GetLocale() == "zhTW" then
    	Resolution:ApplyLocalization({
            ["COLLECTION_PETS"] = "戰寵",
			["COLLECTION_MOUNTS"] = "坐騎",
			["COLLECTION_TITLES"] = "頭銜",
			["COLLECTION_APPEARANCES"] = "外觀",
			["COLLECTION_HEIRLOOMS"] = "傳家寶",
			["COLLECTION_ACHIEVEMENTS"] = "成就",
    	});
    end
end
