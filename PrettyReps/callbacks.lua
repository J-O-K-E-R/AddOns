--[[	

    $$$$$$\            $$\ $$\ $$\                           $$\                 
    $$  __$$\           $$ |$$ |$$ |                          $$ |                
    $$ /  \__| $$$$$$\  $$ |$$ |$$$$$$$\   $$$$$$\   $$$$$$$\ $$ |  $$\  $$$$$$$\ 
    $$ |       \____$$\ $$ |$$ |$$  __$$\  \____$$\ $$  _____|$$ | $$  |$$  _____|
    $$ |       $$$$$$$ |$$ |$$ |$$ |  $$ | $$$$$$$ |$$ /      $$$$$$  / \$$$$$$\  
    $$ |  $$\ $$  __$$ |$$ |$$ |$$ |  $$ |$$  __$$ |$$ |      $$  _$$<   \____$$\ 
    \$$$$$$  |\$$$$$$$ |$$ |$$ |$$$$$$$  |\$$$$$$$ |\$$$$$$$\ $$ | \$$\ $$$$$$$  |
    \______/  \_______|\__|\__|\_______/  \_______| \_______|\__|  \__|\_______/ 

--]]

local Callbacks = {}

---------------------------------------------------------------------------------------------
--								Vars
---------------------------------------------------------------------------------------------

local registeredCallbacks = {
    OnUiBuilt = {},
    OnOptionChanged = {},
    OnDbStructureChanged = {},
    OnPrettyRepsEnabled = {},
    OnPrettyRepsDisabled = {},
    OnSelectedFactionChanged = {}
}

---------------------------------------------------------------------------------------------
--								Exports
---------------------------------------------------------------------------------------------
_G.PrettyReps.Callbacks = {}

function _G.PrettyReps.Callbacks.Register(name, func)
    Callbacks:RegisterCallback(name, func)
end

function _G.PrettyReps.Callbacks.Trigger(name, ...)
    Callbacks:TriggerCallback(name, ...)
end

---------------------------------------------------------------------------------------------
--								Functions
---------------------------------------------------------------------------------------------

function Callbacks:RegisterCallback(name, func)
    if not registeredCallbacks[name] then
        print("Cannot register unknown callback: " .. name)
        return
    end

    table.insert(registeredCallbacks[name], func)
end

function Callbacks:TriggerCallback(name, ...)
    if not registeredCallbacks[name] then
        print("Cannot trigger unknown callback: " .. name)
        return
    end

    for _, func in ipairs(registeredCallbacks[name]) do
        func(...)
    end
end