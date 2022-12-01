--[[----------------------------------------------------------------------------

  LiteBag/BankFrame.lua

  Copyright 2013 Mike Battersby

  Released under the terms of the GNU General Public License version 2 (GPLv2).
  See the file LICENSE.txt.

----------------------------------------------------------------------------]]--

local addonName, LB = ...

LiteBagBankMixin = {}

function LiteBagBankMixin:ShowPanel(n)
    LiteBagFrameMixin.ShowPanel(self, n)

    -- The itembuttons use BankFrame.selectedTab to know where
    -- to put something that's clicked.
    BankFrame.selectedTab = n

    -- The AutoSortButton uses activeTabIndex to know which tooltip to
    -- show (and what to sort, but we override that).
    BankFrame.activeTabIndex = n
end

function LiteBagBankMixin:OnLoad()
    LiteBagFrameMixin.OnLoad(self)

    local placer = self:GetParent()
    self.CloseButton:SetScript('OnClick', function () HideUIPanel(placer) end)

    -- Attach in the reagent bank wrapper.
    self:AddPanel(LiteBagReagentBank)

    -- Bank frame specific events
    self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW')
    self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE')
end

function LiteBagBankMixin:OnEvent(event, ...)
    LB.EventDebug(self, event, ...)
    local placer = self:GetParent()
    if event == 'PLAYER_INTERACTION_MANAGER_FRAME_SHOW' then
        local type = ...
        if type == Enum.PlayerInteractionType.Banker and not placer:IsShown() then
            ShowUIPanel(placer)
        end
    elseif event == 'PLAYER_INTERACTION_MANAGER_FRAME_HIDE' then
        local type = ...
        if type == Enum.PlayerInteractionType.Banker then
            HideUIPanel(placer)
        end
    end
end

function LiteBagBankMixin:OnShow()
    LiteBagFrameMixin.OnShow(self)

    local placer = self:GetParent()
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", placer, "TOPLEFT")

    OpenAllBags(self)
end

function LiteBagBankMixin:OnHide()
    LiteBagFrameMixin.OnHide(self)

    CloseAllBags(self)

    -- Call this so the server knows we closed and it needs to send us a
    -- new open event if we interact with the NPC again.
    CloseBankFrame()
end

function LiteBagBankMixin:ResizeToPanel()
    local w, h = LiteBagFrameMixin.ResizeToPanel(self)
    local placer = self:GetParent()
    local s = self:GetScale()
    placer:SetSize(w*s, h*s)
    if placer:IsShown() then
        UpdateUIPanelPositions(placer)
    end
end
