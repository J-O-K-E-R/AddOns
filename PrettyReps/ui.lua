--[[	

	$$$$$$\            $$\                          $$$$$$\                               
	\_$$  _|           $$ |                        $$  __$$\                              
	  $$ |  $$$$$$$\ $$$$$$\    $$$$$$\   $$$$$$\  $$ /  \__|$$$$$$\   $$$$$$$\  $$$$$$\  
	  $$ |  $$  __$$\\_$$  _|  $$  __$$\ $$  __$$\ $$$$\     \____$$\ $$  _____|$$  __$$\ 
	  $$ |  $$ |  $$ | $$ |    $$$$$$$$ |$$ |  \__|$$  _|    $$$$$$$ |$$ /      $$$$$$$$ |
	  $$ |  $$ |  $$ | $$ |$$\ $$   ____|$$ |      $$ |     $$  __$$ |$$ |      $$   ____|
	$$$$$$\ $$ |  $$ | \$$$$  |\$$$$$$$\ $$ |      $$ |     \$$$$$$$ |\$$$$$$$\ \$$$$$$$\ 
	\______|\__|  \__|  \____/  \_______|\__|      \__|      \_______| \_______| \_______|

--]]

local UI = {}

---------------------------------------------------------------------------------------------
--								Vars
---------------------------------------------------------------------------------------------
local playerName, playerRealm

---------------------------------------------------------------------------------------------
--								Exports
---------------------------------------------------------------------------------------------
_G.PrettyReps.UI = {}

function _G.PrettyReps.UI.Init()
    UI:Init()
end

function _G.PrettyReps.UI.BuildUI()
    UI:BuildUI()
end

---------------------------------------------------------------------------------------------
--								Functions
---------------------------------------------------------------------------------------------

function UI:Init()
    playerName, playerRealm = UnitName("player")
end

function UI:BuildUI()
    UI:BuildOptionsFrame();
    UI:BuildOptionsButton();
    UI:BuildTabs();

    local yPos = -70
    local itemSpacing = 30

    UI:BuildOption_HeaderTotals(yPos)

    yPos = yPos - itemSpacing
    UI:BuildOption_EnableUnobtainable(yPos)

    yPos = yPos - itemSpacing * 0.7
    UI:BuildOption_HideUnobtainable(yPos)

    yPos = yPos - itemSpacing * 0.7
    UI:BuildOption_HideInactive(yPos)

    yPos = yPos - itemSpacing
    UI:BuildOption_ShowOppositeFaction(yPos)

    yPos = yPos - itemSpacing
    UI:BuildOption_ShowGuild(yPos)

    yPos = yPos - itemSpacing
    UI:BuildOption_ParagonBars(yPos)

    yPos = yPos - itemSpacing
    UI:BuildOption_ParagonRewards(yPos)

    yPos = yPos - itemSpacing * 0.7
    UI:BuildOption_ParagonRewardsOnlyWhenAvailable(yPos)
    UI:BuildOption_ExpandAllButton();
    UI:BuildOption_CollapseAllButton();

    UI:BuildFavouriteStar();
    UI:BuildNotEncounteredFrame();
    UI:BuildInactiveCheckbox();
    UI:BuildIsWatchedBarCheckbox();

    _G.PrettyReps.Callbacks.Trigger("OnUiBuilt")
end

function UI:GetOption(name, default)
    return _G.PrettyReps.DataUtils.GetOption(name, default)
end

function UI:SetOption(name, value)
    _G.PrettyReps.DataUtils.SetOption(name, value)
end

function UI:RebuildRepPanel()
    _G.PrettyReps.RepPanel.RebuildRepPanel()
end

