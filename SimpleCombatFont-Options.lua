local addonName, ns = ...
local addonVersion = C_AddOns.GetAddOnMetadata(addonName, "Version")
local LSM = LibStub("LibSharedMedia-3.0")
local settingsPanel = CreateFrame("Frame", "SimpleCombatFontSettingsPanel", UIParent)

-- Function to get or create a session-cached preview font object (keyed by name+size). Table discarded each fresh login or /reload and re-populated as needed.
local previewFonts = {}
local function GetOrCreatePreviewFont(fontName, size)
    size = size or 12
    local key = (fontName or "Default") .. ":" .. size
    local previewFont = previewFonts[key]
    if not previewFont then
        previewFont = CreateFont("SimpleCombatFontPreview_" .. (fontName or "Default") .. "_" .. size)
        previewFont:SetFont(LSM:Fetch("font", fontName, true) or ns.DEFAULT_FONT, size, "")
        previewFonts[key] = previewFont
    end
    return previewFont
end

-- Functions to restyle and show/hide the preview texts
local previewTexts = {}
local function UpdatePreviewFonts(fontName)
    for _, previewText in ipairs(previewTexts) do
        previewText.fontString:SetFontObject(GetOrCreatePreviewFont(fontName, previewText.size))
    end
end

local function SetPreviewShown(shown)
    for _, previewText in ipairs(previewTexts) do
        previewText.fontString:SetShown(shown)
    end
end

-- Floating Combat Text toggles
local toggleChecks = {}
local combatTextToggles = {
    { cvar = "floatingCombatTextCombatDamage_v2",            label = "Show damage" },
    { cvar = "floatingCombatTextCombatLogPeriodicSpells_v2", label = "Show periodic (DoT/HoT) damage" },
    { cvar = "floatingCombatTextPetMeleeDamage_v2",          label = "Show pet melee damage" },
    { cvar = "floatingCombatTextPetSpellDamage_v2",          label = "Show pet spell damage" },
    { cvar = "floatingCombatTextCombatHealing_v2",           label = "Show healing" },
}

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
        SetPreviewShown(true)
    else
        UIDropDownMenu_SetText(fontDropdown, "Select a font")
        SetPreviewShown(false)
    end
    UpdatePreviewFonts(ns.db.customFontName)
    for _, check in ipairs(toggleChecks) do
        check:SetChecked(GetCVarBool(check.cvar))
    end
end)

UIDropDownMenu_Initialize(fontDropdown, function(self, level)
    for _, fontName in ipairs(LSM:List("font")) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = fontName
        info.value = fontName

        info.func = function(self)
            UIDropDownMenu_SetSelectedValue(fontDropdown, self.value)
            UpdatePreviewFonts(self.value)
            SetPreviewShown(true)
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

    print("|cFF00FF00[SimpleCombatFont]:|r |cFFFFD100" .. selectedFont .. "|r saved — log out and back in fully to apply it.")
end)

-- Relog notice
local relogNotice = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
relogNotice:SetPoint("LEFT", title, "LEFT", 0, 0)
relogNotice:SetPoint("TOP", applyButton, "BOTTOM", 0, -16)
relogNotice:SetWidth(300)
relogNotice:SetJustifyH("LEFT")
relogNotice:SetText("After clicking Apply, you must fully log out to the character selection screen and log back in for the new font to take effect.\n \nReloading the UI (/reload) is not enough.")
relogNotice:SetTextColor(1, 0.5, 0, 1)

-- Preview
local previewTitle = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
previewTitle:SetPoint("LEFT", title, "LEFT", 0, 0)
previewTitle:SetPoint("TOP", relogNotice, "BOTTOM", 0, -16)
previewTitle:SetText("Preview")

-- Normal damage
local previewNormal = settingsPanel:CreateFontString(nil, "OVERLAY")
previewNormal:SetFontObject(GetOrCreatePreviewFont(nil, 25))
previewNormal:SetPoint("LEFT", previewTitle, "LEFT", 0, 0)
previewNormal:SetPoint("TOP", previewTitle, "BOTTOM", 0, -6)
previewNormal:SetTextColor(1, 1, 1, 1)
previewNormal:SetText("1,234")
table.insert(previewTexts, { fontString = previewNormal, size = 25 })

