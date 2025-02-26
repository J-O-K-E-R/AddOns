local addonName, PrettyReps = ...

PrettyReps.DataTransformer = {}

-- Filter a single faction based on options
local function filterFaction(faction, options, parentFaction)
    if not faction then return false end
    
    -- For headers, check if any children would be visible
    if faction.isHeader then
        -- If this is a custom header, always show it (it will be removed later if empty)
        if faction.isCustomHeader then
            return true
        end
        
        -- For regular headers, only show if they have rep themselves or if they have visible children
        if not faction.isHeaderWithRep then
            -- Will check children later in processNode
            return true
        end
    end
    
    -- Not encountered filter - only apply to non-headers or headers with rep
    if not options.showNotEncountered and not faction.hasBeenEncountered and 
       (not faction.isHeader or faction.isHeaderWithRep) then
        return false
    end
    
    -- Active/Inactive filter
    if not options.showInactive and faction.isInactive then
        return false
    end
    
    -- Legacy filter
    if not options.showLegacy and faction.isLegacy then
        return false
    end
    
    -- Opposite faction filter
    if not options.showOppositeFaction then
        local playerIsAlliance = UnitFactionGroup("player") == "Alliance"
        -- Check both the faction itself and inherit from parent
        local isOpposingFaction = (faction.isHorde or (parentFaction and parentFaction.isHorde)) and playerIsAlliance or
                                 (faction.isAlliance or (parentFaction and parentFaction.isAlliance)) and not playerIsAlliance
        if isOpposingFaction then
            return false
        end
    end
    
    return true
end

-- Collects unobtainable factions and adds them to unobtainableList
local function collectUnobtainableFactions(node, unobtainableList)
    if not node then return false end
    
    -- Check if this node is unobtainable AND not at max level
    local isUnobtainable = node.isUnobtainable and not node.isMaxLevel
    
    if isUnobtainable then
        -- Create a deep copy before modifying
        local unobtainableNode = CopyTable(node)
        unobtainableNode.isChild = false
        unobtainableNode.children = {} -- Clear children since they'll be collected separately
        table.insert(unobtainableList, unobtainableNode)
        return true
    end
    
    -- Process children recursively
    if node.children then
        for _, child in ipairs(node.children) do
            collectUnobtainableFactions(child, unobtainableList)
        end
    end
    
    return isUnobtainable
end

-- Removes unobtainable factions from their original locations
local function removeUnobtainableFactions(node)
    if not node then return false end
    
    local isUnobtainable = node.isUnobtainable and not node.isMaxLevel
    if isUnobtainable then
        return true -- Signal that this node should be removed
    end
    
    -- Process children if they exist
    if node.children then
        local newChildren = {}
        local anyRemoved = false
        
        for _, child in ipairs(node.children) do
            if not removeUnobtainableFactions(child) then
                table.insert(newChildren, child)
            else
                anyRemoved = true
            end
        end
        
        node.children = newChildren
        
        -- If this was a header and now has no children, mark it for removal
        -- unless it's a custom header (which should stay even if empty)
        if node.isHeader and #newChildren == 0 and not node.isCustomHeader then
            return true
        end
    end
    
    return isUnobtainable
end

-- Main transformation logic for unobtainable factions
local function handleUnobtainableFactions(transformedData, options)
    if not options.groupUnobtainable then return transformedData end
    
    -- Collect all unobtainable factions
    local unobtainableList = {}
    for _, faction in ipairs(transformedData) do
        collectUnobtainableFactions(faction, unobtainableList)
    end
    
    -- Remove unobtainable factions from their original locations
    local newTransformedData = {}
    for _, faction in ipairs(transformedData) do
        if not removeUnobtainableFactions(faction) then
            table.insert(newTransformedData, faction)
        end
    end
    
    -- Create unobtainable group if we found any unobtainable factions
    -- and hideUnobtainable is not enabled
    if #unobtainableList > 0 and not options.hideUnobtainable then
        local customHeaderID = PrettyReps.DataManager.CustomHeaders.UNOBTAINABLE
        local isCollapsed = PrettyRepsDB.HeaderStates[customHeaderID] ~= false
        local unobtainableHeader = {
            factionID = customHeaderID,
            name = "Unobtainable",
            isHeader = true,
            isChild = false,
            isCollapsed = isCollapsed,
            isCustomHeader = true,
            children = unobtainableList
        }
        table.insert(newTransformedData, unobtainableHeader)
    end
    
    return newTransformedData
