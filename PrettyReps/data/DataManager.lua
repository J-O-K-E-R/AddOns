local addonName, PrettyReps = ...

PrettyReps.DataManager = {}

-- Constants for custom header types
PrettyReps.DataManager.CustomHeaders = {
    FAVORITES = -3,
    UNOBTAINABLE = -1,
    INACTIVE = -2,
    GUILD = -4
}

-- Get/set data mode based on sort type
function PrettyReps.DataManager:UseCharacterData()
    local sortType = PrettyReps.OptionsManager:GetOption("sortType")
    return sortType == "character"
end

-- Current database version
local DB_VERSION = 1

-- Initialize the data structure
function PrettyReps.DataManager:Init()
    if PrettyRepsDB then
        local currentVersion = PrettyRepsDB.Version
        if not currentVersion or currentVersion < DB_VERSION then
            PrettyRepsDB.Version = DB_VERSION            
            local msg = string.format(
                "PrettyReps has been factory reset due to a major update.\n\n " ..
                "You will need to login to your other characters again to load their data."
            )
            self:FactoryReset(msg)
            return
        end
        
        -- Check hierarchy version and migrate if needed
        if not PrettyRepsDB.HierarchyVersion or not PrettyReps.HIERARCHY_VERSION or PrettyRepsDB.HierarchyVersion < PrettyReps.HIERARCHY_VERSION then
            self:MigrateHierarchy()
            PrettyRepsDB.HierarchyVersion = PrettyReps.HIERARCHY_VERSION
        end
    end
    
    -- Initialize saved variables with all required fields
    if not PrettyRepsDB then
        PrettyRepsDB = {}
    end
    
    -- Ensure all required fields exist FIRST
    PrettyRepsDB.Version = PrettyRepsDB.Version or DB_VERSION
    PrettyRepsDB.HierarchyVersion = PrettyRepsDB.HierarchyVersion or PrettyReps.HIERARCHY_VERSION
    PrettyRepsDB.HeaderStates = PrettyRepsDB.HeaderStates or {}
    PrettyRepsDB.FavoriteFactions = PrettyRepsDB.FavoriteFactions or {}
    PrettyRepsDB.KnownCharacters = PrettyRepsDB.KnownCharacters or {}
    PrettyRepsDB.AccountData = PrettyRepsDB.AccountData or {}
    
    -- Initialize default header states if not already set
    for _, customID in pairs(self.CustomHeaders) do
        if PrettyRepsDB.HeaderStates[customID] == nil then
            -- Favorites starts expanded, others start collapsed
            PrettyRepsDB.HeaderStates[customID] = (customID ~= self.CustomHeaders.FAVORITES)
        end
    end
    
    -- Initialize memory-only character data
    self.CurrentCharacterData = nil
    
    -- Now build initial structure if needed
    if not PrettyRepsDB.AccountData or not next(PrettyRepsDB.AccountData) then
        PrettyRepsDB.AccountData = self:BuildInitialStructure()
    end
end

