local addonName, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.DEFAULT_FONT = DAMAGE_TEXT_FONT

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, loadedAddon)
    if event == "ADDON_LOADED" then
        if loadedAddon == addonName then
            SimpleDamageFontDB = SimpleDamageFontDB or {}
            ns.db = SimpleDamageFontDB
        if not ns.db.customFontPath then
            DAMAGE_TEXT_FONT = ns.DEFAULT_FONT
        elseif C_UIFileAsset.IsLooseFile(ns.db.customFontPath) or C_UIFileAsset.IsKnownFile(ns.db.customFontPath) then
            DAMAGE_TEXT_FONT = ns.db.customFontPath
        else
            print("|cFF00FF00SimpleDamageFont:|r |cFFFFD100" .. ns.db.customFontName .. "|r was not found. Please select a different font in SDF settings.")
            DAMAGE_TEXT_FONT = ns.DEFAULT_FONT
        end      
        self:UnregisterEvent("ADDON_LOADED")
    end

    elseif event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)