end

local function collectInactiveFactions(node, inactiveList)
    if not node then return false end
    
    -- Check if this node is inactive
    local isInactive = PrettyReps.DataManager:IsFactionInactive(node.factionID)
    
    if isInactive then
        -- Create a deep copy before modifying
        local inactiveNode = CopyTable(node)
        inactiveNode.isInactive = true
        
        -- If this is a header, include all children
        if inactiveNode.isHeader then
            -- Keep the children array and copy all children
            for i, child in ipairs(inactiveNode.children) do
                inactiveNode.children[i] = CopyTable(child)
                inactiveNode.children[i].isChild = true
                inactiveNode.children[i].isInactive = true
            end
        else
            -- Regular faction or child, no children array needed
            inactiveNode.children = {}
            inactiveNode.isChild = false
        end
        
        table.insert(inactiveList, inactiveNode)
        return true
    end
    
    -- If not inactive, process children recursively
    if node.children then
        for _, child in ipairs(node.children) do
            collectInactiveFactions(child, inactiveList)
        end
    end
    
    return isInactive
end

-- Removes inactive factions from their original locations
local function removeInactiveFactions(node)
    if not node then return false end
    
    local isInactive = PrettyReps.DataManager:IsFactionInactive(node.factionID)
    
    -- If this is a header and it's inactive, remove it and all children
    if node.isHeader and isInactive then
        return true
    end
    
    -- If this is an inactive non-header or child, remove it
    if isInactive and not node.isHeader then
        return true
    end
    
    -- Process children if they exist
    if node.children then
        local newChildren = {}
        local anyRemoved = false
        
        for _, child in ipairs(node.children) do
            if not removeInactiveFactions(child) then
                table.insert(newChildren, child)
            else
                anyRemoved = true
            end
        end
        
        node.children = newChildren
        
        -- If this was a header and now has no children
        if node.isHeader and #newChildren == 0 then
            -- Keep header with rep as regular faction
            if node.isHeaderWithRep then
                node.isHeader = false
                node.isHeaderWithRep = false
                node.isChild = false
                return false
            end
            -- Remove regular header with no children
            return true
        end
    end
    
    return false
end

local function handleInactiveFactions(transformedData, options)    
    -- Always collect inactive factions
    local inactiveList = {}
    for _, faction in ipairs(transformedData) do
        collectInactiveFactions(faction, inactiveList)
    end
    
    -- Remove inactive factions from their original locations
    local newTransformedData = {}
    for _, faction in ipairs(transformedData) do
        if not removeInactiveFactions(faction) then
            table.insert(newTransformedData, faction)
        end
    end
    
    -- Create inactive group if we found any inactive factions and not hiding
    if #inactiveList > 0 and not options.hideInactiveGroup then
        local customHeaderID = PrettyReps.DataManager.CustomHeaders.INACTIVE
        local isCollapsed = PrettyRepsDB.HeaderStates[customHeaderID] ~= false
        local inactiveHeader = {
            factionID = customHeaderID,
            name = "Inactive",
            isHeader = true,
            isChild = false,
            isCollapsed = isCollapsed,
            isCustomHeader = true,
            children = inactiveList
        }
        table.insert(newTransformedData, inactiveHeader)
    end
    
    return newTransformedData
end

