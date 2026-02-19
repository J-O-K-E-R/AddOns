local addonName, PrettyReps = ...

PrettyReps.OptionsManager = {
    -- Default values for all options
    defaults = {
        showNotEncountered = false,
        showInactive = true,
        showLegacy = true,
        sortType = "none",           -- none/account/character
        selectedFactionIndex = 0,
        enablePrettyReps = true,     -- Whether to use our custom frame vs default
        groupUnobtainable = true,
        hideUnobtainable = false,
        displayGroupTotals = true,
        displayTotalsAsPercentage = false,  -- New option
        hideInactiveGroup = false,
        showOppositeFaction = true,
        useParagonBars = true,       -- Show paragon progress with blue bars
        hideParagonIcons = true,     -- Hide paragon reward icons by default
        showParagonRewards = true,   -- But show when reward is available
        hideGuildReputation = false,
    }
}

-- Initialize options
function PrettyReps.OptionsManager:Init()
    -- Ensure saved variables exist
    PrettyRepsDB = PrettyRepsDB or {}
    PrettyRepsDB.Options = PrettyRepsDB.Options or {}
    
    -- Initialize all options with defaults
    self:EnsureDefaults()
end

-- Ensure defaults exist
function PrettyReps.OptionsManager:EnsureDefaults()
    for key, default in pairs(self.defaults) do
        if PrettyRepsDB.Options[key] == nil then
            PrettyRepsDB.Options[key] = default
        end
    end
end

-- Get an option value
function PrettyReps.OptionsManager:GetOption(key)
    if not key then return nil end
    
    if PrettyRepsDB.Options[key] == nil then
        return self.defaults[key]
    end
    return PrettyRepsDB.Options[key]
end

-- Set an option value
function PrettyReps.OptionsManager:SetOption(key, value)
    if not key then return false end
    
    -- Check if value is actually changing
    if PrettyRepsDB.Options[key] == value then
        return false
    end
    
    -- Update value
    PrettyRepsDB.Options[key] = value
    
    -- Trigger event
    PrettyReps.Events:TriggerEvent(PrettyReps.Events.Names.OptionsChanged, {[key] = value})
    
    return true
end

-- Get all options
function PrettyReps.OptionsManager:GetAllOptions()
    return CopyTable(PrettyRepsDB.Options)
end

-- Reset all options to defaults
function PrettyReps.OptionsManager:ResetAll()
    PrettyRepsDB.Options = CopyTable(self.defaults)
    PrettyReps.Events:TriggerEvent(PrettyReps.Events.Names.OptionsChanged, self.defaults)
end