-- Factory reset the addon
function PrettyReps.DataManager:FactoryReset(completionMessage)
    PrettyRepsDB = {
        Version = DB_VERSION,  -- Preserve version to prevent re-reset
        HierarchyVersion = PrettyReps.HIERARCHY_VERSION,
        HeaderStates = {},
        FavoriteFactions = {},
        KnownCharacters = {},
        AccountData = {}
    }
    
    PrettyReps.OptionsManager:Init()
    PrettyRepsDB.AccountData = self:BuildInitialStructure()
    
    -- Reset memory-only character data
    self.CurrentCharacterData = nil
    
    -- Update with current server data
    self:UpdateFromServer()
    
    -- Show completion dialog
    StaticPopupDialogs["PRETTYREPS_FACTORY_RESET_COMPLETE"] = {
        text = completionMessage or "PrettyReps has been factory reset.",
        button1 = "OK",
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("PRETTYREPS_FACTORY_RESET_COMPLETE")
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

-- Check if a faction ID represents a custom header
function PrettyReps.DataManager:IsCustomHeader(factionID)
    if not factionID then return false end
    for _, customID in pairs(self.CustomHeaders) do
        if factionID == customID then
            return true
        end
    end
    return false
end

-- Helper function to create a base faction structure
function PrettyReps.DataManager:CreateBaseFactionStructure(hierarchyNode, level)
    level = level or 0
    
    local isHeader = hierarchyNode.children and #hierarchyNode.children > 0
    
    return {
        factionID = hierarchyNode.factionID,
        name = hierarchyNode.name,
        isAlliance = hierarchyNode.isAlliance,
        isHorde = hierarchyNode.isHorde,
        isUnobtainable = hierarchyNode.isUnobtainable,
        isHeaderWithRep = hierarchyNode.isHeaderWithRep,

        -- Base fields that don't change between characters
        isHeader = isHeader,
        isChild = isHeader and (level > 0) or (level > 1),  -- Different rules for headers vs non-headers
        level = level,
        
        -- Character/Account specific fields (initialized as nil)
        currentStanding = nil,
        reaction = nil,
        isInactive = false,
        character = nil,
        lastUpdated = nil,
        hasParagon = false,
        paragonData = nil,
        isMajorFaction = false,
        majorFactionData = nil,
        isFriendship = false,
        friendshipData = nil,
        hasBonusRepGain = false,
        atWarWith = false,
        canToggleAtWar = false,
        canSetInactive = false,
        isWatched = false,
        hasBeenEncountered = false,
        isMaxLevel = false,
        children = {},
    }
end

-- Build initial data structure from hierarchy
function PrettyReps.DataManager:BuildInitialStructure()
    local function deepCopyWithFields(node, level)
        level = level or 0
        
        local copy = self:CreateBaseFactionStructure(node, level)
        
        if node.children and #node.children > 0 then
            copy.isHeader = true
            
            -- Set initial collapse state in HeaderStates
            if PrettyRepsDB.HeaderStates[copy.factionID] == nil then
                PrettyRepsDB.HeaderStates[copy.factionID] = true -- Start collapsed
            end
            
            for _, child in ipairs(node.children) do
                local childCopy = deepCopyWithFields(child, level + 1)
                table.insert(copy.children, childCopy)
            end
        end
        
        return copy
    end
    
    local template = {}
    for _, faction in ipairs(PrettyReps.FactionHierarchy) do
        table.insert(template, deepCopyWithFields(faction))
    end
    
    return template
end

-- Helper function to apply header states to data
function PrettyReps.DataManager:ApplyHeaderStates(data)
    if not data then return end
    
    local function processNode(node)
        if node.isHeader then
            node.isCollapsed = PrettyRepsDB.HeaderStates[node.factionID]
            
            if node.children then
                for _, child in ipairs(node.children) do
                    processNode(child)
                end
            end
        end
    end
    
    for _, faction in ipairs(data) do
        processNode(faction)
    end
    
    return data
end

-- Get current character identifier
function PrettyReps.DataManager:GetCurrentCharacterKey()
    return string.format("%s-%s", UnitName("player"), GetRealmName())
end

-- Initialize character data if needed
function PrettyReps.DataManager:EnsureCharacterData()
    if not self.CurrentCharacterData then
        self.CurrentCharacterData = self:BuildInitialStructure()
    end
    return self:ApplyHeaderStates(self.CurrentCharacterData)
end

-- Get the appropriate data source based on current mode
function PrettyReps.DataManager:GetDataSource()
    if self:UseCharacterData() then
        return self:EnsureCharacterData()
    else
        return self:ApplyHeaderStates(PrettyRepsDB.AccountData)
    end
end

-- Update faction collapse state
function PrettyReps.DataManager:SetFactionCollapsed(factionID, isCollapsed)
    if not factionID then return false end
    
    -- Check if state is actually changing
    if PrettyRepsDB.HeaderStates[factionID] == isCollapsed then
        return false
    end
    
    -- Update collapse state in database
    PrettyRepsDB.HeaderStates[factionID] = isCollapsed
    
    -- Handle differently based on header type
    if self:IsCustomHeader(factionID) then
        PrettyReps.Events:TriggerEvent(PrettyReps.Events.Names.FactionDataChanged)
        return true
    end

    -- For regular headers, find and update in the data structure
    local function updateFactionInData(data)
        if not data then return false end
        
        local function processNode(node)
            if node.factionID == factionID then
                node.isCollapsed = isCollapsed
                return true
            end
            
            if node.children then
                for _, child in ipairs(node.children) do
                    if processNode(child) then
                        return true
                    end
                end
            end
            return false
        end
        
        for _, faction in ipairs(data) do
            if processNode(faction) then
                return true
            end
        end
        return false
    end
    
    local currentData = self:GetDataSource()
    if updateFactionInData(currentData) then
        PrettyReps.Events:TriggerEvent(PrettyReps.Events.Names.FactionDataChanged)
        return true
    end
    
    return false
end

-- Get faction data from the appropriate source
function PrettyReps.DataManager:GetFactionData()
    return self:GetDataSource()
end

-- Find a faction in the data by ID
function PrettyReps.DataManager:GetFactionById(factionID, dataSource)
    if not factionID then return nil end
    
    local function findInNode(node)
        if node.factionID == factionID then
            return node
        end
        if node.children then
            for _, child in ipairs(node.children) do
                local found = findInNode(child)
                if found then return found end
            end
        end
        return nil
    end
    
    -- If no dataSource provided, use default
    dataSource = dataSource or self:GetDataSource()
    
    for _, faction in ipairs(dataSource) do
        local found = findInNode(faction)
        if found then return found end
    end
    return nil
end

function PrettyReps.DataManager:HasCurrentCharacterEncounteredFaction(factionID)
    if not factionID then return false end
    
    -- Get current character's data
    if not self.CurrentCharacterData then return false end
    
    -- Find faction in character data
    local faction = self:FindFactionInData(self.CurrentCharacterData, factionID)
    return faction and faction.hasBeenEncountered or false
end

-- Compare and take highest reputation value
local function GetHighestReputation(current, new)
    if not current then return new end
    if not new then return current end
    return (new > current) and new or current
end

-- Update faction data in both character and account storage
function PrettyReps.DataManager:UpdateFactionFromServer(charFaction, accountFaction, serverData)
    if not charFaction or not accountFaction or not serverData then return end
    
    local serverReputation = serverData.currentStanding
    
    -- Always update character data with server data
    if serverReputation then
        -- Update basic fields for character
        charFaction.reaction = serverData.reaction
        charFaction.description = serverData.description
        charFaction.currentStanding = serverData.currentStanding
        charFaction.currentReactionThreshold = serverData.currentReactionThreshold
        charFaction.nextReactionThreshold = serverData.nextReactionThreshold
        charFaction.atWarWith = serverData.atWarWith
        charFaction.canToggleAtWar = serverData.canToggleAtWar
        charFaction.canSetInactive = serverData.canSetInactive
        charFaction.isWatched = serverData.isWatched
        charFaction.hasBonusRepGain = serverData.hasBonusRepGain
        charFaction.hasBeenEncountered = true
        charFaction.isHeaderWithRep = serverData.isHeaderWithRep or charFaction.isHeaderWithRep
        charFaction.isAccountWide = serverData.isAccountWide

        -- Store character info
        charFaction.character = {
            name = UnitName("player"),
            realm = GetRealmName(),
            faction = UnitFactionGroup("player")
        }
        charFaction.lastUpdated = time()
        
        -- Update special reputation types for character
        if C_Reputation.IsMajorFaction(serverData.factionID) then
            charFaction.isMajorFaction = true
            local majorData = C_MajorFactions.GetMajorFactionData(serverData.factionID)
            charFaction.majorFactionData = {
                renownLevel = majorData.renownLevel,
                renownReputationEarned = majorData.renownReputationEarned,
                renownLevelThreshold = majorData.renownLevelThreshold
            }
        end
        
        local friendshipInfo = C_GossipInfo.GetFriendshipReputation(serverData.factionID)
        if friendshipInfo and friendshipInfo.friendshipFactionID > 0 then
            charFaction.isFriendship = true
            charFaction.friendshipData = friendshipInfo
        end
        
        if C_Reputation.IsFactionParagon(serverData.factionID) then
            charFaction.hasParagon = true
            local currentValue, threshold, rewardQuestID, hasRewardPending, tooLowLevel = 
                C_Reputation.GetFactionParagonInfo(serverData.factionID)
            charFaction.paragonData = {
                currentValue = currentValue,
                threshold = threshold,
                rewardQuestID = rewardQuestID,
                hasRewardPending = hasRewardPending,
                tooLowLevel = tooLowLevel
            }
        end

        -- Calculate max level status for character
        charFaction.isMaxLevel = false
        if charFaction.hasBeenEncountered then
            if charFaction.isMajorFaction then
                charFaction.isMaxLevel = charFaction.majorFactionData and C_MajorFactions.HasMaximumRenown(serverData.factionID)
            elseif charFaction.isFriendship then
                charFaction.isMaxLevel = charFaction.friendshipData and charFaction.friendshipData.nextThreshold == nil
            else
                charFaction.isMaxLevel = charFaction.reaction == 8  -- Exalted
            end
        end
    end
    
    -- Update account data if character data is higher
    local shouldUpdateAccount = false
    
    if serverReputation and (not accountFaction.currentStanding or serverReputation > accountFaction.currentStanding) then
        shouldUpdateAccount = true
    end
    
    -- Also check friendship reputation if applicable
    if charFaction.isFriendship and charFaction.friendshipData then
        local charStanding = charFaction.friendshipData.standing
        if not accountFaction.friendshipData or 
           not accountFaction.friendshipData.standing or 
           charStanding > accountFaction.friendshipData.standing then
            shouldUpdateAccount = true
        end
    end
    
    if shouldUpdateAccount then
        -- Copy all relevant fields to account data
        accountFaction.reaction = charFaction.reaction
        accountFaction.description = serverData.description
        accountFaction.currentStanding = charFaction.currentStanding
        accountFaction.currentReactionThreshold = charFaction.currentReactionThreshold
        accountFaction.nextReactionThreshold = charFaction.nextReactionThreshold
        accountFaction.atWarWith = charFaction.atWarWith
        accountFaction.canToggleAtWar = charFaction.canToggleAtWar
        accountFaction.canSetInactive = charFaction.canSetInactive
        accountFaction.hasBonusRepGain = charFaction.hasBonusRepGain
        accountFaction.hasBeenEncountered = true
        accountFaction.isHeaderWithRep = charFaction.isHeaderWithRep
        accountFaction.isAccountWide = serverData.isAccountWide
        
        -- Copy special reputation data
        accountFaction.isMajorFaction = charFaction.isMajorFaction
        accountFaction.majorFactionData = charFaction.majorFactionData
        accountFaction.isFriendship = charFaction.isFriendship
        accountFaction.friendshipData = charFaction.friendshipData
        accountFaction.hasParagon = charFaction.hasParagon
        accountFaction.paragonData = charFaction.paragonData
        accountFaction.isMaxLevel = charFaction.isMaxLevel
        
        -- Store character attribution
        accountFaction.character = charFaction.character
        accountFaction.lastUpdated = charFaction.lastUpdated
    end
end

-- Update faction data in both character and account storage
function PrettyReps.DataManager:UpdateFromServer()
    -- Get server data
    local serverData = {}
    for i = 1, C_Reputation.GetNumFactions() do
        local faction = C_Reputation.GetFactionDataByIndex(i)
        if faction then
            table.insert(serverData, faction)
        end
    end
    
    -- Get both data sources
    local charData = self:EnsureCharacterData()
    local accountData = PrettyRepsDB.AccountData
    
    -- Update each faction from server data
    for _, serverFaction in ipairs(serverData) do
        local charFaction = self:FindFactionInData(charData, serverFaction.factionID)
        local accountFaction = self:FindFactionInData(accountData, serverFaction.factionID)
        
        if charFaction and accountFaction then
            self:UpdateFactionFromServer(charFaction, accountFaction, serverFaction)
        end
    end
    
    -- Check if this is a new character before adding to known characters
    local charKey = self:GetCurrentCharacterKey()
    local isNewCharacter = not PrettyRepsDB.KnownCharacters[charKey]
    
    -- Add current character to known characters
    self:AddKnownCharacter(charKey)
    
    -- Print message if this is a new character
    if isNewCharacter then
        print("|cff33ff99PrettyReps|r: This character has not been seen before. Its reputation data has been added to your PrettyReps account data.")
    end
    
    -- Trigger update event
    PrettyReps.Events:TriggerEvent(PrettyReps.Events.Names.FactionDataChanged)
end

-- Helper function to find faction in data structure
function PrettyReps.DataManager:FindFactionInData(data, factionID)
    if not data or not factionID then return nil end
    
    local function findInNode(node)
        if node.factionID == factionID then
            return node
        end
        if node.children then
            for _, child in ipairs(node.children) do
                local found = findInNode(child)
                if found then return found end
            end
        end
        return nil
    end
    
    for _, faction in ipairs(data) do
        local found = findInNode(faction)
        if found then return found end
    end
    return nil
end

-- Known character management
function PrettyReps.DataManager:GetKnownCharacters()
    return PrettyRepsDB.KnownCharacters or {}
end

function PrettyReps.DataManager:AddKnownCharacter(character)
    PrettyRepsDB.KnownCharacters = PrettyRepsDB.KnownCharacters or {}
    PrettyRepsDB.KnownCharacters[character] = true
end

-- Flag to prevent multiple event triggers when handling related state changes (inactive/favorite)
local isInternalStateChange = false

-- Update the SetFactionInactive function to remove favorite status if needed
function PrettyReps.DataManager:SetFactionInactive(factionID, inactive)
    if not factionID then return false end
    
    local accountData = PrettyRepsDB.AccountData
    local faction = self:GetFactionById(factionID, accountData)
    if not faction then return false end

    -- If setting to inactive and faction is currently favorited, remove favorite status
    if inactive and self:IsFactionFavorite(factionID) then
        -- Set flag to prevent event trigger
        local wasInternal = isInternalStateChange
        isInternalStateChange = true
        self:SetFactionFavorite(factionID, false)  -- Call function to handle complex logic
        isInternalStateChange = wasInternal
    end

    -- Find the parent header if this is a child faction
    local parentHeader = nil
    if not faction.isHeader and faction.isChild then
        -- Search through data to find parent
        local function findParentHeader(node)
            if node.children then
                for _, child in ipairs(node.children) do
                    if child.factionID == factionID then
                        return node
                    end
                    local found = findParentHeader(child)
                    if found then return found end
                end
            end
            return nil
        end

        for _, topLevel in ipairs(accountData) do
            parentHeader = findParentHeader(topLevel)
            if parentHeader then break end
        end
    end

    if inactive then
        -- When marking as inactive, check if we should move header too
        if parentHeader then
            -- Check if all siblings will be inactive
            local allSiblingsWillBeInactive = true
            for _, child in ipairs(parentHeader.children) do
                if child.factionID ~= factionID and not self:IsFactionInactive(child.factionID) then
                    allSiblingsWillBeInactive = false
                    break
                end
            end
            
            -- If all siblings will be inactive, mark header too
            if allSiblingsWillBeInactive then
                parentHeader.isInactive = true
            end
        end
        
        -- Mark this faction as inactive
        faction.isInactive = true
        
        -- If this is a header, mark all children as inactive too
        if faction.isHeader and faction.children then
            for _, child in ipairs(faction.children) do
                child.isInactive = true
            end
        end
    else
        -- If this is a child and we're unmarking it, check if parent is marked
        if not inactive and parentHeader and self:IsFactionInactive(parentHeader.factionID) then
            -- Unmark only this child and the parent header
            faction.isInactive = false
            parentHeader.isInactive = false
        else
            -- Handle normal cases
            if faction.isHeader then
                -- Set header as inactive
                faction.isInactive = false
                
                -- Handle all children
                if faction.children then
                    for _, child in ipairs(faction.children) do
                        child.isInactive = false
                    end
                end
            else
                -- Regular faction, just set its state
                faction.isInactive = false
            end
        end
    end
    
    -- Only trigger event if not an internal state change
    if not isInternalStateChange then
        PrettyReps.Events:TriggerEvent(PrettyReps.Events.Names.FactionDataChanged)
    end
    return true
end

function PrettyReps.DataManager:IsFactionInactive(factionID)
    if not factionID then return false end
    
    -- Only check account data - inactive state is account-wide
    local accountData = PrettyRepsDB.AccountData
    local faction = self:GetFactionById(factionID, accountData)
    
    return faction and faction.isInactive or false
end

-- Update the SetFactionFavorite function to remove inactive status if needed
function PrettyReps.DataManager:SetFactionFavorite(factionID, favorite)
    if not factionID then return false end
    
    if PrettyRepsDB.FavoriteFactions[factionID] == favorite then
        return false
    end

    local accountData = PrettyRepsDB.AccountData
    local faction = self:GetFactionById(factionID, accountData)
    if not faction then return false end

    -- If setting as favorite and faction is currently inactive, remove inactive status
    if favorite and self:IsFactionInactive(factionID) then
        -- Set flag to prevent event trigger
        local wasInternal = isInternalStateChange
        isInternalStateChange = true
        self:SetFactionInactive(factionID, false)  -- Call function to handle complex logic
        isInternalStateChange = wasInternal
    end

    -- Find the parent header if this is a child faction
    local parentHeader = nil
    if not faction.isHeader and faction.isChild then
        -- Search through data to find parent
        local function findParentHeader(node)
            if node.children then
                for _, child in ipairs(node.children) do
                    if child.factionID == factionID then
                        return node
                    end
                    local found = findParentHeader(child)
                    if found then return found end
                end
            end
            return nil
        end

        for _, topLevel in ipairs(accountData) do
            parentHeader = findParentHeader(topLevel)
            if parentHeader then break end
        end
    end

    if favorite then
        -- When marking as favorite, check if we should move header too
        if parentHeader then
            -- Check if all siblings will be favorite
            local allSiblingsWillBeFavorite = true
            for _, child in ipairs(parentHeader.children) do
                if child.factionID ~= factionID and not self:IsFactionFavorite(child.factionID) then
                    allSiblingsWillBeFavorite = false
                    break
                end
            end
            
            -- If all siblings will be favorite, mark header too
            if allSiblingsWillBeFavorite then
                PrettyRepsDB.FavoriteFactions[parentHeader.factionID] = true
            end
        end
        
        -- Mark this faction as favorite
        PrettyRepsDB.FavoriteFactions[factionID] = true
        
        -- If this is a header, mark all children as favorite too
        if faction.isHeader and faction.children then
            for _, child in ipairs(faction.children) do
                PrettyRepsDB.FavoriteFactions[child.factionID] = true
            end
        end
    else
        -- If this is a child and we're unmarking it, check if parent is marked
        if not favorite and parentHeader and self:IsFactionFavorite(parentHeader.factionID) then
            -- Unmark only this child and the parent header
            PrettyRepsDB.FavoriteFactions[factionID] = nil
            PrettyRepsDB.FavoriteFactions[parentHeader.factionID] = nil
        else
            -- Handle normal cases
            if faction.isHeader then
                -- Set header as favorite
                PrettyRepsDB.FavoriteFactions[factionID] = false
                
                -- Handle all children
                if faction.children then
                    for _, child in ipairs(faction.children) do
                        PrettyRepsDB.FavoriteFactions[child.factionID] = false
                    end
                end
            else
                -- Regular faction, just set its state
                PrettyRepsDB.FavoriteFactions[factionID] = false
            end
        end
    end
    
    -- Only trigger event if not an internal state change
    if not isInternalStateChange then
        PrettyReps.Events:TriggerEvent(PrettyReps.Events.Names.FactionDataChanged)
    end
    return true
end

function PrettyReps.DataManager:IsFactionFavorite(factionID)
    if not factionID then return false end
    return PrettyRepsDB.FavoriteFactions[factionID] or false
end

-- Set collapse state for all headers
function PrettyReps.DataManager:SetAllHeaderStates(isCollapsed)
    local function processNode(node)
        if node.isHeader then
            PrettyRepsDB.HeaderStates[node.factionID] = isCollapsed
            if node.children then
                for _, child in ipairs(node.children) do
                    processNode(child)
                end
            end
        end
    end
    
    -- Process all headers in current data source
    local currentData = self:GetDataSource()
    for _, faction in ipairs(currentData) do
        processNode(faction)
    end
    
    -- Also set state for custom headers
    for _, customID in pairs(self.CustomHeaders) do
        PrettyRepsDB.HeaderStates[customID] = isCollapsed
    end
    
    -- Trigger update
    PrettyReps.Events:TriggerEvent(PrettyReps.Events.Names.FactionDataChanged)
end

-- Expand all headers
function PrettyReps.DataManager:ExpandAll()
    self:SetAllHeaderStates(false)
end

-- Collapse all headers
function PrettyReps.DataManager:CollapseAll()
    self:SetAllHeaderStates(true)
end

-- Migrate hierarchy data to include new factions and updates
function PrettyReps.DataManager:MigrateHierarchy()
    -- Print migration message
    print("|cff33ff99PrettyReps|r: Updating reputation data with new or updated factions...")

    local function migrateNode(hierarchyNode, dataSource, parentNode, level)
        level = level or 0
        
        -- Find existing faction in data
        local existingFaction = self:FindFactionInData(dataSource, hierarchyNode.factionID)
        
        -- If faction doesn't exist, create it
        if not existingFaction then
            existingFaction = self:CreateBaseFactionStructure(hierarchyNode, level)
        end
        
        -- Always update basic fields from hierarchy, whether new or existing
        existingFaction.name = hierarchyNode.name
        existingFaction.isAlliance = hierarchyNode.isAlliance
        existingFaction.isHorde = hierarchyNode.isHorde
        existingFaction.isUnobtainable = hierarchyNode.isUnobtainable
        existingFaction.isHeaderWithRep = hierarchyNode.isHeaderWithRep
        existingFaction.level = level
        
        -- Use same logic as CreateBaseFactionStructure
        local isHeader = hierarchyNode.children and #hierarchyNode.children > 0
        existingFaction.isHeader = isHeader
        existingFaction.isChild = isHeader and (level > 0) or (level > 1)
        
        -- Handle children
        if hierarchyNode.children and #hierarchyNode.children > 0 then
            existingFaction.isHeader = true
            
            -- Create new children array to preserve hierarchy order
            local newChildren = {}
            local existingChildrenMap = {}
            
            -- Map existing children by ID for easy lookup
            for _, child in ipairs(existingFaction.children) do
                existingChildrenMap[child.factionID] = child
            end
            
            -- Process children in hierarchy order
            for _, childNode in ipairs(hierarchyNode.children) do
                local childFaction = migrateNode(childNode, dataSource, existingFaction, level + 1)
                table.insert(newChildren, childFaction)
            end
            
            -- Replace children array with new ordered array
            existingFaction.children = newChildren
        end
        
        return existingFaction
    end
    
    -- Helper function to rebuild data source in correct order
    local function rebuildDataSource(dataSource)
        local newDataSource = {}
        local factionMap = {}
        
        -- First, build a map of all existing factions
        local function mapFactions(node)
            factionMap[node.factionID] = node
            if node.children then
                for _, child in ipairs(node.children) do
                    mapFactions(child)
                end
            end
        end
        
        for _, faction in ipairs(dataSource) do
            mapFactions(faction)
        end
        
        -- Now rebuild in hierarchy order, only including current factions
        for _, hierarchyFaction in ipairs(PrettyReps.FactionHierarchy) do
            local updatedFaction = migrateNode(hierarchyFaction, dataSource)
            table.insert(newDataSource, updatedFaction)
        end
        
        return newDataSource
    end
    
    -- Migrate both character and account data
    if self.CurrentCharacterData then
        self.CurrentCharacterData = rebuildDataSource(self.CurrentCharacterData)
    end
    
    PrettyRepsDB.AccountData = rebuildDataSource(PrettyRepsDB.AccountData)
    
    -- Print completion message
    print("|cff33ff99PrettyReps|r: Update complete!")

    -- Notify that data has changed
    PrettyReps.Events:TriggerEvent(PrettyReps.Events.Names.FactionDataChanged)
end