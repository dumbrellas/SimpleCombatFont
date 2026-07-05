local addonName, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

local previewFonts = {}

local settingsPanel = CreateFrame("Frame", "SimpleDamageFontSettingsPanel", UIParent)

local title = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Simple Damage Font")

local subtitle = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetText("Author: Fugazi\nVersion: 1.0.0\n\nCustomize your floating damage font.")
subtitle:SetJustifyH("LEFT")

local fontDropdown = CreateFrame("Frame", "SimpleDamageFontDropdown", settingsPanel, "UIDropDownMenuTemplate")
fontDropdown:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -16, -16)
UIDropDownMenu_SetWidth(fontDropdown, 200)
UIDropDownMenu_SetText(fontDropdown, "Select a font")
UIDropDownMenu_JustifyText(fontDropdown, "LEFT")

UIDropDownMenu_Initialize(fontDropdown, function(self, level)
    for _, fontName in ipairs(LSM:List("font")) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = fontName
        info.value = fontName

        local previewFont = previewFonts[fontName]
        if not previewFont then
            previewFont = CreateFont("SimpleDamageFontPreview_" .. fontName)
            previewFont:SetFont(LSM:Fetch("font", fontName, true), 12, "")
            previewFonts[fontName] = previewFont
        end
        info.fontObject = previewFont

        info.func = function(self)
            UIDropDownMenu_SetSelectedValue(fontDropdown, self.value)
        end

        UIDropDownMenu_AddButton(info)
    end
end)

local applyButton = CreateFrame("Button", "SimpleDamageFontApplyButton", settingsPanel, "UIPanelButtonTemplate")
applyButton:SetSize(100, 22)
applyButton:SetPoint("TOPLEFT", fontDropdown, "BOTTOMLEFT", 16, -8)
applyButton:SetText("Apply")

applyButton:SetScript("OnClick", function()
    local selectedFont = UIDropDownMenu_GetSelectedValue(fontDropdown)
    if not selectedFont then return end

    ns.db.customFontName = selectedFont
    ns.db.customFontPath = LSM:Fetch("font", selectedFont, true) or ns.DEFAULT_FONT

    print("|cFF00FF00SimpleDamageFont:|r Font saved — log out and back in fully to apply it.")
end)

local relogNotice = settingsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
relogNotice:SetPoint("TOPLEFT", applyButton, "BOTTOMLEFT", -16, -16)
relogNotice:SetWidth(300)
relogNotice:SetJustifyH("LEFT")
relogNotice:SetText("After clicking Apply, you must fully log out to the character selection screen and log back in for the new font to take effect. Reloading the UI (/reload) is not enough.")
relogNotice:SetTextColor(1, 0.5, 0, 1)

-- Register category
local settingsCategory = Settings.RegisterCanvasLayoutCategory(settingsPanel, "Simple Damage Font")
Settings.RegisterAddOnCategory(settingsCategory)

SLASH_SIMPLEDAMAGEFONT1 = "/sdf"
SlashCmdList["SIMPLEDAMAGEFONT"] = function(msg)
    Settings.OpenToCategory(settingsCategory.ID)  
end
