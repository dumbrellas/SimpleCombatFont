local addonName, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")


ns.DEFAULT_FONT = DAMAGE_TEXT_FONT
ns.DEBUG_FONT = "Interface\\AddOns\\SimpleDamageFont\\Fonts\\Expressway.ttf"


local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, loadedAddon)
    if event == "ADDON_LOADED" then
        if loadedAddon == addonName then
            SimpleDamageFontDB = SimpleDamageFontDB or {}
            ns.db = SimpleDamageFontDB
        if not ns.db.customFontPath then
            print "|cFF00FF00SimpleDamageFont:|r Database was nil, set to default font." -- Debug message, remove later
            DAMAGE_TEXT_FONT = ns.DEFAULT_FONT
        elseif C_UIFileAsset.IsLooseFile(ns.db.customFontPath) then
            print("|cFF00FF00SimpleDamageFont:|r |cFFFFD100" .. ns.db.customFontName .. "|r is a loose file and can be used.") -- Debug message, remove later
            print("|cFF00FF00SimpleDamageFont:|r Font set to: " .. ns.db.customFontPath) -- Debug message, remove later
            DAMAGE_TEXT_FONT = ns.db.customFontPath
        else
            print("|cFF00FF00SimpleDamageFont:|r |cFFFFD100" .. ns.db.customFontName .. "|r is not a loose file and cannot be used.") -- Debug message, remove later
            print("|cFF00FF00SimpleDamageFont:|r Font set to: " .. ns.DEFAULT_FONT) -- Debug message, remove later
            DAMAGE_TEXT_FONT = ns.DEFAULT_FONT
        end      
        self:UnregisterEvent("ADDON_LOADED")
    end

    elseif event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)