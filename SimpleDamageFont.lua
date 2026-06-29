SimpleDamageFont = {}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "SimpleDamageFont" then
        DAMAGE_TEXT_FONT = "Interface\\AddOns\\SimpleDamageFont\\Fonts\\Expressway.ttf"
        self:UnregisterEvent("ADDON_LOADED")
    end
end)