local function collectFavoriteFactions(node, favoriteList)
    if not node then return false end
    
    -- Check if this node is a favorite
    local isFavorite = PrettyReps.DataManager:IsFactionFavorite(node.factionID)
    
    if isFavorite then
        -- Create a deep copy before modifying
        local favoriteNode = CopyTable(node)
        favoriteNode.isFavorite = true
        
        -- If this is a header, include all children regardless of rep status
        if favoriteNode.isHeader then
            -- Keep the children array and copy all children
            for i, child in ipairs(favoriteNode.children) do
                favoriteNode.children[i] = CopyTable(child)
                favoriteNode.children[i].isChild = true
                favoriteNode.children[i].isFavorite = true
            end
        else
            -- Regular faction or child, no children array needed
            favoriteNode.children = {}
            favoriteNode.isChild = false
        end
        
        table.insert(favoriteList, favoriteNode)
        return true
    end
    
    -- If not favorite, process children recursively
    if node.children then
        for _, child in ipairs(node.children) do
            collectFavoriteFactions(child, favoriteList)
        end
    end
    
    return isFavorite
end

local function removeFavoriteFactions(node)
    if not node then return false end
    
    local isFavorite = PrettyReps.DataManager:IsFactionFavorite(node.factionID)
    
    -- If this is a header and it's favorite, remove it and all children
    if node.isHeader and isFavorite then
        return true
    end
    
    -- If this is a favorite non-header or child, remove it
    if isFavorite and not node.isHeader then
        return true
    end
    
    -- Process children if they exist
    if node.children then
        local newChildren = {}
        local anyRemoved = false
        
        for _, child in ipairs(node.children) do
            if not removeFavoriteFactions(child) then
                table.insert(newChildren, child)
            else
                anyRemoved = true
            end
        end
        
        node.children = newChildren
        
        -- If this was a header and now has no children
        if node.isHeader and #newChildren == 0 then
            -- Keep header with rep as regular faction
            if node.isHeaderWithRep then
                node.isHeader = false
                node.isHeaderWithRep = false
                node.isChild = false
                return false
            end
            -- Remove regular header with no children
            return true
        end
    end
    
    return false
end

local function handleFavoriteFactions(transformedData)    
    -- Collect all favorite factions
    local favoriteList = {}
    for _, faction in ipairs(transformedData) do
        collectFavoriteFactions(faction, favoriteList)
    end
    
    -- Remove favorite factions from their original locations
    local newTransformedData = {}
    for _, faction in ipairs(transformedData) do
        if not removeFavoriteFactions(faction) then
            table.insert(newTransformedData, faction)
        end
    end
    
    -- Create favorites group if we found any favorite factions
    if #favoriteList > 0 then
        local customHeaderID = PrettyReps.DataManager.CustomHeaders.FAVORITES
        local isCollapsed = PrettyRepsDB.HeaderStates[customHeaderID] ~= false
        local favoritesHeader = {
            factionID = customHeaderID,
            name = "Favorites",
            isHeader = true,
            isChild = false,
            isCollapsed = isCollapsed,
            isCustomHeader = true,
            children = favoriteList
        }
        -- Insert favorites at the beginning of the list
        table.insert(newTransformedData, 1, favoritesHeader)
    end
    
    return newTransformedData
end

local function CalculateCompletionStats(node)
    if not node then return 0, 0 end
    
    local total = 0
    local completed = 0

    -- Count this node if it's a reputation-bearing faction
    if not node.isHeader or node.isHeaderWithRep then
        total = 1
        if node.hasBeenEncountered and node.isMaxLevel then
            completed = 1
        end
    end

    -- Process visible children recursively
    if node.children then
        for _, child in ipairs(node.children) do
            local childCompleted, childTotal = CalculateCompletionStats(child)
            completed = completed + childCompleted
            total = total + childTotal
        end
    end

    -- Store stats in the node
    node.completionStats = {
        completed = completed,
        total = total,
        percentage = total > 0 and (completed / total * 100) or 0
    }

    return completed, total
end

