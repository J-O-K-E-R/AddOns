--[[
			

								$$$$$$$\                       $$\     $$\                     $$$$$$$\                                
								$$  __$$\                      $$ |    $$ |                    $$  __$$\                               
								$$ |  $$ | $$$$$$\   $$$$$$\ $$$$$$\ $$$$$$\   $$\   $$\       $$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$$\ 
								$$$$$$$  |$$  __$$\ $$  __$$\\_$$  _|\_$$  _|  $$ |  $$ |      $$$$$$$  |$$  __$$\ $$  __$$\ $$  _____|
								$$  ____/ $$ |  \__|$$$$$$$$ | $$ |    $$ |    $$ |  $$ |      $$  __$$< $$$$$$$$ |$$ /  $$ |\$$$$$$\  
								$$ |      $$ |      $$   ____| $$ |$$\ $$ |$$\ $$ |  $$ |      $$ |  $$ |$$   ____|$$ |  $$ | \____$$\ 
								$$ |      $$ |      \$$$$$$$\  \$$$$  |\$$$$  |\$$$$$$$ |      $$ |  $$ |\$$$$$$$\ $$$$$$$  |$$$$$$$  |
								\__|      \__|       \_______|  \____/  \____/  \____$$ |      \__|  \__| \_______|$$  ____/ \_______/ 
								                                               $$\   $$ |                          $$ |                
								                                               \$$$$$$  |                          $$ |                
								                                                \______/                           \__|                
												
												Author: https://wow.curseforge.com/members/Sida2
												Curse: https://wow.curseforge.com/projects/pretty-reps
												Thanks to: https://worldofwarcraft.com/en-gb/character/ravencrest/Dayanne

]]

local PrettyReps = {}

---------------------------------------------------------------------------------------------
--								Exports
---------------------------------------------------------------------------------------------
_G.PrettyReps = {}

function _G.PrettyReps.Disable()
    PrettyReps:Disable()
end

function _G.PrettyReps.Enable()
    PrettyReps:Enable()
end

function _G.PrettyReps.Refresh(getServerData)
    PrettyReps:Refresh(getServerData)
end

---------------------------------------------------------------------------------------------
--								Events
---------------------------------------------------------------------------------------------

local eventFrame = CreateFrame("FRAME", "PrettyRepsUIEventFrame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, name, ...)
    if event == "ADDON_LOADED" and name == "PrettyReps" then
        _G.PrettyReps.DataUtils.Init()
        _G.PrettyReps.UI.Init()
        _G.PrettyReps.UI.BuildUI()

        PrettyReps:RegisterCallbacks()
    end
    
    if event == "UPDATE_FACTION" or event == "QUEST_LOG_UPDATE" or event == "MAJOR_FACTION_RENOWN_LEVEL_CHANGED" or event == "MAJOR_FACTION_UNLOCKED" then
        if PrettyReps.enabled then
            PrettyReps:Refresh(true)
        end
    end
end)

function PrettyReps:RegisterCallbacks()
    _G.PrettyReps.Callbacks.Register("OnOptionChanged", function()
        if self.enabled then
            PrettyReps:Refresh()
        end
    end)

    _G.PrettyReps.Callbacks.Register("OnDbStructureChanged", function()
        if self.enabled then
            PrettyReps:Refresh()
        end
    end)
end

function PrettyReps:OnShow()
    PrettyReps:Refresh(true)
    eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
    eventFrame:RegisterEvent("UPDATE_FACTION")
    eventFrame:RegisterEvent("MAJOR_FACTION_RENOWN_LEVEL_CHANGED")
    eventFrame:RegisterEvent("MAJOR_FACTION_UNLOCKED")
end

function PrettyReps:OnHide()
    eventFrame:UnregisterEvent("QUEST_LOG_UPDATE")
	eventFrame:UnregisterEvent("UPDATE_FACTION")
	eventFrame:UnregisterEvent("MAJOR_FACTION_RENOWN_LEVEL_CHANGED")
	eventFrame:UnregisterEvent("MAJOR_FACTION_UNLOCKED")
end

---------------------------------------------------------------------------------------------
--								Main
---------------------------------------------------------------------------------------------

local frame = CreateFrame("FRAME", "PrettyRepsEventFrame")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("PLAYER_LEAVING_WORLD")

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LEAVING_WORLD" or event == "PLAYER_LOGOUT" then
		_G.PrettyReps.DataUtils.Save()
	end
end)

onShow_orig = ReputationFrame:GetScript("OnShow")
onHide_orig = ReputationFrame:GetScript("OnHide")
ReputationFrame:SetScript("OnShow", function()
    PrettyReps:Enable()
end)

---------------------------------------------------------------------------------------------
--								Functions
---------------------------------------------------------------------------------------------

function PrettyReps:Refresh(getServerData)
    PrettyReps:SetDataProvider(_G.PrettyReps.DataUtils.RebuildPanelData({refreshServerData = getServerData}), ScrollBoxConstants.RetainScrollPosition)
end

function PrettyReps:SetPanelData(panelData)
    getPanelData = function() return panelData end
end

function PrettyReps:Enable()
    self.enabled = true
    ReputationFrame:SetScript("OnShow", PrettyReps.OnShow)
    ReputationFrame:SetScript("OnHide", PrettyReps.OnHide)
    onHide_orig(ReputationFrame)
    self:OnShow()
    self:InitScrollBox(function(...) _G.PrettyReps.RepPanel.InitReputationRow(getPanelData(), ...) end)
    self:Refresh(true)
    _G.PrettyReps.Callbacks.Trigger("OnPrettyRepsEnabled")
end

function PrettyReps:Disable()
    self.enabled = false
    self:InitScrollBox(ReputationFrame_InitReputationRow)
    ReputationFrame:SetScript("OnShow", function() onShow_orig(ReputationFrame) end)
    ReputationFrame:SetScript("OnHide", function() onHide_orig(ReputationFrame) end)
    onShow_orig(ReputationFrame)
    self:OnHide()
    ReputationFrame_Update()
    _G.PrettyReps.Callbacks.Trigger("OnPrettyRepsDisabled")
end

function PrettyReps:SetDataProvider(panelData)
    local scroll = ReputationFrame.ScrollBox:GetDerivedScrollOffset()
    self:SetPanelData(panelData)
    local dataProvider = CreateDataProviderByIndexCount(#panelData);
    ReputationFrame.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition);
end

function PrettyReps:InitScrollBox(initReputationRowFunc)
	local view = CreateScrollBoxListLinearView();
	view:SetElementInitializer("ReputationBarTemplate", function(button, elementData)
		initReputationRowFunc(button, elementData);
	end);
	view:SetPadding(0,0,0,2,2);

	ScrollUtil.InitScrollBoxListWithScrollBar(ReputationFrame.ScrollBox, ReputationFrame.ScrollBar, view);

	g_selectionBehavior = ScrollUtil.AddSelectionBehavior(ReputationFrame.ScrollBox, SelectionBehaviorFlags.Deselectable, SelectionBehaviorFlags.Intrusive);
	g_selectionBehavior:RegisterCallback(SelectionBehaviorMixin.Event.OnSelectionChanged, function(o, elementData, selected)
		local button = ReputationFrame.ScrollBox:FindFrame(elementData);
		if button then
			initReputationRowFunc(button, elementData);
	end
	end, ReputationFrame);
end