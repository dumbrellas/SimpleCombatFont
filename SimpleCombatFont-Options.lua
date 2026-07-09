local addonName, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local settingsPanel = CreateFrame("Frame", "SimpleCombatFontSettingsPanel", UIParent)
local addonVersion = C_AddOns.GetAddOnMetadata(addonName, "Version")

-- Preview texts table and update function to be called when a new drop-down value is selected
local previewTexts = {}

local function UpdatePreviewFonts(fontName)
    local fontPath = LSM:Fetch("font", fontName, true) or ns.DEFAULT_FONT
    for _, previewText in ipairs(previewTexts) do
        previewText.fontString:SetFont(fontPath, previewText.size, "")
    end
end

-- Title
local title = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Simple Combat Font")

-- Subtitle
local subtitle = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetText("Author: Fugazi\nVersion: " .. addonVersion .. "\n\nCustomize your floating combat text font.")
subtitle:SetJustifyH("LEFT")

-- Dropdown menu
local fontDropdown = CreateFrame("Frame", "SimpleCombatFontDropdown", settingsPanel, "UIDropDownMenuTemplate")
fontDropdown:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -16, -16)
UIDropDownMenu_SetWidth(fontDropdown, 200)
UIDropDownMenu_JustifyText(fontDropdown, "LEFT")

settingsPanel:SetScript("OnShow", function()
    if ns.db.customFontName then
        UIDropDownMenu_SetSelectedValue(fontDropdown, ns.db.customFontName)
        UIDropDownMenu_SetText(fontDropdown, ns.db.customFontName)
    else
        UIDropDownMenu_SetText(fontDropdown, "Select a font")
    end
    UpdatePreviewFonts(ns.db.customFontName)
end)

UIDropDownMenu_Initialize(fontDropdown, function(self, level)
    for _, fontName in ipairs(LSM:List("font")) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = fontName
        info.value = fontName

        info.func = function(self)
            UIDropDownMenu_SetSelectedValue(fontDropdown, self.value)
            UpdatePreviewFonts(self.value)
        end

        UIDropDownMenu_AddButton(info)
    end
end)

-- Apply button
local applyButton = CreateFrame("Button", "SimpleCombatFontApplyButton", settingsPanel, "UIPanelButtonTemplate")
applyButton:SetSize(100, 22)
applyButton:SetPoint("LEFT", title, "LEFT", 0, 0)
applyButton:SetPoint("TOP", fontDropdown, "BOTTOM", 0, -8)
applyButton:SetText("Apply")

applyButton:SetScript("OnClick", function()
    local selectedFont = UIDropDownMenu_GetSelectedValue(fontDropdown)
    if not selectedFont then return end

    ns.db.customFontName = selectedFont
    ns.db.customFontPath = LSM:Fetch("font", selectedFont, true) or ns.DEFAULT_FONT

    print("|cFF00FF00SimpleCombatFont:|r |cFFFFD100" .. selectedFont .. "|r saved — log out and back in fully to apply it.")
end)

-- Relog notice
local relogNotice = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
relogNotice:SetPoint("LEFT", title, "LEFT", 0, 0)
relogNotice:SetPoint("TOP", applyButton, "BOTTOM", 0, -16)
relogNotice:SetWidth(500)
relogNotice:SetJustifyH("LEFT")
relogNotice:SetText("After clicking Apply, you must fully log out to the character selection screen and log back in for the new font to take effect. \n\nReloading the UI (/reload) is not enough.")
relogNotice:SetTextColor(1, 0.5, 0, 1)

-- Preview
local previewTitle = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
previewTitle:SetPoint("LEFT", title, "LEFT", 0, 0)
previewTitle:SetPoint("TOP", relogNotice, "BOTTOM", 0, -16)
previewTitle:SetText("Preview")

-- Normal damage
local previewNormal = settingsPanel:CreateFontString(nil, "OVERLAY")
previewNormal:SetFont(ns.DEFAULT_FONT, 25, "")
previewNormal:SetPoint("LEFT", title, "LEFT", 0, 0)
previewNormal:SetPoint("TOP", previewTitle, "BOTTOM", 0, -6)
previewNormal:SetTextColor(1, 1, 1, 1)
previewNormal:SetText("1,234")
table.insert(previewTexts, { fontString = previewNormal, size = 25 })

-- Ability damage
local previewAbility = settingsPanel:CreateFontString(nil, "OVERLAY")
previewAbility:SetFont(ns.DEFAULT_FONT, 25, "")
previewAbility:SetPoint("LEFT", title, "LEFT", 0, 0)
previewAbility:SetPoint("TOP", previewNormal, "BOTTOM", 0, -6)
previewAbility:SetTextColor(1, 0.82, 0, 1)
previewAbility:SetText("2,345")
table.insert(previewTexts, { fontString = previewAbility, size = 25 })

-- Ability crit damage
local previewAbilityCrit = settingsPanel:CreateFontString(nil, "OVERLAY")
previewAbilityCrit:SetFont(ns.DEFAULT_FONT, 45, "")
previewAbilityCrit:SetPoint("LEFT", title, "LEFT", 0, 0)
previewAbilityCrit:SetPoint("TOP", previewAbility, "BOTTOM", 0, -6)
previewAbilityCrit:SetTextColor(1, 0.82, 0, 1)
previewAbilityCrit:SetText("4,567")
table.insert(previewTexts, { fontString = previewAbilityCrit, size = 45 })

-- Healing
local previewHealing = settingsPanel:CreateFontString(nil, "OVERLAY")
previewHealing:SetFont(ns.DEFAULT_FONT, 25, "")
previewHealing:SetPoint("LEFT", title, "LEFT", 0, 0)
previewHealing:SetPoint("TOP", previewAbilityCrit, "BOTTOM", 0, -6)
previewHealing:SetTextColor(0.10, 1, 0.10, 1)
previewHealing:SetText("1,234")
table.insert(previewTexts, { fontString = previewHealing, size = 25 })

-- Healing crit
local previewHealingCrit = settingsPanel:CreateFontString(nil, "OVERLAY")
previewHealingCrit:SetFont(ns.DEFAULT_FONT, 45, "")
previewHealingCrit:SetPoint("LEFT", title, "LEFT", 0, 0)
previewHealingCrit:SetPoint("TOP", previewHealing, "BOTTOM", 0, -6)
previewHealingCrit:SetTextColor(0.10, 1, 0.10, 1)
previewHealingCrit:SetText("3,456")
table.insert(previewTexts, { fontString = previewHealingCrit, size = 45 })

-- Register category
local settingsCategory = Settings.RegisterCanvasLayoutCategory(settingsPanel, "Simple Combat Font")
Settings.RegisterAddOnCategory(settingsCategory)

-- Slash command
SLASH_SIMPLECOMBATFONT1 = "/scf"
SlashCmdList["SIMPLECOMBATFONT"] = function(msg)
    if InCombatLockdown() then
        print("|cFF00FF00SimpleCombatFont:|r Cannot open settings while in combat.")
        return
    end
    Settings.OpenToCategory(settingsCategory.ID)
end
