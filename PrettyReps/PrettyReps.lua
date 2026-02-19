local addonName, PrettyReps = ...

PrettyReps.frame = CreateFrame("Frame")

-- Initialize the addon
function PrettyReps:Init()    
    -- Initialize core systems in correct order
    self.DataManager:Init()
    self.OptionsManager:Init()
    self.UIDataProvider:Init()
    
    -- Set up UI components
    -- self:SetupSlashCommands()    
    self.CharacterFrame:Init()
    
    -- Register for events
    self.frame:RegisterEvent("PLAYER_LOGIN")
    self.frame:RegisterEvent("UPDATE_FACTION")
    self.frame:RegisterEvent("QUEST_LOG_UPDATE")
    self.frame:RegisterEvent("MAJOR_FACTION_RENOWN_LEVEL_CHANGED")
    self.frame:RegisterEvent("MAJOR_FACTION_UNLOCKED")
end

function PrettyReps:SetupSlashCommands()
    SLASH_PRETTYREPS1 = "/prettyreps"
    SlashCmdList["PRETTYREPS"] = function(msg)
        local command = msg:lower():trim()

        if command == "reveal" then
            self.FactionScanner:RevealAllFactions()
        elseif command == "reset" then
            self.OptionsManager:ResetAll()
            print("PrettyReps: All options reset to defaults.")
        elseif command == "toggle" then
            local prettyRepsEnabled = self.OptionsManager:GetOption("enablePrettyReps")
            if prettyRepsEnabled then
                self.CharacterFrame:DisablePrettyReps()
            else
                self.CharacterFrame:EnablePrettyReps()
                self.FactionScanner:RevealAllFactions()
            end
        else
            print("PrettyReps: Available commands:")
            print("  /prettyreps reveal - Expand all faction headers")
            print("  /prettyreps reset - Reset all options to defaults")
            print("  /prettyreps toggle - Toggle between custom and default UI")
        end
    end
end

-- Handle events
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        PrettyReps:Init()
        PrettyReps.frame:UnregisterEvent("ADDON_LOADED")
    elseif event == "PLAYER_LOGIN" then
        -- Only reveal factions if pretty reps enabled
        if PrettyReps.OptionsManager:GetOption("enablePrettyReps") then
            PrettyReps.FactionScanner:RevealAllFactions()
        end
    elseif event == "UPDATE_FACTION" or event == "QUEST_LOG_UPDATE" or event == "MAJOR_FACTION_RENOWN_LEVEL_CHANGED" or event == "MAJOR_FACTION_UNLOCKED" then
        -- Ignore updates while scanning
        if PrettyReps.FactionScanner.isScanning then
            return
        end

        -- Update data manager with current server state
        PrettyReps.DataManager:UpdateFromServer()
    end
end

-- Set up event handling
PrettyReps.frame:SetScript("OnEvent", OnEvent)
PrettyReps.frame:RegisterEvent("ADDON_LOADED")

return PrettyReps