function UI:BuildOptionsFrame(yPos)
    if not self.optionsFrame then
        local frameWidth, frameHeight = 250, 360
        self.optionsFrame = CreateFrame("FRAME", "PrettyRepsOptionsFrame", ReputationFrame, "UIPanelDialogTemplate")
        self.optionsFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", -15, -30)
        self.optionsFrame:SetSize(frameWidth, frameHeight)
        self.optionsFrame:SetFrameStrata("LOW")
        self.optionsFrame:Hide()

        -- Close Button
        PrettyRepsOptionsFrameClose:SetScript("OnClick", function()
            self.optionsFrame:Hide()
            PrettyRepsOptionsButton:Show()
            PrettyRepsOptionsHideButton:Hide()
            PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
        end)

        _G.PrettyReps.Callbacks.Register("OnSelectedFactionChanged", function(factionData)
            self.optionsFrame:Hide()
            PrettyRepsOptionsButton:Show()
            PrettyRepsOptionsHideButton:Hide()
        end)

        _G.PrettyReps.Callbacks.Register("OnPrettyRepsDisabled", function()
            PrettyRepsOptionsButton:Hide()
            PrettyRepsOptionsHideButton:Hide()
            self.optionsFrame:Hide()
        end)

        _G.PrettyReps.Callbacks.Register("OnPrettyRepsEnabled", function()
            PrettyRepsOptionsButton:Show()
        end)

        -- Title
        local title = PrettyRepsOptionsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightCenter")
        title:SetPoint("CENTER", PrettyRepsOptionsFrame, "TOP", 0, -16)
        title:SetText("Pretty Reps")

        -- Options Title
        local optionsTitle = PrettyRepsOptionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalCenter")
        optionsTitle:SetPoint("CENTER", PrettyRepsOptionsFrame, "TOP", -15, -50)
        optionsTitle:SetText("Configure Pretty Reps Tab")

        -- Options Help
        local helpButton = CreateFrame("Button", nil, PrettyRepsOptionsFrame, "UIPanelInfoButton")
        helpButton:SetPoint("TOPRIGHT", PrettyRepsOptionsFrame, -12, -35)
        local helpTooltip = "Pretty Reps can only include factions that have been encountered by at least one character.\n\n"
        helpTooltip = helpTooltip .. "Log into your other characters at least once to load their data into Pretty Reps.\n\n"
        helpTooltip = helpTooltip .. "The " .. playerName .. " tab shows the default WoW reputation UI for this character."
        helpButton:SetScript("OnEnter", function() GameTooltip:SetOwner(helpButton, "ANCHOR_RIGHT") GameTooltip:SetText(helpTooltip) end)
        helpButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end
end

function UI:BuildOption_HeaderTotals(yPos)
    if not self.headerTotalsOptionCheckbox then
        local checkbox = CreateFrame("CheckButton", nil, PrettyRepsOptionsFrame, "ChatConfigCheckButtonTemplate")
        checkbox:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 30, yPos)
        checkbox.Text:SetText("Display Group Totals")
        checkbox.optionsName = "GroupTotals"
        checkbox:SetChecked(self:GetOption(checkbox.optionsName, true))
        checkbox.tooltip = "Display completed reputations in group titles (Completed/Total).\n\n"
        checkbox.tooltip = checkbox.tooltip  .. "Exalted and Best Friend reputations are considered completed."
        UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
        checkbox:SetScript("OnClick", function(self) 
            UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
        end)

        self.headerTotalsOptionCheckbox = checkbox
    end
end

function UI:BuildOption_EnableUnobtainable(yPos)
    if not self.enableUnobtainableOptionCheckbox then
        local checkbox = CreateFrame("CheckButton", nil, PrettyRepsOptionsFrame, "ChatConfigCheckButtonTemplate")
		checkbox:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 30, yPos)
		checkbox.optionsName = "UseUnobtainableGroup"
		checkbox:SetChecked(self:GetOption(checkbox.optionsName, true))
		checkbox.Text:SetText("Use Unobtainable Group")
		checkbox.tooltip = "Reputations that can no longer be earned will be placed here unless you already have exalted."
        UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		checkbox:SetScript("OnClick", function(self) 
			UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		end)

        self.enableUnobtainableOptionCheckbox = checkbox
    end
end

function UI:BuildOption_HideUnobtainable(yPos)
    if not self.hideUnobtainableOptionCheckbox then
        local checkbox = CreateFrame("CheckButton", nil, PrettyRepsOptionsFrame, "ChatConfigCheckButtonTemplate")
		checkbox:SetSize(20, 20)
		checkbox:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 60, yPos)
		checkbox.optionsName = "HideUnobtainableGroup"
		checkbox:SetChecked(self:GetOption(checkbox.optionsName, false))
		checkbox.Text:SetText("Hide")
		checkbox.tooltip = "Hide the unobtainable group and all reputations inside it."
		UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		checkbox:SetScript("OnClick", function(self) 
			UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		end)

        self.hideUnobtainableOptionCheckbox = checkbox
    end
