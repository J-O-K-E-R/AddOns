local addonName, PrettyReps = ...

PrettyReps.UIDataProvider = {
    -- Cache for transformed/flattened data
    cache = {
        transformed = nil,
        flattened = nil,
        isDirty = true,
        -- Add frame-level cache
        currentFrameData = nil
    }
}

-- Initialize provider
function PrettyReps.UIDataProvider:Init()
    -- Register for events that should invalidate our cache
    PrettyReps.Events:RegisterCallback(PrettyReps.Events.Names.FactionDataChanged, 
        function() self:InvalidateCache() end
    )
    PrettyReps.Events:RegisterCallback(PrettyReps.Events.Names.OptionsChanged,
        function() self:InvalidateCache() end
    )
end

-- Cache Management
function PrettyReps.UIDataProvider:InvalidateCache()
    if not self.cache.isDirty then
        self.cache.isDirty = true
        self.cache.currentFrameData = nil
        PrettyReps.Events:TriggerEvent(PrettyReps.Events.Names.CacheInvalidated)
    end
end

-- Get options for data transformation
function PrettyReps.UIDataProvider:GetTransformOptions()
    local transformOptions = PrettyReps.OptionsManager:GetAllOptions()
    
    -- Add character-specific option
    transformOptions.currentCharacter = string.format("%s-%s", UnitName("player"), GetRealmName())
    
    return transformOptions
end

-- Get transformed data (with hierarchy maintained)
function PrettyReps.UIDataProvider:GetTransformedData()
    self:RefreshCacheIfNeeded()
    return self.cache.transformed
end

-- Get flattened data for UI display
function PrettyReps.UIDataProvider:GetDisplayData()
    self:RefreshCacheIfNeeded()
    return self.cache.flattened
end

-- Refresh cache if needed
function PrettyReps.UIDataProvider:RefreshCacheIfNeeded()
    if not self.cache.isDirty then return end
    
    -- Get raw data and current options
    local rawData = PrettyReps.DataManager:GetFactionData()
    local options = self:GetTransformOptions()
    
    -- Transform with current options
    self.cache.transformed = PrettyReps.DataTransformer:TransformData(rawData, options)
    self.cache.flattened = PrettyReps.DataTransformer:FlattenData(self.cache.transformed)
    self.cache.isDirty = false
end

-- Add helper to manage frame-level cache
function PrettyReps.UIDataProvider:GetFrameData()
    if self.cache.currentFrameData then
        return self.cache.currentFrameData
    end
    
    self.cache.currentFrameData = self:GetDisplayData()
    return self.cache.currentFrameData
end

-- Get number of visible factions
function PrettyReps.UIDataProvider:GetNumFactions()
    local displayData = self:GetFrameData()
    return #displayData
end

-- Get faction data by index in current display list
function PrettyReps.UIDataProvider:GetFactionDataByIndex(index)
    if not index or index < 1 then return nil end
    local displayData = self:GetFrameData()
    if index > #displayData then return nil end
    return displayData[index]
end

-- Get raw faction data by ID
function PrettyReps.UIDataProvider:GetRawFactionData(factionID)
    return PrettyReps.DataManager:GetFactionById(factionID)
end

-- Set faction collapse state
function PrettyReps.UIDataProvider:SetFactionCollapsed(factionID, isCollapsed)
    local success = PrettyReps.DataManager:SetFactionCollapsed(factionID, isCollapsed)
    return success
end

return PrettyReps.UIDataProvider