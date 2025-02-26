local addonName, PrettyReps = ...

PrettyReps.CharacterFrame = {}

function PrettyReps.CharacterFrame:CreateCustomFrame()
    if _G["PrettyRepsReputationFrame"] then
        return _G["PrettyRepsReputationFrame"]
    end
    
    local customFrame = CreateFrame("Frame", "PrettyRepsReputationFrame", ReputationFrame, "PrettyRepsReputationFrame")
    if not customFrame then
        print("PrettyReps: Failed to create frame!")
        return nil
    end
    
    customFrame:SetParent(ReputationFrame)
    customFrame:SetAllPoints()
    customFrame:SetShown(ReputationFrame:IsShown())
    

    return customFrame
end


function PrettyReps.CharacterFrame:EnablePrettyReps()
    self:HideReputationFrame()
    if ReputationFrame:IsShown() then        
        _G["PrettyRepsReputationFrame"]:Show()
        CharacterFrameTitleText:SetText("PrettyReps Reputation")
    end
    PrettyReps.OptionsManager:SetOption("enablePrettyReps", true)
end

function PrettyReps.CharacterFrame:DisablePrettyReps()
    self:RestoreReputationFrame()
    _G["PrettyRepsReputationFrame"]:Hide()
    PrettyReps.OptionsManager:SetOption("enablePrettyReps", false)
end

function PrettyReps.CharacterFrame:HideReputationFrame()
    if not self.originalHandlers then
        self.originalHandlers = {
            OnShow = ReputationFrame:GetScript("OnShow"),
            OnEvent = ReputationFrame:GetScript("OnEvent"),
            UpdateTitle = CharacterFrame.UpdateTitle
        }
        
        ReputationFrame:SetScript("OnShow", function()
            _G["PrettyRepsReputationFrame"]:Show()
        end)
        
        ReputationFrame:HookScript("OnHide", function()
            _G["PrettyRepsReputationFrame"]:Hide()
        end)
        
        CharacterFrame.UpdateTitle = function(frame)
            if PrettyReps.OptionsManager:GetOption("enablePrettyReps") and ReputationFrame:IsShown() then
                CharacterFrameTitleText:SetText("PrettyReps Reputation")
            else
                self.originalHandlers.UpdateTitle(frame)
            end
        end
        
        if ReputationFrame.ScrollBox then
            ReputationFrame.ScrollBox:Hide()
            ReputationFrame.ScrollBar:Hide()
        end
        
        if ReputationFrame.filterDropdown then
            ReputationFrame.filterDropdown:Hide()
            if ReputationFrame.filterDropdown.Button then
                ReputationFrame.filterDropdown.Button:Hide()
            end
        end
        
        if ReputationFrame.ReputationDetailFrame then
            ReputationFrame.ReputationDetailFrame:Hide()
        end
    end
end

function PrettyReps.CharacterFrame:RestoreReputationFrame()
    if self.originalHandlers then
        -- Restore original frame scripts
        ReputationFrame:SetScript("OnShow", self.originalHandlers.OnShow)
        ReputationFrame:SetScript("OnEvent", self.originalHandlers.OnEvent)
        CharacterFrame.UpdateTitle = self.originalHandlers.UpdateTitle
        
        -- Show UI elements
        if ReputationFrame.filterDropdown then
            ReputationFrame.filterDropdown:Show()
            if ReputationFrame.filterDropdown.Button then
                ReputationFrame.filterDropdown.Button:Show()
            end
        end

        ReputationFrame.ScrollBox:Show()
        ReputationFrame.ScrollBar:Show()
        -- Restore the original window title
        if ReputationFrame:IsShown() then
            CharacterFrameTitleText:SetText(REPUTATION)
        end
        
        -- Let the frame's OnShow handler restore everything else
        ReputationFrame:GetScript("OnShow")(ReputationFrame)
        
        self.originalHandlers = nil
    end
end

function PrettyReps.CharacterFrame:Init()    
    -- Create frame immediately during init
    local frame = self:CreateCustomFrame()
    if not frame then
        print("PrettyReps: ERROR - Failed to create initial frame")
        return
    end
    
    -- If custom frame is enabled in options, set it up now
    if PrettyReps.OptionsManager:GetOption("enablePrettyReps") then
        self:EnablePrettyReps()
    end
end

return PrettyReps.CharacterFrame