end

function UI:BuildOption_HideInactive(yPos)
    if not self.hideInactiveOptionCheckbox then
        local checkbox = CreateFrame("CheckButton", nil, PrettyRepsOptionsFrame, "ChatConfigCheckButtonTemplate")
		checkbox:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 30, yPos)
		checkbox.optionsName = "HideInactiveGroup"
		checkbox:SetChecked(self:GetOption(checkbox.optionsName, false))
		checkbox.Text:SetText("Hide Inactive Group")
		checkbox.tooltip = "Hide the inactive group and all reputations inside it."
		UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		checkbox:SetScript("OnClick", function(self) 
			UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		end)

        self.hideInactiveOptionCheckbox = checkbox
    end
end

function UI:BuildOption_ShowNameOnHover(yPos)
    if not self.showNameOnHoverOptionCheckbox then
        local checkbox = CreateFrame("CheckButton", nil, PrettyRepsOptionsFrame, "ChatConfigCheckButtonTemplate")
		checkbox:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 30, yPos)
		checkbox.optionsName = "ShowNameOnHover"
		checkbox:SetChecked(self:GetOption(checkbox.optionsName, false))
		checkbox.Text:SetText("Show Name On Hover")
		checkbox.tooltip = "Show the name of the character that earned the reputation."
		UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		checkbox:SetScript("OnClick", function(self) 
			UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		end)

        self.showNameOnHoverOptionCheckbox = checkbox
    end
end

function UI:BuildOption_ShowOppositeFaction(yPos)
    if not self.showOppositeFactionOptionCheckbox then
        local checkbox = CreateFrame("CheckButton", nil, PrettyRepsOptionsFrame, "ChatConfigCheckButtonTemplate")
		checkbox:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 30, yPos)
		checkbox.optionsName = "HideOppositeFaction"
		checkbox:SetChecked(self:GetOption(checkbox.optionsName, true))
		checkbox.Text:SetText("Hide Opposite Faction")
		checkbox.tooltip = "Only show reputations for your current faction (Alliance/Horde)."
		UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		checkbox:SetScript("OnClick", function(self) 
			UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		end)

        self.showOppositeFactionOptionCheckbox = checkbox
    end
end

function UI:BuildOption_ShowGuild(yPos)
    if not self.showGuildOptionCheckbox then
        local checkbox = CreateFrame("CheckButton", nil, PrettyRepsOptionsFrame, "ChatConfigCheckButtonTemplate")
		checkbox:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 30, yPos)
		checkbox.optionsName = "ShowGuild"
		checkbox:SetChecked(self:GetOption(checkbox.optionsName, true))
		checkbox.Text:SetText("Show Guild Reputation")
		checkbox.tooltip = "Display guild reputation for the current character."
		UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		checkbox:SetScript("OnClick", function(self) 
			UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		end)

        self.showGuildOptionCheckbox = checkbox
    end
end

function UI:BuildOption_ParagonBars(yPos)
    if not self.showParagonBarsOptionCheckbox then
		local checkbox = CreateFrame("CheckButton", nil, PrettyRepsOptionsFrame, "ChatConfigCheckButtonTemplate")
		checkbox:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 30, yPos)
		checkbox.optionsName = "ShowParagonBars"
		checkbox:SetChecked(self:GetOption(checkbox.optionsName, true))
		checkbox.Text:SetText("Show Paragon Bars")
		checkbox.tooltip = "Replace green exalted bars with paragon reputation bars for this character."
		UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		checkbox:SetScript("OnClick", function(self) 
			UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		end)

        self.showParagonBarsOptionCheckbox = checkbox
    end
end

function UI:BuildOption_ParagonRewards(yPos)
    if not self.showParagonRewardsOptionCheckbox then
        local checkbox = CreateFrame("CheckButton", nil, PrettyRepsOptionsFrame, "ChatConfigCheckButtonTemplate")
		checkbox:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 30, yPos)
		checkbox.optionsName = "ShowParagonIcons"
		checkbox:SetChecked(self:GetOption(checkbox.optionsName, true))
		checkbox.Text:SetText("Show Paragon Reward Icons")
		checkbox.tooltip = "Display paragon reward icons next to reputation bars."
		UI:SetOption(checkbox.optionsName, checkbox:GetChecked()) 
		checkbox:SetScript("OnClick", function(self) 
			UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		end)

        self.showParagonRewardsOptionCheckbox = checkbox
    end