local function handleGuildFaction(transformedData, options)
    -- Check if we should hide guild reputation
    if options.hideGuildReputation then
        return transformedData
    end

    -- Get guild faction data
    local guildFaction = PrettyReps.FactionScanner:GetGuildFactionData()
    if not guildFaction then
        return transformedData
    end

    -- Calculate completion stats for guild faction
    local completed = guildFaction.isMaxLevel and 1 or 0
    local total = 1

    -- Create a Guild header
    local guildHeader = {
        factionID = PrettyReps.DataManager.CustomHeaders.GUILD,
        name = "Guild",
        isHeader = true,
        isChild = false,
        isCustomHeader = true,
        isCollapsed = PrettyRepsDB.HeaderStates[PrettyReps.DataManager.CustomHeaders.GUILD] ~= false,
        children = {
            guildFaction
        },
        completionStats = {
            completed = completed,
            total = total,
            percentage = completed * 100
        }
    }

    -- Insert the guild header
    table.insert(transformedData, guildHeader)
    return transformedData
end

-- Modify matchesSearch to consider headers differently
local function matchesSearch(node, searchText)
    if not searchText or searchText == "" or searchText == "Search..." then
        return true
    end
    
    searchText = searchText:lower()
    
    -- For headers without rep, don't consider them direct matches
    if node.isHeader and not node.isHeaderWithRep then
        return false
    end
    
    -- Check faction name
    if node.name and node.name:lower():find(searchText) then
        return true
    end
    
    -- Check character name only for non-account-wide factions
    if not node.isAccountWide and node.character and node.character.name:lower():find(searchText) then
        return true
    end
    
    return false
end

-- Add this helper function to check if a header is a custom header
local function isCustomHeader(node)
    if not node or not node.isHeader or not node.factionID then return false end
    
    -- Check against known custom header IDs
    return node.factionID == PrettyReps.DataManager.CustomHeaders.FAVORITES or
           node.factionID == PrettyReps.DataManager.CustomHeaders.INACTIVE or
           node.factionID == PrettyReps.DataManager.CustomHeaders.UNOBTAINABLE or
           node.factionID == PrettyReps.DataManager.CustomHeaders.GUILD
end

