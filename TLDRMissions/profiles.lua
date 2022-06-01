local addonName = ...
local addon = _G[addonName]
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
local LibStub = addon.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale("TLDRMissions")


function addon:RefreshProfile()
    local defaults = {
        profile = {
            selectedRewards = {
                ["*"] = nil,
            },
            excludedRewards = {
                ["*"] = nil,
            },
            hardestOrEasiest = "easy",
            fewestOrMost = "fewest",
            lowestOrHighest = "lowest",
            moreOrLessTroops = "more",
            followerXPSpecialTreatment = false,
            followerXPSpecialTreatmentMinimum = 4,
            followerXPSpecialTreatmentAlgorithm = 1,
            workPerFrame = 10,
            reputations = CopyTable(addon.reputationCurrencyIDs),
            animaCosts = {
                ["*"] = {
                    ["*"] = true,
                },
            },
            craftingCacheTypes = {
                ["*"] = {
                    ["*"] = true,
                },
            },
            animaItemQualities = {
                ["*"] = true,
            },
            runecarver = CopyTable(addon.runecarverCurrencyIDs),
            gearGoldCategories = {
                ["0-19"] = true,
                ["20-29"] = true,
                ["30-39"] = true,
                ["40-49"] = true,
                ["50-59"] = true,
                ["60-69"] = true,
                ["70-79"] = true,
                ["80-89"] = true,
                ["90-99"] = true,
                ["100+"] = true,
            },
            sanctumFeatureCategories = {
                ["*"] = true,
            },
            allowProcessingAnywhere = false,
            autoStart = false,
            estimateLimit = 30000,
            durationLower = 1,
            durationHigher = 24,
            autoShowUI = false,
            DEVTESTING = nil,
            LevelRestriction = 3,
            AnimaCostLimit = 300,
            sacrificeRemaining = false,
        }
    }
    
    if TLDRMissionsProfiles then
        for k, v in pairs(TLDRMissionsProfiles) do
            if (k ~= "profileKeys") and (k ~= "profiles") then
                TLDRMissionsProfiles[k] = nil
            end
        end
    end
    
    addon.db = LibStub("AceDB-3.0"):New("TLDRMissionsProfiles", defaults)

	addon.db.RegisterCallback(self, "OnProfileChanged", "ProfileChanged")
    addon.db.RegisterCallback(self, "OnProfileCopied", "ProfileChanged")
	addon.db.RegisterCallback(self, "OnProfileReset", "ProfileChanged")
    
    if TLDRMissionsOptions then
        if TLDRMissionsOptions.selectedRewards then
            for i = 1, 12 do
                if TLDRMissionsOptions.selectedRewards[i] == "any" then
                    TLDRMissionsOptions.selectedRewards[i] = nil
                end
                if TLDRMissionsOptions.selectedRewards[i] then
                    addon.db.profile.selectedRewards[i] = TLDRMissionsOptions.selectedRewards[i]
                end
            end
            TLDRMissionsOptions.selectedRewards = nil
        end
        
        if TLDRMissionsOptions.excludedRewards then
            for i = 1, 12 do
                if TLDRMissionsOptions.excludedRewards[i] then
                    addon.db.profile.excludedRewards[i] = TLDRMissionsOptions.excludedRewards[i]
                end
            end 
            TLDRMissionsOptions.excludedRewards = nil
        end
        
        if TLDRMissionsOptions.hardestOrEasiest then
            addon.db.profile.hardestOrEasiest = TLDRMissionsOptions.hardestOrEasiest
            TLDRMissionsOptions.hardestOrEasiest = nil
        end
        
        if TLDRMissionsOptions.fewestOrMost then
            addon.db.profile.fewestOrMost = TLDRMissionsOptions.fewestOrMost
            TLDRMissionsOptions.fewestOrMost = nil
        end
        
        if TLDRMissionsOptions.lowestOrHighest then
            addon.db.profile.lowestOrHighest = TLDRMissionsOptions.lowestOrHighest
            TLDRMissionsOptions.lowestOrHighest = nil
        end
        
        if TLDRMissionsOptions.moreOrLessTroops then
            addon.db.profile.moreOrLessTroops = TLDRMissionsOptions.moreOrLessTroops
            TLDRMissionsOptions.moreOrLessTroops = nil
        end
        
        if TLDRMissionsOptions.followerXPSpecialTreatment then
            addon.db.profile.followerXPSpecialTreatment = TLDRMissionsOptions.followerXPSpecialTreatment
            TLDRMissionsOptions.followerXPSpecialTreatment = nil
        end
        
        if TLDRMissionsOptions.followerXPSpecialTreatmentMinimum then
            addon.db.profile.followerXPSpecialTreatmentMinimum = TLDRMissionsOptions.followerXPSpecialTreatmentMinimum
            TLDRMissionsOptions.followerXPSpecialTreatmentMinimum = nil
        end
        
        if TLDRMissionsOptions.followerXPSpecialTreatmentAlgorithm then
            addon.db.profile.followerXPSpecialTreatmentAlgorithm = TLDRMissionsOptions.followerXPSpecialTreatmentAlgorithm
            TLDRMissionsOptions.followerXPSpecialTreatmentAlgorithm = nil
        end
    
        if TLDRMissionsOptions.workPerFrame then
            addon.db.profile.workPerFrame = TLDRMissionsOptions.workPerFrame
            TLDRMissionsOptions.workPerFrame = nil
        end
    
        if TLDRMissionsOptions.reputations then
            addon.db.profile.reputations = TLDRMissionsOptions.reputations
            TLDRMissionsOptions.reputations = nil
        end
        
        if TLDRMissionsOptions.craftingCacheTypes then    
            for k, v in pairs(addon.craftingCacheCategories) do
                if type(TLDRMissionsOptions.craftingCacheTypes[k]) == "table" then
                    for i = 1, 3 do
                        addon.db.profile.craftingCacheTypes[k][i] = TLDRMissionsOptions.craftingCacheTypes[k][i]
                    end
                end
            end
            TLDRMissionsOptions.craftingCacheTypes = nil
        end
        
        if TLDRMissionsOptions.animaItemQualities then
            for i = 1, 4 do
                addon.db.profile.animaItemQualities[i] = TLDRMissionsOptions.animaItemQualities[i]
            end
            TLDRMissionsOptions.animaItemQualities = nil
        end
        
        if TLDRMissionsOptions.runecarver then
            addon.db.profile.runecarver = TLDRMissionsOptions.runecarver
            TLDRMissionsOptions.runecarver = nil
        end
        
        if TLDRMissionsOptions.gearGoldCategories then
            for goldCategory, v in pairs(TLDRMissionsOptions.gearGoldCategories) do
                addon.db.profile.gearGoldCategories[goldCategory] = TLDRMissionsOptions.gearGoldCategories[goldCategory]
            end
            TLDRMissionsOptions.gearGoldCategories = nil
        end
        
        if TLDRMissionsOptions.sanctumFeatureCategories then
            for categoryName, category in pairs(addon.sanctumFeatureItems) do
                for itemID in pairs(category) do
                    if TLDRMissionsOptions.sanctumFeatureCategories[itemID] ~= nil then
                        addon.db.profile.sanctumFeatureCategories[itemID] = TLDRMissionsOptions.sanctumFeatureCategories[itemID]
                    end
                end
            end
            
            for categoryName, category in pairs(addon.sanctumFeatureCurrencies) do
                for currencyID in pairs(category) do
                    if TLDRMissionsOptions.sanctumFeatureCategories[currencyID] ~= nil then
                        addon.db.profile.sanctumFeatureCategories[currencyID] = TLDRMissionsOptions.sanctumFeatureCategories[currencyID]
                    end
                end
            end
            TLDRMissionsOptions.sanctumFeatureCategories = nil
        end
        
        if TLDRMissionsOptions.allowProcessingAnywhere ~= nil then
            addon.db.profile.allowProcessingAnywhere = TLDRMissionsOptions.allowProcessingAnywhere
            TLDRMissionsOptions.allowProcessingAnywhere = nil
        end
        
        if TLDRMissionsOptions.autoStart then
            addon.db.profile.autoStart = TLDRMissionsOptions.autoStart
            TLDRMissionsOptions.autoStart = nil
        end
        
        if TLDRMissionsOptions.estimateLimit then
            addon.db.profile.estimateLimit = TLDRMissionsOptions.estimateLimit
            TLDRMissionsOptions.estimateLimit = nil
        end
        
        if TLDRMissionsOptions.durationLower then
            addon.db.profile.durationLower = TLDRMissionsOptions.durationLower
            TLDRMissionsOptions.durationLower = nil
        end
        
        if TLDRMissionsOptions.durationHigher then
            addon.db.profile.durationHigher = TLDRMissionsOptions.durationHigher
            TLDRMissionsOptions.durationHigher = nil
        end
        
        if TLDRMissionsOptions.autoShowUI then
            addon.db.profile.autoShowUI = TLDRMissionsOptions.autoShowUI
            TLDRMissionsOptions.autoShowUI = nil
        end
        
        if TLDRMissionsOptions.DEVTESTING then
            addon.db.profile.DEVTESTING = TLDRMissionsOptions.DEVTESTING
            TLDRMissionsOptions.DEVTESTING = nil
        end
        
        if TLDRMissionsOptions.LevelRestriction then
            addon.db.profile.LevelRestriction = TLDRMissionsOptions.LevelRestriction
            TLDRMissionsOptions.LevelRestriction = nil
        end
        
        if TLDRMissionsOptions.AnimaCostLimit then
            addon.db.profile.AnimaCostLimit = TLDRMissionsOptions.AnimaCostLimit
            TLDRMissionsOptions.AnimaCostLimit = nil
        end
   end

    local function setupAnimaCostDropDown(name)
        if TLDRMissionsOptions and TLDRMissionsOptions.animaCosts and TLDRMissionsOptions.animaCosts[name] then
            addon.db.profile.animaCosts[name] = TLDRMissionsOptions.animaCosts[name]
        end
        local options = {"10-49", "50-99", "100+"}

        LibDD:UIDropDownMenu_Initialize(_G["TLDRMissions"..name.."AnimaCostDropDown"], function(self, level, menuList)
            local info = LibDD:UIDropDownMenu_CreateInfo()        
            
            for _, option in ipairs(options) do
                if TLDRMissionsOptions and TLDRMissionsOptions.animaCosts and TLDRMissionsOptions.animaCosts[name] and TLDRMissionsOptions.animaCosts[name][option] ~= nil then
                    addon.db.profile.animaCosts[name][option] = TLDRMissionsOptions.animaCosts[name][option]
                end
                
                info.text = option.." "..POWER_TYPE_ANIMA
                info.checked = addon.db.profile.animaCosts[name][option]
                info.isNotRadio = true
                info.keepShownOnClick = true
                info.arg1 = option
                info.func = function()
                    addon.db.profile.animaCosts[name][option] = not addon.db.profile.animaCosts[name][option]
                end
                LibDD:UIDropDownMenu_AddButton(info)
            end
        end)
    end
    
    setupAnimaCostDropDown("Gold")
    setupAnimaCostDropDown("Anima")
    setupAnimaCostDropDown("FollowerXPItems")
    setupAnimaCostDropDown("PetCharms")
    setupAnimaCostDropDown("AugmentRunes")
    setupAnimaCostDropDown("Reputation")
    setupAnimaCostDropDown("FollowerXP")
    setupAnimaCostDropDown("CraftingCache")
    setupAnimaCostDropDown("Runecarver")
    setupAnimaCostDropDown("Campaign")
    setupAnimaCostDropDown("Gear")
    setupAnimaCostDropDown("SanctumFeature")
    
    if TLDRMissionsOptions then
        TLDRMissionsOptions.animaCosts = nil
    end

    LibDD:UIDropDownMenu_Initialize(TLDRMissionsFollowerXPSpecialTreatmentDropDown, function(self, level, menuList)
        local info = LibDD:UIDropDownMenu_CreateInfo()
    
        for i = 1, 5 do
            info.text = MINIMUM.." "..i.." "..GARRISON_FOLLOWERS
            info.checked = tonumber(addon.db.profile.followerXPSpecialTreatmentMinimum) == i
            info.arg1 = i
            info.func = function(self, arg1)
                addon.db.profile.followerXPSpecialTreatmentMinimum = arg1
            end
            LibDD:UIDropDownMenu_AddButton(info)
        end
    end)
    
    LibDD:UIDropDownMenu_Initialize(TLDRMissionsFollowerXPSpecialTreatmentAlgorithmDropDown, function(self, level, menuList)
        local info = LibDD:UIDropDownMenu_CreateInfo()
        
        info.text = L["FollowerXPAlgorithm1Label"]
        info.checked = addon.db.profile.followerXPSpecialTreatmentAlgorithm == 1
        info.arg1 = 1
        info.func = function(self, arg1)
            addon.db.profile.followerXPSpecialTreatmentAlgorithm = arg1
        end
        LibDD:UIDropDownMenu_AddButton(info)
        info.text = L["FollowerXPAlgorithm2Label"]
        info.checked = addon.db.profile.followerXPSpecialTreatmentAlgorithm == 2
        info.arg1 = 2
        LibDD:UIDropDownMenu_AddButton(info)
        info.text = L["FollowerXPAlgorithm3Label"]
        info.checked = addon.db.profile.followerXPSpecialTreatmentAlgorithm == 3
        info.arg1 = 3
        LibDD:UIDropDownMenu_AddButton(info)
    end)

    LibDD:UIDropDownMenu_Initialize(TLDRMissionsReputationDropDown, function(self, level, menuList)
        local info = LibDD:UIDropDownMenu_CreateInfo()
    
        for currencyID, _ in pairs(addon.reputationCurrencyIDs) do
            info.text = C_CurrencyInfo.GetCurrencyInfo(currencyID).name
            info.checked = addon.db.profile.reputations[currencyID]
            info.isNotRadio = true
            info.keepShownOnClick = true
            info.arg1 = currencyID
            info.func = addon.GUI.ReputationDropDown.OnSelect
            LibDD:UIDropDownMenu_AddButton(info)
        end
    end) 
    
    LibDD:UIDropDownMenu_Initialize(TLDRMissionsCraftingCacheDropDown, function(self, level, menuList)
        local info = LibDD:UIDropDownMenu_CreateInfo()
        
        if level == 1 then
            for categoryIndex, name in pairs(addon.craftingCacheCategories) do
                info.text = name
                info.hasArrow = true
                info.notCheckable = true
                info.keepShownOnClick = true
                info.menuList = categoryIndex
                LibDD:UIDropDownMenu_AddButton(info)
            end
        elseif menuList then
            info.text = "|cFFFFFFFF"..ITEM_QUALITY1_DESC.."|r"
            info.checked = addon.db.profile.craftingCacheTypes[menuList][1]
            info.isNotRadio = true
            info.keepShownOnClick = true
            info.arg1 = menuList
            info.arg2 = 1
            info.func = addon.GUI.CraftingCacheDropDown.OnSelect
            LibDD:UIDropDownMenu_AddButton(info, level)
            info.text = "|cFF00FF00"..ITEM_QUALITY2_DESC.."|r"
            info.checked = addon.db.profile.craftingCacheTypes[menuList][2]
            info.arg1 = menuList
            info.arg2 = 2
            info.func = addon.GUI.CraftingCacheDropDown.OnSelect
            LibDD:UIDropDownMenu_AddButton(info, level)
            info.text = "|cFF0000FF"..ITEM_QUALITY3_DESC.."|r"
            info.checked = addon.db.profile.craftingCacheTypes[menuList][3]
            info.arg1 = menuList
            info.arg2 = 3
            info.func = addon.GUI.CraftingCacheDropDown.OnSelect
            LibDD:UIDropDownMenu_AddButton(info, level)
        end
    end)

    LibDD:UIDropDownMenu_Initialize(TLDRMissionsAnimaDropDown, function(self, level, menuList)
        local info = LibDD:UIDropDownMenu_CreateInfo()
        
        info.isNotRadio = true
        info.keepShownOnClick = true
        info.func = addon.GUI.AnimaDropDown.OnSelect
        
        info.text = "|cFF00FF00"..ITEM_QUALITY2_DESC.."|r"
        info.checked = addon.db.profile.animaItemQualities[2]
        info.arg1 = 2
        LibDD:UIDropDownMenu_AddButton(info, level)
        
        info.text = "|cFF0000FF"..ITEM_QUALITY3_DESC.."|r"
        info.checked = addon.db.profile.animaItemQualities[3]
        info.arg1 = 3
        LibDD:UIDropDownMenu_AddButton(info, level)
        
        info.text = "|cFFA020F0"..ITEM_QUALITY4_DESC.."|r"
        info.checked = addon.db.profile.animaItemQualities[4]
        info.arg1 = 4
        LibDD:UIDropDownMenu_AddButton(info, level)
    end)
    
    LibDD:UIDropDownMenu_Initialize(TLDRMissionsRunecarverDropDown, function(self, level, menuList)
        local info = LibDD:UIDropDownMenu_CreateInfo()
        
        info.isNotRadio = true
        info.keepShownOnClick = true
        info.func = addon.GUI.RunecarverDropDown.OnSelect
        for currencyID, name in pairs(addon.runecarverCurrencyIDs) do
            info.text = C_CurrencyInfo.GetCurrencyInfo(currencyID).name
            info.checked = addon.db.profile.runecarver[currencyID]
            info.arg1 = currencyID
            LibDD:UIDropDownMenu_AddButton(info)
        end
    end)
    

    local goldCategories = {
        "0-19",
        "20-29",
        "30-39",
        "40-49",
        "50-59",
        "60-69",
        "70-79",
        "80-89",
        "90-99",
        "100+",
    }
    
    LibDD:UIDropDownMenu_Initialize(TLDRMissionsGearDropDown, function(self, level, menuList)
        local info = LibDD:UIDropDownMenu_CreateInfo()
        info.isNotRadio = true
        info.keepShownOnClick = true
        info.func = addon.GUI.GearDropDown.OnSelect
        
        for _, goldCategory in ipairs(goldCategories) do
            info.text = goldCategory.." "..BATTLE_PET_SOURCE_3.." "..BONUS_ROLL_REWARD_MONEY -- hope that doesn't get lost in translation :|
            info.checked = addon.db.profile.gearGoldCategories[goldCategory]
            info.arg1 = goldCategory
            LibDD:UIDropDownMenu_AddButton(info)
        end
    end)
    
    local function isAnySanctumFeatureCategoryChecked(categoryName)
        for itemID in pairs(addon.sanctumFeatureItems[categoryName]) do
            if addon.db.profile.sanctumFeatureCategories[itemID] then
                return true
            end
        end
        for currencyID in pairs(addon.sanctumFeatureCurrencies[categoryName]) do
            if addon.db.profile.sanctumFeatureCategories[currencyID] then
                return true
            end
        end
        return false
    end
    
    local itemNameCache = {}
    LibDD:UIDropDownMenu_Initialize(TLDRMissionsSanctumFeatureDropDown, function(self, level, menuList)
        local info = LibDD:UIDropDownMenu_CreateInfo()
        info.isNotRadio = true
        info.func = addon.GUI.SanctumFeatureDropDown.OnSelect
        info.keepShownOnClick = true
        
        if level == 1 then
            for categoryName, category in pairs(addon.sanctumFeatureItems) do
                info.text = categoryName
                info.hasArrow = true
                info.arg1 = categoryName
                info.menuList = categoryName
                info.checked = isAnySanctumFeatureCategoryChecked(categoryName)
                LibDD:UIDropDownMenu_AddButton(info)
            end
        elseif menuList then
            for itemID in pairs(addon.sanctumFeatureItems[menuList]) do
                local itemName = itemNameCache[itemID] or "Loading..."
                info.text = itemName
                info.checked = addon.db.profile.sanctumFeatureCategories[itemID]
                info.arg1 = itemID
                LibDD:UIDropDownMenu_AddButton(info, level)
            end
            
            for currencyID in pairs(addon.sanctumFeatureCurrencies[menuList]) do
                info.text = C_CurrencyInfo.GetCurrencyInfo(currencyID).name or "Loading..."
                info.checked = addon.db.profile.sanctumFeatureCategories[currencyID]
                info.arg1 = currencyID
                LibDD:UIDropDownMenu_AddButton(info, level)
            end
        end
    end)
    
    --preload the items
    for categoryName, category in pairs(addon.sanctumFeatureItems) do
        for itemID in pairs(category) do
            local item = Item:CreateFromItemID(itemID)
            item:ContinueOnItemLoad(function()
            	itemNameCache[itemID] = item:GetItemName()
            end)
        end
    end
    
    if not TLDRMissionsLogging then
        TLDRMissionsLogging = {}
    end
    
    if not TLDRMissionsCache then
        TLDRMissionsCache = {}
    end
    
    -- wipe obsolete data from previous versions of the addon - cannot be relied upon anymore
    for addonVersion, _ in pairs(TLDRMissionsCache) do
        if addonVersion ~= GetAddOnMetadata(addonName, "Version") then
            TLDRMissionsCache[addonVersion] = nil
        end
    end
    
    if not TLDRMissionsCache[GetAddOnMetadata(addonName, "Version")] then
        TLDRMissionsCache[GetAddOnMetadata(addonName, "Version")] = {}
    end
    
    local options = {type = "group", args = {}}
    LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonName)
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options, {"tldrmissions"})
    options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, nil, nil, "profiles")
    
    addon:ProfileChanged()
