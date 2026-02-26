local addonName, addon = ...
local frame = CreateFrame("Frame", "AIT_UniqueIronfurBar", UIParent)

-- SPELL CONSTANTS
local IRONFUR_ID = 192081
local URSOCS_ENDURANCE_ID = 393611
local currentDuration = 7
local activeTicks = {}

-- 1. SETTINGS & COLOR APPLY
local function ApplySettings()
    AIT_Settings = AIT_Settings or {}
    AIT_Settings.width = AIT_Settings.width or 400
    AIT_Settings.height = AIT_Settings.height or 40
    AIT_Settings.bgColor = AIT_Settings.bgColor or {0, 0, 0, 0.7}
    AIT_Settings.tickColor = AIT_Settings.tickColor or {1, 1, 1, 1}
    AIT_Settings.locked = AIT_Settings.locked or false
    
    frame:SetSize(AIT_Settings.width, AIT_Settings.height)
    
    -- Handle interactivity based on lock status
    frame:EnableMouse(not AIT_Settings.locked)
    
    if not frame.visualBG then
        frame.visualBG = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
        frame.visualBG:SetAllPoints(frame)
    end
    
    local c = AIT_Settings.bgColor
    frame.visualBG:SetColorTexture(1, 1, 1, 1)
    frame.visualBG:SetVertexColor(c[1], c[2], c[3], c[4])
end

--- 2. STANDALONE OPTIONS UI ---
local options = CreateFrame("Frame", "AIT_StandaloneOptions", UIParent, "BackdropTemplate")
options:SetSize(250, 260) -- Increased height slightly for the checkbox
options:SetPoint("CENTER")
options:SetMovable(true)
options:EnableMouse(true)
options:RegisterForDrag("LeftButton")
options:SetScript("OnDragStart", options.StartMoving)
options:SetScript("OnDragStop", options.StopMovingOrSizing)
options:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
options:SetBackdropColor(0, 0, 0, 0.9)
options:Hide()

options.title = options:CreateFontString(nil, "OVERLAY", "GameFontNormal")
options.title:SetPoint("TOP", 0, -15)
options.title:SetText("Ironfur Tracker Settings")

local close = CreateFrame("Button", nil, options, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -5, -5)

-- NEW: Lock Checkbox
local lockCB = CreateFrame("CheckButton", "AIT_LockCheckbox", options, "ChatConfigCheckButtonTemplate")
lockCB:SetPoint("TOPLEFT", 20, -40)
AIT_LockCheckboxText:SetText("Lock Bar Position")
lockCB:SetScript("OnClick", function(self)
    AIT_Settings.locked = self:GetChecked()
    ApplySettings()
end)

local function CreateSlider(text, minV, maxV, key, yOffset)
    local s = CreateFrame("Slider", nil, options, "OptionsSliderTemplate")
    s:SetPoint("TOPLEFT", 30, yOffset)
    s:SetMinMaxValues(minV, maxV)
    s:SetValueStep(1)
    s:SetObeyStepOnDrag(true)
    s.Text:SetText(text)
    s:SetScript("OnValueChanged", function(_, value) 
        AIT_Settings[key] = value 
        ApplySettings() 
    end)
    return s
end

local function CreateColorButton(text, key, xOffset, yOffset)
    local btn = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
    btn:SetSize(90, 25)
    btn:SetText(text)
    btn:SetPoint("TOPLEFT", xOffset, yOffset)
    btn:SetScript("OnClick", function()
        local c = AIT_Settings[key]
        ColorPickerFrame:SetupColorPickerAndShow({
            r = c[1], g = c[2], b = c[3], opacity = c[4], hasOpacity = true,
            swatchFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                AIT_Settings[key] = {r, g, b, ColorPickerFrame:GetColorAlpha()}
                ApplySettings()
            end,
            opacityFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                AIT_Settings[key] = {r, g, b, ColorPickerFrame:GetColorAlpha()}
                ApplySettings()
            end,
            cancelFunc = function() end,
        })
    end)
    return btn
end

-- Shifted slider/button Y offsets down to make room for checkbox
local widthS = CreateSlider("Width", 100, 800, "width", -85)
local heightS = CreateSlider("Height", 10, 100, "height", -135)
local bgB = CreateColorButton("BG Color", "bgColor", 30, -185)
local tickB = CreateColorButton("Tick Color", "tickColor", 130, -185)

-- 3. CORE LOGIC
frame:SetPoint("CENTER", 0, 0)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(self)
    if not AIT_Settings.locked then self:StartMoving() end
end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

local function CreateTick()
    local t = CreateFrame("Frame", nil, frame)
    t:SetSize(3, AIT_Settings.height)
    t.tex = t:CreateTexture(nil, "OVERLAY")
    t.tex:SetAllPoints()
    local c = AIT_Settings.tickColor
    t.tex:SetColorTexture(c[1], c[2], c[3], c[4])
    t.endTime = GetTime() + currentDuration
    table.insert(activeTicks, t)
end

frame:SetScript("OnUpdate", function()
    local now = GetTime()
    for i = #activeTicks, 1, -1 do
        local tick = activeTicks[i]
        local remaining = tick.endTime - now
        if remaining <= 0 then 
            tick:Hide() 
            table.remove(activeTicks, i)
        else
            tick:SetHeight(AIT_Settings.height)
            local progress = remaining / currentDuration
            tick:SetPoint("LEFT", frame, "LEFT", progress * AIT_Settings.width, 0)
            tick:Show()
        end
    end
end)

frame:SetScript("OnEvent", function(_, event, arg1, ...)
    if event == "ADDON_LOADED" and arg1 == addonName then
        ApplySettings()
        widthS:SetValue(AIT_Settings.width)
        heightS:SetValue(AIT_Settings.height)
        lockCB:SetChecked(AIT_Settings.locked)
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" then
        if select(2, ...) == IRONFUR_ID then CreateTick() end
    else
        currentDuration = IsPlayerSpell(URSOCS_ENDURANCE_ID) and 9 or 7
    end
end)

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("TRAIT_CONFIG_UPDATED")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

SLASH_AIT1 = "/ait"
SlashCmdList["AIT"] = function() 
    if options:IsShown() then options:Hide() else options:Show() end 
end

ApplySettings()