end

function UI:BuildOption_ParagonRewardsOnlyWhenAvailable(yPos)
    if not self.showParagonRewardsWhenAvailableOptionCheckbox then
        local checkbox = CreateFrame("CheckButton", nil, PrettyRepsOptionsFrame, "ChatConfigCheckButtonTemplate")
		checkbox:SetSize(20, 20)
		checkbox:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 60, yPos)
		checkbox.optionsName = "ParagonIconsRewardOnly"
		checkbox:SetChecked(self:GetOption(checkbox.optionsName, false))
		checkbox.Text:SetText("Only When Available")
		checkbox.tooltip = "Only show paragon reward icons when a reward is available."
		UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		checkbox:SetScript("OnClick", function(self) 
			UI:SetOption(checkbox.optionsName, checkbox:GetChecked())
		end)

        self.showParagonRewardsWhenAvailableOptionCheckbox = checkbox
    end
end

local order = {2, 2, 2, 1, 2, 1, 1}
local orderIndex = 0

function UI:Egg(val)
    orderIndex = orderIndex + 1
    if order[orderIndex] ~= val then
        orderIndex = 0
    elseif orderIndex == #order then
        PrettyRepsOptionsFrame:SetSize(250, 390)
        orderIndex = 0
        local title = PrettyRepsOptionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        title:SetPoint("BOTTOM", PrettyRepsOptionsFrame, "BOTTOM", 0, 15)
        title:SetText("Rachel <3")
    end
end

function UI:BuildOption_ExpandAllButton(yPos)
    if not self.expandAllButton then
        local button = CreateFrame("Button", nil, PrettyRepsOptionsFrame, "UIPanelButtonTemplate")
		button:SetSize(100, 20)
		button:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 30, -320)
		button:SetText("Expand All")
		button:SetScript("OnClick", function()
            UI:Egg(1)
            _G.PrettyReps.DataUtils.ExpandAll(true)
		end)

        self.expandAllButton = button
    end
end

function UI:BuildOption_CollapseAllButton(yPos)
    if not self.collapseAllButton then
        local button = CreateFrame("Button", nil, PrettyRepsOptionsFrame, "UIPanelButtonTemplate")
		button:SetSize(100, 20)
		button:SetPoint("TOPLEFT", PrettyRepsOptionsFrame, 130, -320)
		button:SetText("Collapse All")
		button:SetScript("OnClick", function()
            UI:Egg(2)
            _G.PrettyReps.DataUtils.ExpandAll(false)
		end)

        self.collapseAllButton = button
    end
end

function UI:BuildOptionsButton()
    if not self.optionButtonBuilt then
        CreateFrame("Button", "PrettyRepsOptionsButton", ReputationFrame)
        PrettyRepsOptionsButton:SetPoint("TOPRIGHT", ReputationFrame, "TOPRIGHT", -4, -30)
        PrettyRepsOptionsButton:SetSize(30, 30)
        PrettyRepsOptionsButton:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Up")
        PrettyRepsOptionsButton:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Down")
        PrettyRepsOptionsButton:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-NextPage-Disabled")
        PrettyRepsOptionsButton:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight", "ADD")
        PrettyRepsOptionsButton:SetScript("OnClick", function()
            ReputationDetailFrame:Hide()
            self.optionsFrame:Show()
            PrettyRepsOptionsButton:Hide()
            PrettyRepsOptionsHideButton:Show()
            PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
        end)

        CreateFrame("Button", "PrettyRepsOptionsHideButton", ReputationFrame)
        PrettyRepsOptionsHideButton:SetPoint("TOPRIGHT", ReputationFrame, "TOPRIGHT", -4, -30)
        PrettyRepsOptionsHideButton:SetSize(30, 30)
        PrettyRepsOptionsHideButton:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Up")
        PrettyRepsOptionsHideButton:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Down")
        PrettyRepsOptionsHideButton:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-PrevPage-Disabled")
        PrettyRepsOptionsHideButton:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight", "ADD")
        PrettyRepsOptionsHideButton:Hide()
        PrettyRepsOptionsHideButton:SetScript("OnClick", function()
            self.optionsFrame:Hide()
            PrettyRepsOptionsButton:Show()
            PrettyRepsOptionsHideButton:Hide()
            PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
        end)

        self.optionButtonBuilt = true
    end
