local addonName, PrettyReps = ...

PrettyReps.ReputationService = {}

-- Add tracking for selected faction ID
local selectedFactionID = nil

-- Returns the total number of visible factions based on current state
function PrettyReps.ReputationService:GetNumFactions()
    return PrettyReps.UIDataProvider:GetNumFactions()
end

-- Get faction data by index in the visible list
function PrettyReps.ReputationService:GetFactionDataByIndex(index)
    return PrettyReps.UIDataProvider:GetFactionDataByIndex(index)
end

-- Get faction data directly by factionID
function PrettyReps.ReputationService:GetFactionDataByID(factionID)
    return PrettyReps.UIDataProvider:GetRawFactionData(factionID)
end

-- Get paragon info for a faction if it exists
function PrettyReps.ReputationService:GetFactionParagonInfo(factionID)
    if not factionID then return nil, nil, nil, false, true end
    
    local faction = PrettyReps.UIDataProvider:GetRawFactionData(factionID)
    if not faction or not faction.hasParagon then
        return nil, nil, nil, false, true
    end
    
    return faction.paragonData.currentValue,
           faction.paragonData.threshold,
           faction.paragonData.rewardQuestID,
           faction.paragonData.hasRewardPending,
           faction.paragonData.tooLowLevel
end

-- Get/set currently selected faction index
function PrettyReps.ReputationService:GetSelectedFaction()
    local index = PrettyReps.OptionsManager:GetOption("selectedFactionIndex") or 0
    if index == 0 then 
        selectedFactionID = nil
        return 0 
    end
    
    -- Get faction at current index
    local faction = self:GetFactionDataByIndex(index)
    
    -- If faction exists and matches our tracked ID, return the index
    if faction and faction.factionID == selectedFactionID then
        return index
    end
    
    -- Otherwise, try to find the faction by ID in current view
    if selectedFactionID then
        for i = 1, self:GetNumFactions() do
            local f = self:GetFactionDataByIndex(i)
            if f and f.factionID == selectedFactionID and not (f.isHeader and not f.isChild) then
                -- Found it, update stored index and return
                PrettyReps.OptionsManager:SetOption("selectedFactionIndex", i)
                return i
            end
        end
    end
    
    -- Faction not found in current view, clear selection
    selectedFactionID = nil
    PrettyReps.OptionsManager:SetOption("selectedFactionIndex", 0)
    return 0
end

function PrettyReps.ReputationService:SetSelectedFaction(index)
    -- If index is 0, we're clearing selection
    if index == 0 then
        selectedFactionID = nil
        PrettyReps.OptionsManager:SetOption("selectedFactionIndex", 0)
        return
    end

    -- Get faction at the requested index
    local faction = self:GetFactionDataByIndex(index)
    
    if not faction or (faction.isHeader and not faction.isChild) then
        selectedFactionID = nil
        PrettyReps.OptionsManager:SetOption("selectedFactionIndex", 0)
        return
    end

    -- Store both the index and ID
    selectedFactionID = faction.factionID
    PrettyReps.OptionsManager:SetOption("selectedFactionIndex", index)
end

-- Header collapse/expand functions
function PrettyReps.ReputationService:ExpandFactionHeader(factionIndex)
    local faction = self:GetFactionDataByIndex(factionIndex)
    if faction and faction.isHeader then
        return PrettyReps.DataManager:SetFactionCollapsed(faction.factionID, false)
    end
    return false
end

function PrettyReps.ReputationService:CollapseFactionHeader(factionIndex)
    local faction = self:GetFactionDataByIndex(factionIndex)
    if faction and faction.isHeader then
        return PrettyReps.DataManager:SetFactionCollapsed(faction.factionID, true)
    end
    return false
end

-- Filtering functions
function PrettyReps.ReputationService:SetReputationSortType(sortType)
    PrettyReps.OptionsManager:SetOption("sortType", sortType)
end

function PrettyReps.ReputationService:GetReputationSortType()
    return PrettyReps.OptionsManager:GetOption("sortType")
end

function PrettyReps.ReputationService:SetLegacyReputationsShown(shown)
    PrettyReps.OptionsManager:SetOption("showLegacy", shown)
end

function PrettyReps.ReputationService:AreLegacyReputationsShown()
    return PrettyReps.OptionsManager:GetOption("showLegacy")
end

function PrettyReps.ReputationService:SetGroupUnobtainable(enabled)
    PrettyReps.OptionsManager:SetOption("groupUnobtainable", enabled)
end

function PrettyReps.ReputationService:IsGroupUnobtainable()
    return PrettyReps.OptionsManager:GetOption("groupUnobtainable")
end

-- Special reputation type checks
function PrettyReps.ReputationService:IsMajorFaction(factionID)
    if not factionID then return false end
    
    local faction = self:GetFactionDataByID(factionID)
    if not faction then return false end
    
    return faction.isMajorFaction
