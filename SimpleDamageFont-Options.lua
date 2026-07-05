local addonName, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local settingsPanel = CreateFrame("Frame", "SimpleDamageFontSettingsPanel", UIParent)
local addonVersion = C_AddOns.GetAddOnMetadata(addonName, "Version")

-- Preview fonts table and helper function to use in dropdown and default dropdown value
local previewFonts = {}

local function GetOrCreatePreviewFont(fontName)
    local previewFont = previewFonts[fontName]
    if not previewFont then
        previewFont = CreateFont("SimpleDamageFontPreview_" .. fontName)
        previewFont:SetFont(LSM:Fetch("font", fontName, true) or ns.DEFAULT_FONT, 12, "")
        previewFonts[fontName] = previewFont
    end
    return previewFont
end


-- Title
local title = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Simple Damage Font")

-- Subtitle
local subtitle = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetText("Author: Fugazi\nVersion: " .. addonVersion .. "\n\nCustomize your floating damage font.")
subtitle:SetJustifyH("LEFT")

-- Dropdown menu
local fontDropdown = CreateFrame("Frame", "SimpleDamageFontDropdown", settingsPanel, "UIDropDownMenuTemplate")
fontDropdown:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -16, -16)
UIDropDownMenu_SetWidth(fontDropdown, 200)
UIDropDownMenu_JustifyText(fontDropdown, "LEFT")

settingsPanel:SetScript("OnShow", function()
    if ns.db.customFontName then
        UIDropDownMenu_SetSelectedValue(fontDropdown, ns.db.customFontName)
        UIDropDownMenu_SetText(fontDropdown, ns.db.customFontName)
        fontDropdown.Text:SetFontObject(GetOrCreatePreviewFont(ns.db.customFontName))
    else
        UIDropDownMenu_SetText(fontDropdown, "Select a font")
    end
end)

UIDropDownMenu_Initialize(fontDropdown, function(self, level)
    for _, fontName in ipairs(LSM:List("font")) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = fontName
        info.value = fontName
        info.fontObject = GetOrCreatePreviewFont(fontName)

        info.func = function(self)
            UIDropDownMenu_SetSelectedValue(fontDropdown, self.value)
            fontDropdown.Text:SetFontObject(GetOrCreatePreviewFont(self.value))
        end

        UIDropDownMenu_AddButton(info)
    end
end)

-- Apply button
local applyButton = CreateFrame("Button", "SimpleDamageFontApplyButton", settingsPanel, "UIPanelButtonTemplate")
applyButton:SetSize(100, 22)
applyButton:SetPoint("LEFT", title, "LEFT", 0, 0)
applyButton:SetPoint("TOP", fontDropdown, "BOTTOM", 0, -8)
applyButton:SetText("Apply")

applyButton:SetScript("OnClick", function()
    local selectedFont = UIDropDownMenu_GetSelectedValue(fontDropdown)
    if not selectedFont then return end

    ns.db.customFontName = selectedFont
    ns.db.customFontPath = LSM:Fetch("font", selectedFont, true) or ns.DEFAULT_FONT

    print("|cFF00FF00SimpleDamageFont:|r |cFFFFD100" .. selectedFont .. "|r saved — log out and back in fully to apply it.")
end)

-- Relog notice
local relogNotice = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
relogNotice:SetPoint("LEFT", title, "LEFT", 0, 0)
relogNotice:SetPoint("TOP", applyButton, "BOTTOM", 0, -16)
relogNotice:SetWidth(500)
relogNotice:SetJustifyH("LEFT")
relogNotice:SetText("After clicking Apply, you must fully log out to the character selection screen and log back in for the new font to take effect. \n\nReloading the UI (/reload) is not enough.")
relogNotice:SetTextColor(1, 0.5, 0, 1)

-- Register category
local settingsCategory = Settings.RegisterCanvasLayoutCategory(settingsPanel, "Simple Damage Font")
Settings.RegisterAddOnCategory(settingsCategory)

-- Slash command
SLASH_SIMPLEDAMAGEFONT1 = "/sdf"
SlashCmdList["SIMPLEDAMAGEFONT"] = function(msg)
    if InCombatLockdown() then
        print("|cFF00FF00SimpleDamageFont:|r Cannot open settings while in combat.")
        return
    end
    Settings.OpenToCategory(settingsCategory.ID)
end