-- Ability damage
local previewAbility = settingsPanel:CreateFontString(nil, "OVERLAY")
previewAbility:SetFontObject(GetOrCreatePreviewFont(nil, 25))
previewAbility:SetPoint("LEFT", previewTitle, "LEFT", 0, 0)
previewAbility:SetPoint("TOP", previewNormal, "BOTTOM", 0, -6)
previewAbility:SetTextColor(1, 0.82, 0, 1)
previewAbility:SetText("2,345")
table.insert(previewTexts, { fontString = previewAbility, size = 25 })

-- Ability crit damage
local previewAbilityCrit = settingsPanel:CreateFontString(nil, "OVERLAY")
previewAbilityCrit:SetFontObject(GetOrCreatePreviewFont(nil, 45))
previewAbilityCrit:SetPoint("LEFT", previewTitle, "LEFT", 0, 0)
previewAbilityCrit:SetPoint("TOP", previewAbility, "BOTTOM", 0, -6)
previewAbilityCrit:SetTextColor(1, 0.82, 0, 1)
previewAbilityCrit:SetText("4,567")
table.insert(previewTexts, { fontString = previewAbilityCrit, size = 45 })

-- Healing
local previewHealing = settingsPanel:CreateFontString(nil, "OVERLAY")
previewHealing:SetFontObject(GetOrCreatePreviewFont(nil, 25))
previewHealing:SetPoint("LEFT", previewTitle, "LEFT", 0, 0)
previewHealing:SetPoint("TOP", previewAbilityCrit, "BOTTOM", 0, -6)
previewHealing:SetTextColor(0.10, 1, 0.10, 1)
previewHealing:SetText("1,234")
table.insert(previewTexts, { fontString = previewHealing, size = 25 })

-- Healing crit
local previewHealingCrit = settingsPanel:CreateFontString(nil, "OVERLAY")
previewHealingCrit:SetFontObject(GetOrCreatePreviewFont(nil, 45))
previewHealingCrit:SetPoint("LEFT", previewTitle, "LEFT", 0, 0)
previewHealingCrit:SetPoint("TOP", previewHealing, "BOTTOM", 0, -6)
previewHealingCrit:SetTextColor(0.10, 1, 0.10, 1)
previewHealingCrit:SetText("3,456")
table.insert(previewTexts, { fontString = previewHealingCrit, size = 45 })

-- Combat text toggles
local cvarsTitle = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
cvarsTitle:SetPoint("LEFT", title, "LEFT", 300, 0)
cvarsTitle:SetPoint("TOP", relogNotice, "BOTTOM", 0, -16)
cvarsTitle:SetText("Floating Combat Text CVARs (Now account-wide in Midnight)")

local previousAnchor = cvarsTitle
for i, toggle in ipairs(combatTextToggles) do
    local check = CreateFrame("CheckButton", "SimpleCombatFontToggle" .. i, settingsPanel, "UICheckButtonTemplate")
    check:SetPoint("TOPLEFT", previousAnchor, "BOTTOMLEFT", 0, -6)
    check.Text:SetText(toggle.label)
    check.cvar = toggle.cvar
    check:SetScript("OnClick", function(self)
        SetCVar(self.cvar, self:GetChecked() and "1" or "0")
    end)
    toggleChecks[i] = check
    previousAnchor = check
end

-- Register category
local settingsCategory = Settings.RegisterCanvasLayoutCategory(settingsPanel, "Simple Combat Font")
Settings.RegisterAddOnCategory(settingsCategory)

-- Slash command
SLASH_SIMPLECOMBATFONT1 = "/scf"
SlashCmdList["SIMPLECOMBATFONT"] = function(msg)
    if InCombatLockdown() then
        print("|cFF00FF00[SimpleCombatFont]:|r Cannot open settings while in combat.")
        return
    end
    Settings.OpenToCategory(settingsCategory.ID)
end