end

function UI:BuildNotEncounteredFrame()
    if not self.notEncounteredFrame then
        self.notEncounteredFrame = CreateFrame("FRAME", "PrettyRepsEncounterFrame", ReputationDetailFrame)
        self.notEncounteredFrame:CreateFontString("PrettyRepsEncounterText", "OVERLAY", "GameFontNormalSmall")
        self.notEncounteredFrame:SetPoint("BOTTOMLEFT", ReputationDetailFrame, "BOTTOMLEFT", 12, 10)
        self.notEncounteredFrame:SetSize(188, 50)
        self.notEncounteredFrame:Hide()

        PrettyRepsEncounterText:SetPoint("CENTER", self.notEncounteredFrame, "CENTER", 0, -10)
        PrettyRepsEncounterText:SetText("This character has not yet\nencountered this faction.")

        _G.PrettyReps.Callbacks.Register("OnPrettyRepsDisabled", function()
            self.notEncounteredFrame:Hide()
        end)

        _G.PrettyReps.Callbacks.Register("OnSelectedFactionChanged", function(factionData)
            if factionData.internalIndex then
                self.notEncounteredFrame:Hide()
            else
                self.notEncounteredFrame:Show()
            end
        end)
    end
end

function UI:BuildFavouriteStar()
    if not self.favouriteFrameCheckbox then
        CreateFrame("FRAME", "PrettyRepsFavouriteFrame", ReputationDetailFrame)
        PrettyRepsFavouriteFrame:SetSize(7, 7)
        PrettyRepsFavouriteFrame:SetPoint("BOTTOMRIGHT", ReputationDetailFrame, "BOTTOMRIGHT", -25, 45)

        local checkbox = CreateFrame("CheckButton", "PrettyRepsFavouriteStar", PrettyRepsFavouriteFrame, "ChatConfigCheckButtonTemplate")
        checkbox:SetNormalTexture("Interface/Common/ReputationStar")
        checkbox:SetCheckedTexture("Interface/Common/ReputationStar")
        checkbox:SetHighlightTexture("Interface/Common/ReputationStar")
        checkbox:SetPushedTexture("Interface/Common/ReputationStar")
        checkbox:SetSize(20, 20)
        -- checkbox:GetNormalTexture():SetTexCoord(0.5, 1, 0, 0.5)
        checkbox:GetNormalTexture():SetTexCoord(0, 0.5, 0.5, 1)
        checkbox:GetHighlightTexture():SetTexCoord(0, 0.5, 0.5, 1)
        checkbox:GetCheckedTexture():SetTexCoord(0, 0.5, 0, 0.5)
        checkbox:GetPushedTexture():SetTexCoord(0, 0.5, 0, 0.5)
        checkbox:SetPoint("CENTER", PrettyRepsFavouriteFrame)
        checkbox.tooltip = "Mark as favourite"
        checkbox:SetScript("OnClick", function(self)
            _G.PrettyReps.DataUtils.ToggleFavourite(self:GetChecked())
            if self:GetChecked() then
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            else
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
            end
        end)

        _G.PrettyReps.Callbacks.Register("OnPrettyRepsDisabled", function()
            PrettyRepsFavouriteFrame:Hide()
        end)

        _G.PrettyReps.Callbacks.Register("OnSelectedFactionChanged", function(factionData)
            if factionData.isGuild or factionData.isHeader then
				PrettyRepsFavouriteFrame:Hide()
			else
				PrettyRepsFavouriteFrame:Show()
				PrettyRepsFavouriteStar:SetChecked(factionData.isFavourite)
                -- local isMajorFaction = factionData.factionID and C_Reputation.IsMajorFaction(factionData.factionID)
                -- if isMajorFaction then
                --     PrettyRepsFavouriteFrame:SetPoint("BOTTOMRIGHT", ReputationDetailFrame, "BOTTOMRIGHT", -25, 70)
                -- else
                    PrettyRepsFavouriteFrame:SetPoint("BOTTOMRIGHT", ReputationDetailFrame, "BOTTOMRIGHT", -25, 45)
                -- end
			end
        end)

        self.favouriteFrameCheckbox = checkbox
    end