end

function PrettyReps.ReputationService:IsFactionParagon(factionID)
    if not factionID then return false end
    
    local faction = self:GetFactionDataByID(factionID)
    if not faction then return false end
    
    return faction.hasParagon
end

function PrettyReps.ReputationService:HasCurrentCharacterEncounteredFaction(factionID)
    return PrettyReps.DataManager:HasCurrentCharacterEncounteredFaction(factionID)
end

-- Set a faction as watched or unwatched
function PrettyReps.ReputationService:SetFactionWatched(factionID)
    if not factionID then return end
    PrettyReps.FactionScanner:SetWatchedFactionByID(factionID)
end

-- Get the currently watched faction ID, if any
function PrettyReps.ReputationService:GetWatchedFactionID()
    return PrettyReps.FactionScanner:GetWatchedFactionID()
end

-- Check if a specific faction is currently watched
function PrettyReps.ReputationService:IsFactionWatched(factionID)
    if not factionID then return false end
    return self:GetWatchedFactionID() == factionID
end

function PrettyReps.ReputationService:SetFactionAtWar(factionID, atWar)
    if not factionID then return end
    PrettyReps.FactionScanner:SetFactionAtWar(factionID, atWar)
end

function PrettyReps.ReputationService:IsFactionAtWar(factionID)
    if not factionID then return false end
    
    return PrettyReps.FactionScanner:IsFactionAtWar(factionID)
end

function PrettyReps.ReputationService:SetFactionInactive(factionID, inactive)
    if not factionID then return end
    PrettyReps.DataManager:SetFactionInactive(factionID, inactive)
end

function PrettyReps.ReputationService:IsFactionInactive(factionID)
    if not factionID then return false end
    return PrettyReps.DataManager:IsFactionInactive(factionID)
end

function PrettyReps.ReputationService:SetFactionFavorite(factionID, favorite)
    if not factionID then return end
    PrettyReps.DataManager:SetFactionFavorite(factionID, favorite)
end

function PrettyReps.ReputationService:IsFactionFavorite(factionID)
    if not factionID then return false end
    return PrettyReps.DataManager:IsFactionFavorite(factionID)
end

function PrettyReps.ReputationService:SetHideUnobtainable(enabled)
    PrettyReps.OptionsManager:SetOption("hideUnobtainable", enabled)
end

function PrettyReps.ReputationService:IsHideUnobtainable()
    return PrettyReps.OptionsManager:GetOption("hideUnobtainable")
end

function PrettyReps.ReputationService:SetDisplayGroupTotals(enabled)
    PrettyReps.OptionsManager:SetOption("displayGroupTotals", enabled)
end

function PrettyReps.ReputationService:IsDisplayGroupTotals()
    return PrettyReps.OptionsManager:GetOption("displayGroupTotals")
end

function PrettyReps.ReputationService:SetHideInactiveGroup(enabled)
    PrettyReps.OptionsManager:SetOption("hideInactiveGroup", enabled)
end

function PrettyReps.ReputationService:IsHideInactiveGroup()
    return PrettyReps.OptionsManager:GetOption("hideInactiveGroup")
end

-- Add these functions to ReputationService
function PrettyReps.ReputationService:SetShowParagonIcons(enabled)
    PrettyReps.OptionsManager:SetOption("showParagonIcons", enabled)
end

function PrettyReps.ReputationService:IsShowParagonIcons()
    return PrettyReps.OptionsManager:GetOption("showParagonIcons")
end

function PrettyReps.ReputationService:SetHideParagonIcons(enabled)
    PrettyReps.OptionsManager:SetOption("hideParagonIcons", enabled)
end

function PrettyReps.ReputationService:IsHideParagonIcons()
    local hideIcons = PrettyReps.OptionsManager:GetOption("hideParagonIcons")
    if not hideIcons then
        return false
    end
    
    -- If we're not showing rewards or if this is called without a faction context, just return the hide setting
    if not PrettyReps.OptionsManager:GetOption("showParagonRewards") then
        return true
    end
    
    -- The actual check for rewards will happen in the reputation entry initialization
    return true
end

function PrettyReps.ReputationService:SetShowParagonRewards(enabled)
    PrettyReps.OptionsManager:SetOption("showParagonRewards", enabled)
end

function PrettyReps.ReputationService:IsShowParagonRewards()
    return PrettyReps.OptionsManager:GetOption("showParagonRewards")
end

function PrettyReps.ReputationService:SetHideGuildReputation(enabled)
    PrettyReps.OptionsManager:SetOption("hideGuildReputation", enabled)
end

function PrettyReps.ReputationService:IsHideGuildReputation()
    return PrettyReps.OptionsManager:GetOption("hideGuildReputation")
end
