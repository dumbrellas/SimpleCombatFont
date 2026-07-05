local addonName, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")


ns.DEFAULT_FONT = DAMAGE_TEXT_FONT


local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, loadedAddon)
    if event == "ADDON_LOADED" then
        if loadedAddon == addonName then
--[[
            SimpleDamageFontDB = SimpleDamageFontDB or {}
            ns.db = SimpleDamageFontDB

            if not ns.db.customFontName then
                ns.db.customFontName = "Bazooka"
            end

            ns.db.customFontPath = LSM:Fetch("font", ns.db.customFontName, true) or ns.DEFAULT_FONT
            DAMAGE_TEXT_FONT = ns.db.customFontPath
  ]]
            DAMAGE_TEXT_FONT  = "Path\\to\\fake\\file.ttf"          
            self:UnregisterEvent("ADDON_LOADED")
        end

    elseif event == "PLAYER_LOGIN" then
        --[[
        local fontPath = LSM:Fetch("font", ns.db.customFont, true) or ns.DEFAULT_FONT
        DAMAGE_TEXT_FONT = fontPath

        -- debug (remove later)
        print(("|cFF00FF00SimpleDamageFont:|r name=%s  path=%s")
        :format(tostring(ns.db.customFont), tostring(fontPath)))
        ]]
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)