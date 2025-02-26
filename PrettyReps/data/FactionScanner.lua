local addonName, PrettyReps = ...

PrettyReps.FactionScanner = {
    eventFrame = CreateFrame("Frame"),
    state = {
        expansionQueue = {},
        isExpanding = false,
        callback = nil
    }
}

-- Helper function to reset state with optional callback
local function resetState(self, callback)
    self.state = {
        expansionQueue = {},
        isExpanding = false,
        waitingForServer = false,
        callback = callback or nil
    }
    
    self.eventFrame:UnregisterAllEvents()
    self.eventFrame:SetScript("OnEvent", nil)
end

function PrettyReps.FactionScanner:Init()
    resetState(self)
    -- Add flag to track if we're currently scanning
    self.isScanning = false
end

function PrettyReps.FactionScanner:RevealAllFactions(callback)
    if self.state.isExpanding then
        return
    end

    resetState(self, callback)
    
    -- Check if there are any collapsed headers
    local hasCollapsedHeaders = false
    for i = 1, C_Reputation.GetNumFactions() do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        if factionData and factionData.isHeader and factionData.isCollapsed then
            hasCollapsedHeaders = true
            break
        end
    end
    
    if hasCollapsedHeaders then
        self:StartExpansion()
    else
        -- If no headers need expanding, just call the callback immediately
        if self.state.callback then
            self.state.callback()
            self.state.callback = nil
        end
    end
end

function PrettyReps.FactionScanner:StartExpansion()
    self.state.isExpanding = true
    -- Set scanning flag
    self.isScanning = true
    self:RegisterUpdateFactionEvent()
    self:QueueHeadersForExpansion()
end

function PrettyReps.FactionScanner:QueueHeadersForExpansion()
    self.state.expansionQueue = {}
    
    for i = 1, C_Reputation.GetNumFactions() do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        if factionData and factionData.isHeader and factionData.isCollapsed then
            table.insert(self.state.expansionQueue, i)
        end
    end
    
    if not self.state.waitingForServer then
        self:ProcessNextExpansion()
    end
end

function PrettyReps.FactionScanner:ProcessNextExpansion()
    if #self.state.expansionQueue == 0 then
        self:UnregisterUpdateFactionEvent()
        self:Cleanup()
        return
    end

    local index = table.remove(self.state.expansionQueue, 1)
    local factionData = C_Reputation.GetFactionDataByIndex(index)
    if factionData then
        self.state.waitingForServer = true
        C_Reputation.ExpandFactionHeader(index)
    end
end

function PrettyReps.FactionScanner:RegisterUpdateFactionEvent()
    self.eventFrame:RegisterEvent("UPDATE_FACTION")
    self.eventFrame:SetScript("OnEvent", function(_, event)
        if event == "UPDATE_FACTION" and self.state.waitingForServer then
            self.state.waitingForServer = false
            self:QueueHeadersForExpansion()
        end
    end)
end

function PrettyReps.FactionScanner:UnregisterUpdateFactionEvent()
    self.eventFrame:UnregisterEvent("UPDATE_FACTION")
    self.eventFrame:SetScript("OnEvent", nil)
end

function PrettyReps.FactionScanner:Cleanup()
    self.state.isExpanding = false
    
    -- Do final update and reset scanning flag
    self.isScanning = false
    
    -- Update with complete data
    PrettyReps.DataManager:UpdateFromServer()
    
    -- Call callback if one was provided
    if self.state.callback then
        self.state.callback()
        self.state.callback = nil
    end
    
    self:Init()
end

function PrettyReps.FactionScanner:SetWatchedFactionByID(factionID)
    if not factionID then return false end

    if factionID == 0 then
        C_Reputation.SetWatchedFactionByIndex(0)
        return
    end

    local function findAndSetFaction()
        for i = 1, C_Reputation.GetNumFactions() do
            local factionData = C_Reputation.GetFactionDataByIndex(i)
            if factionData and factionData.factionID == factionID then
                C_Reputation.SetWatchedFactionByIndex(i)
                return true
            end
        end
        return false
    end

    if findAndSetFaction() then
        return
    end

    self:RevealAllFactions(function()
        findAndSetFaction()
    end)    
end

function PrettyReps.FactionScanner:IsFactionAtWar(factionID)
    if not factionID then return false end

    -- Iterate through visible factions to find the watched one
    for i = 1, C_Reputation.GetNumFactions() do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        if factionData and factionData.factionID == factionID then
            return factionData.atWarWith
        end
    end
    return nil
end

function PrettyReps.FactionScanner:GetWatchedFactionID()
    -- Iterate through visible factions to find the watched one
    for i = 1, C_Reputation.GetNumFactions() do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        if factionData and factionData.isWatched then
            return factionData.factionID
        end
    end
    return nil
end

function PrettyReps.FactionScanner:SetFactionAtWar(factionID, atWar)
    if not factionID then return false end

    local function findAndSetAtWar()
        for i = 1, C_Reputation.GetNumFactions() do
            local factionData = C_Reputation.GetFactionDataByIndex(i)
            if factionData and factionData.factionID == factionID then
                C_Reputation.ToggleFactionAtWar(i)
                return true
            end
        end
        return false
    end

    -- Try to find and set immediately
    if findAndSetAtWar() then
        return true
    end

    -- If not found, reveal all and try again
    self:RevealAllFactions(function()
        findAndSetAtWar()
    end)
    
    return true
end

function PrettyReps.FactionScanner:GetGuildFactionData()
    -- Check if player is in a guild
    if not IsInGuild() then
        return nil
    end

    -- Get guild info
    local guildName = GetGuildInfo("player")
    if not guildName then
        return nil
    end

    -- Find guild faction in server data
    for i = 1, C_Reputation.GetNumFactions() do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        if factionData and factionData.name == guildName then
            -- Build faction data structure
            return {
                factionID = factionData.factionID,
                name = guildName,
                description = factionData.description,
                reaction = factionData.reaction,
                currentStanding = factionData.currentStanding,
                currentReactionThreshold = factionData.currentReactionThreshold,
                nextReactionThreshold = factionData.nextReactionThreshold,
                isHeader = false,
                isChild = false,
                hasBeenEncountered = true,
                isGuildFaction = true,
                atWarWith = false,
                canToggleAtWar = false,
                isWatched = factionData.isWatched,
                hasBonusRepGain = factionData.hasBonusRepGain,
                isMaxLevel = factionData.reaction == 8  -- Set isMaxLevel based on Exalted status
            }
        end
    end

    return nil
end

return PrettyReps.FactionScanner