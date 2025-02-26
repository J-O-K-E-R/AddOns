local addonName, PrettyReps = ...

-- Create event registry
PrettyReps.Events = CreateFromMixins(CallbackRegistryMixin)
PrettyReps.Events:OnLoad()
PrettyReps.Events:SetUndefinedEventsAllowed(true)

-- Define all possible event names
PrettyReps.Events.Names = {
    -- Data Events
    FactionDataChanged = "FactionDataChanged",      -- Any changes to faction data
    DataInitialized = "DataInitialized",            -- When addon data is first loaded
    CacheInvalidated = "CacheInvalidated",          -- When data cache has been invalidated
    
    -- Option Events
    OptionsChanged = "OptionsChanged",              -- When preferences change
}

-- Event Documentation
PrettyReps.Events.Documentation = {
    FactionDataChanged = [[
        Fired when faction data is updated from the server or modified locally.
        Payload: none
    ]],
    
    DataInitialized = [[
        Fired when the addon's data is first initialized.
        Payload: none
    ]],
    
    OptionsChanged = [[
        Fired when preferences are modified.
        Payload: {
            changedOptions = table  -- Table of changed option keys
        }
    ]],

    CacheInvalidated = [[
        Fired when the data cache has been invalidated.
        Payload: none
    ]],
}

-- Helper function to generate event payload
function PrettyReps.Events:GeneratePayload(eventName, ...)
    local payloads = {
        OptionsChanged = function(changedOptions)
            return { changedOptions = changedOptions }
        end,
    }
    
    if payloads[eventName] then
        return payloads[eventName](...)
    end
    
    return nil
end

-- Enhanced TriggerEvent that handles payload generation
function PrettyReps.Events:TriggerEvent(eventName, ...)
    if not self.Names[eventName] then
        error(string.format("Unknown event: %s", eventName))
        return
    end
    
    local payload = self:GeneratePayload(eventName, ...)
    if payload then
        CallbackRegistryMixin.TriggerEvent(self, eventName, payload)
    else
        CallbackRegistryMixin.TriggerEvent(self, eventName, ...)
    end
end

return PrettyReps.Events