end
    
    
function addon:ProfileChanged()
    addon.GUI.CalculateButton:SetEnabled(false)
    for i = 1, 12 do
        if addon.db.profile.selectedRewards[i] then
            addon.GUI.CalculateButton:SetEnabled(true)
            break
        end
    end
    if addon.db.profile.sacrificeRemaining then
        addon.GUI.CalculateButton:SetEnabled(true)
    end    
    addon.GUI.SacrificeCheckButton:SetChecked(addon.db.profile.sacrificeRemaining)
    
    addon.GUI.HardestRadioButton:SetChecked(addon.db.profile.hardestOrEasiest == "hard")
    addon.GUI.EasiestRadioButton:SetChecked(addon.db.profile.hardestOrEasiest ~= "hard")
    
    addon.GUI.FewestRadioButton:SetChecked(addon.db.profile.fewestOrMost ~= "most")
    addon.GUI.MostRadioButton:SetChecked(addon.db.profile.fewestOrMost == "most")
    
    addon.GUI.LowestRadioButton:SetChecked(addon.db.profile.lowestOrHighest ~= "highest")
    addon.GUI.HighestRadioButton:SetChecked(addon.db.profile.lowestOrHighest == "highest")
    
    addon.GUI.MoreTroopsRadioButton:SetChecked(addon.db.profile.moreOrLessTroops ~= "less")
    addon.GUI.LessTroopsRadioButton:SetChecked(addon.db.profile.moreOrLessTroops == "less")
    
    addon.GUI.LowerBoundLevelRestrictionSlider:SetValue(addon.db.profile.LevelRestriction)
    addon.GUI.AnimaCostLimitSlider:SetValue(addon.db.profile.AnimaCostLimit)
    addon.GUI.FollowerXPSpecialTreatmentCheckButton:SetChecked(addon.db.profile.followerXPSpecialTreatment)  
    addon.GUI.SimulationsPerFrameSlider:SetValue(addon.db.profile.workPerFrame)    
    addon.GUI.AutoShowButton:SetChecked(addon.db.profile.autoShowUI)
    addon.GUI.MaxSimulationsEditBox:SetText(addon.db.profile.estimateLimit)
    
    addon.GUI.AllowProcessingAnywhereButton:SetChecked(addon.db.profile.allowProcessingAnywhere)
    
    addon.GUI.AutoStartButton:SetChecked(addon.db.profile.autoStart)
    
    TLDRMissionsFrameDurationLowerSliderText:SetText(L["DurationTimeSelectedLabel"]:format(addon.db.profile.durationLower, addon.db.profile.durationHigher))
    TLDRMissionsFrameDurationLowerSlider:SetValue(addon.db.profile.durationLower)
    TLDRMissionsFrameDurationHigherSlider:SetValue(addon.db.profile.durationHigher)
    
    addon:updateRewards()
end