end

function UI:BuildInactiveCheckbox()
    if not self.inactiveCheckbox then
        local checkbox = CreateFrame("CheckButton", "PrettyRepsInactiveCheckbox", ReputationDetailFrame, "UICheckButtonTemplate")
        checkbox:SetSize(26, 26)
        checkbox:SetPoint("TOPLEFT", ReputationDetailFrame, "TOPLEFT", 14, -143)
        PrettyRepsInactiveCheckboxText:SetText("Move to Inactive")
        checkbox:SetScript("OnClick", function(self) 
            _G.PrettyReps.DataUtils.ToggleInactive(self:GetChecked())
            if self:GetChecked() then
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            else
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
            end
        end)

        _G.PrettyReps.Callbacks.Register("OnPrettyRepsEnabled", function()
            ReputationDetailAtWarCheckBox:Hide()
            ReputationDetailInactiveCheckBox:Hide()
            self.inactiveCheckbox:Show()
        end)

        _G.PrettyReps.Callbacks.Register("OnPrettyRepsDisabled", function()
            ReputationDetailAtWarCheckBox:Show()
            ReputationDetailInactiveCheckBox:Show()
            self.inactiveCheckbox:Hide()
        end)

        _G.PrettyReps.Callbacks.Register("OnSelectedFactionChanged", function(factionData)
            local canSetInactive = not factionData.isHeader and not factionData.isGuild
            self.inactiveCheckbox:SetEnabled(canSetInactive)
            self.inactiveCheckbox:SetChecked(factionData.isInactive)
            local inactiveTextColor = canSetInactive and NORMAL_FONT_COLOR or GRAY_FONT_COLOR
            PrettyRepsInactiveCheckboxText:SetTextColor(inactiveTextColor:GetRGB())
        end)

        self.inactiveCheckbox = checkbox
    end
end

function UI:BuildIsWatchedBarCheckbox()
    if not self.isWatchedCheckbox then
        local checkbox = CreateFrame("CheckButton", "PrettyRepsIsWatchedCheckbox", ReputationDetailFrame, "UICheckButtonTemplate")
        checkbox:SetSize(26, 26)
        checkbox:SetPoint("TOPLEFT", PrettyRepsInactiveCheckbox, "BOTTOMLEFT", 0, 3)
        PrettyRepsIsWatchedCheckboxText:SetText("Show as Experience Bar")
        checkbox:SetScript("OnClick", function(self)
            _G.PrettyReps.DataUtils.ToggleWatched(self:GetChecked())
            if self:GetChecked() then
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            else
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
            end
        end)

        _G.PrettyReps.Callbacks.Register("OnPrettyRepsEnabled", function()
            ReputationDetailMainScreenCheckBox:Hide()
            self.isWatchedCheckbox:Show()
        end)

        _G.PrettyReps.Callbacks.Register("OnPrettyRepsDisabled", function()
            ReputationDetailMainScreenCheckBox:Show()
            self.isWatchedCheckbox:Hide()
        end)

        _G.PrettyReps.Callbacks.Register("OnSelectedFactionChanged", function(factionData)
            if (not factionData.isHeader or factionData.hasRep) and factionData.internalIndex then
                self.isWatchedCheckbox:Show()
                self.isWatchedCheckbox:SetChecked(factionData.isWatched)
            else
                self.isWatchedCheckbox:Hide()
            end
        end)

        self.isWatchedCheckbox = checkbox
    end
end