-- Modify processNode to handle headers appropriately during search
local function processNode(node, parentNode, options)
    if not node then return nil end
    
    local isSearching = options.searchText and options.searchText ~= "" and options.searchText ~= "Search..."
    local directMatch = matchesSearch(node, options.searchText)
    
    -- Process children first
    local hasMatchingChildren = false
    if node.children then
        local newChildren = {}
        for _, child in ipairs(node.children) do
            local processedChild = processNode(child, node, options)
            if processedChild then
                hasMatchingChildren = true
                table.insert(newChildren, processedChild)
            end
        end
        node.children = newChildren
    end
    
    local shouldInclude = filterFaction(node, options, parentNode)
    
    -- Convert empty headers with rep to regular factions
    if node.isHeader and node.isHeaderWithRep and (not node.children or #node.children == 0) then
        node.isHeader = false
        node.isHeaderWithRep = false
        node.children = nil
        node.isChild = false
    end
    
    if isSearching then
        if node.isHeader then
            -- For custom headers, only include if they have matching children
            if isCustomHeader(node) then
                return hasMatchingChildren and node or nil
            end
            -- For regular headers, include if they have matching children or are a header with rep that matches
            return shouldInclude and (hasMatchingChildren or (node.isHeaderWithRep and directMatch)) and node or nil
        else
            -- Include non-headers only if they match directly
            return shouldInclude and directMatch and node or nil
        end
    else
        -- Normal non-search behavior
        if node.isHeader then
            -- Don't show empty headers (except custom headers)
            if isCustomHeader(node) then
                return hasMatchingChildren and node or nil
            end
            
            -- For regular headers, show if they have visible children or have their own rep and pass filters
            if hasMatchingChildren or (node.isHeaderWithRep and shouldInclude) then
                return node
            end
            return nil
        end
        
        -- For non-headers, just use the filter result
        return shouldInclude and node or nil
    end
end

-- Update markHeadersWithMatches to use the new matchesSearch
local function markHeadersWithMatches(node, searchText)
    if not node or not searchText or searchText == "" or searchText == "Search..." then
        return false
    end
    
    local hasMatch = matchesSearch(node, searchText)
    
    -- For headers with children, check children and mark if any match
    if node.children then
        for _, child in ipairs(node.children) do
            local childHasMatch = markHeadersWithMatches(child, searchText)
            hasMatch = hasMatch or childHasMatch
        end
        
        -- If this header contains matches, mark it
        if hasMatch then
            node.containsSearchMatch = true
        end
    end
    
    return hasMatch
end

-- Add this function to handle temporary header expansion
local function handleSearchExpansion(node, options)
    if not node then return end
    
    -- If we're searching and this header contains matches, temporarily expand it
    if options.searchText and options.searchText ~= "" and options.searchText ~= "Search..." and node.containsSearchMatch then
        node.isCollapsed = false
        node.expandedForSearch = true -- Mark that this was expanded for search
    -- If we're not searching and this was expanded for search, restore original state
    elseif node.expandedForSearch then
        node.isCollapsed = PrettyRepsDB.HeaderStates[node.factionID] ~= false
        node.expandedForSearch = nil
    end
    
    -- Process children recursively
    if node.children then
        for _, child in ipairs(node.children) do
            handleSearchExpansion(child, options)
        end
    end
end

-- Update the TransformData function to handle search after other transformations
function PrettyReps.DataTransformer:TransformData(rawData, options)
    if not rawData or not options then return {} end
    
    -- Deep copy the data so we don't modify the original
    local function deepCopy(data)
        if type(data) ~= "table" then return data end
        local copy = {}
        for k, v in pairs(data) do
            if type(v) == "table" then
                copy[k] = deepCopy(v)
            else
                copy[k] = v
            end
        end
        return copy
    end
    
    local transformedData = deepCopy(rawData)
    
    -- First handle all organizational transformations
    transformedData = handleFavoriteFactions(transformedData)
    transformedData = handleGuildFaction(transformedData, options)
    transformedData = handleUnobtainableFactions(transformedData, options)
    transformedData = handleInactiveFactions(transformedData, options)
    
    -- Create a copy of options without search for initial filtering
    local preSearchOptions = {}
    for k, v in pairs(options) do
        if k ~= "searchText" then
            preSearchOptions[k] = v
        end
    end
    
    -- Do initial filtering without search
    local filteredData = {}
    for _, faction in ipairs(transformedData) do
        local processed = processNode(faction, nil, preSearchOptions)
        if processed then
            table.insert(filteredData, processed)
        end
    end
    
    -- Now handle search if we have a search term
    if options.searchText and options.searchText ~= "" and options.searchText ~= "Search..." then
        -- Mark headers that contain search matches
        for _, faction in ipairs(filteredData) do
            markHeadersWithMatches(faction, options.searchText)
        end
        
        -- Handle temporary header expansion for search results
        for _, faction in ipairs(filteredData) do
            handleSearchExpansion(faction, options)
        end
        
        -- Apply search filtering
        local searchResults = {}
        for _, faction in ipairs(filteredData) do
            local processed = processNode(faction, nil, options)
            if processed then
                table.insert(searchResults, processed)
            end
        end
        filteredData = searchResults
    end
    
    -- Calculate completion stats only if the option is enabled
    if options.displayGroupTotals then
        for _, faction in ipairs(filteredData) do
            CalculateCompletionStats(faction)
        end
    end
    
    return filteredData
end

-- Utility function to flatten a transformed dataset for UI display
function PrettyReps.DataTransformer:FlattenData(transformedData)
    if not transformedData then return {} end
    
    local flattened = {}
    
    local function processNode(node)
        if not node then return end
        table.insert(flattened, node)
        if node.isHeader and not node.isCollapsed and node.children then
            for _, child in ipairs(node.children) do
                processNode(child)
            end
        end
    end
    
    for _, faction in ipairs(transformedData) do
        processNode(faction)
    end
    
    return flattened
end

return PrettyReps.DataTransformer