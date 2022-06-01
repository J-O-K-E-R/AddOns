local addonName = ...
local addon = _G[addonName]

local eventFrame = CreateFrame("Frame")
local tldrButton = CreateFrame("Button", "TLDRMissionsToggleButton", UIParent, "UIPanelButtonTemplate")
tldrButton:SetText("TL;DR")
tldrButton:SetWidth(50)
tldrButton:Hide()

tldrButton:SetScript("OnClick", function (self, button)
    addon.GUI:SetShown(not addon.GUI:IsShown())
end)

local function adventureMapOpenHandler(followerTypeID)
    if followerTypeID ~= 123 then return end
    if not IsAddOnLoaded("Blizzard_GarrisonUI") then 
        LoadAddOn("Blizzard_GarrisonUI")
    end
    tldrButton:Show()
    tldrButton:SetParent(CovenantMissionFrame)
    tldrButton:SetPoint("TOPLEFT", CovenantMissionFrame, 80, -30)
    tldrButton:SetFrameStrata("DIALOG")
    addon.GUI:SetParent(CovenantMissionFrame)
    addon.GUI:SetFrameStrata("DIALOG")
    addon.GUI:SetShown(addon.db.profile.autoShowUI)
end

local function preloadItemRewards()
    local missions = C_Garrison.GetAvailableMissions(123)
    if not missions then return end
    for _, mission in pairs(missions) do
        for _, reward in pairs(mission.rewards) do
            if reward.itemID then
                GetItemInfo(reward.itemID)
            end
        end
    end
end

local function eventHandler(self, event, ...)
    local arg1 = ...
    if event == "ADVENTURE_MAP_OPEN" then
        if arg1 ~= 123 then return end
        adventureMapOpenHandler(arg1)
        preloadItemRewards()
        if #C_Garrison.GetCompleteMissions(123) == 0 then
            addon.GUI.CompleteMissionsButton:Hide()
        else
            addon.GUI.CompleteMissionsButton:Show()
        end
    elseif (event == "ADDON_LOADED") and (addonName == arg1) then
        addon:RefreshProfile()
    elseif event == "GARRISON_MISSION_COMPLETE_RESPONSE" then
        addon:logCompletedMission(...)
    elseif event == "GARRISON_MISSION_STARTED" then
        addon:garrisonMissionStartedHandler(...)
    elseif event == "GARRISON_MISSION_FINISHED" then
        addon.GUI.CompleteMissionsButton:Show()
    end
end

eventFrame:SetScript("OnEvent", eventHandler)
eventFrame:RegisterEvent("ADVENTURE_MAP_OPEN")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("GARRISON_MISSION_COMPLETE_RESPONSE")
eventFrame:RegisterEvent("GARRISON_MISSION_STARTED")