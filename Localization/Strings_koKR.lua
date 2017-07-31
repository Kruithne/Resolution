--[[
	Resolution (C) Kruithne <kruithne@gmail.com>
	Licensed under GNU General Public Licence version 3.

	https://github.com/Kruithne/Resolution

	Strings_koKR.lua - Korean localization strings.
]]--

do
    if GetLocale() == "koKR" then
    	Resolution:ApplyLocalization({
            ["COLLECTION_PETS"] = "전투 애완동물",
			["COLLECTION_MOUNTS"] = "탈것",
			["COLLECTION_TITLES"] = "칭호",
			["COLLECTION_APPEARANCES"] = "형상",
			["COLLECTION_HEIRLOOMS"] = "계승품",
			["COLLECTION_ACHIEVEMENTS"] = "업적",
    	});
    end
end