function UI:BuildTabs()
    if not self.tabsBuilt then
        CreateFrame("FRAME", "PrettyRepsTabFrame", ReputationFrame)
        PrettyRepsTabFrame:CreateFontString("PrettyRepsExaltedText", "ARTWORK", "GameFontHighlight")
        PrettyRepsTabFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPLEFT", 0, -20)
        PrettyRepsTabFrame:SetSize(335, 50)
        PrettyRepsExaltedText:SetPoint("CENTER", PrettyRepsTabFrame, "CENTER", 0, 0)
        ReputationFrameStandingLabel:Hide()
        ReputationFrameFactionLabel:Hide()

        -- Account Active
        accountActiveButton = CreateFrame("Button", nil, PrettyRepsTabFrame)
        accountActiveButton:SetSize(120, 50)
        accountActiveButton:SetPoint("CENTER", PrettyRepsTabFrame, -55, 7)
        accountActiveButton:SetText("Expand All")
        self:SetTabButtonTextures(accountActiveButton, true)
        local txt = accountActiveButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        txt:SetPoint("CENTER", accountActiveButton, "CENTER", 0, -12)
        txt:SetText("Pretty Reps")

        -- Account Inactive
        accountInactiveButton = CreateFrame("Button", nil, PrettyRepsTabFrame)
        accountInactiveButton:SetSize(120, 26)
        accountInactiveButton:SetPoint("CENTER", PrettyRepsTabFrame, -55, -3)
        accountInactiveButton:SetText("Expand All")
        accountInactiveButton:SetScript("OnClick", function(self)
            _G.PrettyReps.DataUtils.Save()
            UI:SetOption("Enabled", true)
            _G.PrettyReps.Enable()
            ReputationDetailFrame:Hide()
            accountActiveButton:Show()
            accountInactiveButton:Hide()
            characterActiveButton:Hide()
            characterInactiveButton:Show()
            PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
        end)
        self:SetTabButtonTextures(accountInactiveButton, false)
        local txt = accountInactiveButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        txt:SetPoint("CENTER", accountInactiveButton, "CENTER", 0, -4)
        txt:SetText("Pretty Reps")
        accountInactiveButton:Hide()

        -- Character Active
        characterActiveButton = CreateFrame("Button", nil, PrettyRepsTabFrame)
        characterActiveButton:SetSize(120, 50)
        characterActiveButton:SetPoint("CENTER", PrettyRepsTabFrame, 55, 7)
        characterActiveButton:SetText("Expand All")
        self:SetTabButtonTextures(characterActiveButton, true)
        local txt = characterActiveButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        txt:SetPoint("CENTER", characterActiveButton, "CENTER", 0, -12)
        txt:SetText(playerName)
        characterActiveButton:Hide()

        -- Character Inactive
        characterInactiveButton = CreateFrame("Button", nil, PrettyRepsTabFrame)
        characterInactiveButton:SetSize(120, 26)
        characterInactiveButton:SetPoint("CENTER", PrettyRepsTabFrame, 55, -3)
        characterInactiveButton:SetText("Expand All")
        characterInactiveButton:SetScript("OnClick", function(self)
            _G.PrettyReps.DataUtils.Save()
            UI:SetOption("Enabled", false)
            _G.PrettyReps.Disable()
            ReputationDetailFrame:Hide()
            characterActiveButton:Show()
            characterInactiveButton:Hide()
            accountActiveButton:Hide()
            accountInactiveButton:Show()
            PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
        end)
        self:SetTabButtonTextures(characterInactiveButton, false)
        local txt = characterInactiveButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        txt:SetPoint("CENTER", characterInactiveButton, "CENTER", 0, -4)
        txt:SetText(playerName)

        self.tabsBuilt = true
    end
end

function UI:SetTabButtonTextures(button, enabled)
    if enabled then
		button:SetNormalTexture("Interface/PaperDollInfoFrame/UI-Character-ActiveTab")
		button:SetPushedTexture("Interface/PaperDollInfoFrame/UI-Character-ActiveTab")
		button:SetHighlightTexture("Interface/PaperDollInfoFrame/UI-Character-ActiveTab")
	else
		button:SetNormalTexture("Interface/PaperDollInfoFrame/UI-Character-InActiveTab")
		button:SetPushedTexture("Interface/PaperDollInfoFrame/UI-Character-InActiveTab")
		button:SetHighlightTexture("Interface/PaperDollInfoFrame/UI-Character-Tab-RealHighlight")
		button:GetHighlightTexture():SetPoint("BOTTOM", -10, -4)
	end
	SetClampedTextureRotation(button:GetNormalTexture(), 180)
	SetClampedTextureRotation(button:GetPushedTexture(), 180)
	SetClampedTextureRotation(button:GetHighlightTexture(), 180)
end